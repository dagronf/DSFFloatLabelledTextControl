//
//  DSFFloatLabelledTextField.swift
//  DSFFloatLabelledTextControls
//
//  Created by Darren Ford on 4/2/19.
//  Copyright © 2020 Darren Ford. All rights reserved.
//
//	MIT License
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.

import Cocoa

@IBDesignable open class DSFFloatLabelledTextField: NSTextField {

	/// The size (in pt) of the floating label text
	@IBInspectable public var placeholderTextSize: CGFloat = NSFont.smallSystemFontSize {
		didSet {
			self.floatingLabel.font = NSFont.systemFont(ofSize: self.placeholderTextSize)
			self.reconfigureControl()
		}
	}

	/// Spacing between the floating label and the text field text
	@IBInspectable public var placeholderSpacing: CGFloat = 0.0 {
		didSet {
			self.floatingLabel.font = NSFont.systemFont(ofSize: self.placeholderTextSize)
			self.reconfigureControl()
		}
	}

	// Override so that we can notify when the developer changes the text programatically too
	open override var stringValue: String {
		get {
			return super.stringValue
		}
		set {
			super.stringValue = newValue
			NotificationCenter.default.post(name: NSControl.textDidChangeNotification, object: self)
		}
	}

	// Override so that we can update when the developer changes the placeholder string
	open override var placeholderString: String? {
		get {
			return super.placeholderString
		}
		set {
			super.placeholderString = newValue
			self.floatingLabel.stringValue = newValue ?? ""
		}
	}

	/// Floating label
	private let floatingLabel = NSTextField()

	/// Is the label currently showing
	private var isShowing: Bool = false

	/// Constraint to tie the label to the top of the control
	private var floatingTop: NSLayoutConstraint?

	/// Height of the control
	private var heightConstraint: NSLayoutConstraint?

	/// Observers for the font and placeholder text
	private var fontObserver: NSKeyValueObservation?
	private var placeholderObserver: NSKeyValueObservation?

	/// Returns the height of the placeholder text
	var placeholderHeight: CGFloat {
		let layoutManager = NSLayoutManager()
		return layoutManager.defaultLineHeight(for: self.floatingLabel.font!) + 1
	}

	/// Returns the height of the primary (editable) text
	private var textHeight: CGFloat {
		let layoutManager = NSLayoutManager()
		return layoutManager.defaultLineHeight(for: self.font!) + 1
	}

	/// Returns the total height of the control given the font settings
	private var controlHeight: CGFloat {
		return self.textHeight + self.placeholderSpacing + self.placeholderHeight
	}

	/// Returns of the color for the floating text
	private var floatTextColor: NSColor {
		if #available(macOS 10.14, *) {
			return NSColor.controlAccentColor
		}
		else {
			return NSColor.headerTextColor
		}
	}

	open override var intrinsicContentSize: NSSize {
		var sz = super.intrinsicContentSize
		sz.height = self.controlHeight
		return sz
	}

	/// Return the custom cell type
	fileprivate lazy var fieldCell: DSFFloatLabelledTextFieldCell = {
		let customCell = DSFFloatLabelledTextFieldCell()
		customCell.topOffset = self.placeholderHeight

		customCell.isEditable = true
		customCell.wraps = false
		customCell.usesSingleLineMode = true
		customCell.placeholderString = self.placeholderString
		customCell.title = self.stringValue
		customCell.font = self.font
		customCell.isBordered = self.isBordered
		customCell.isBezeled = self.isBezeled
		customCell.bezelStyle = self.bezelStyle
		customCell.isScrollable = true
		customCell.isContinuous = self.isContinuous
		customCell.alignment = self.alignment
		customCell.formatter = self.formatter

		self.cell = customCell

		return customCell
	}()

	/// Set the fonts to be used in the control
	open func setFonts(primary: NSFont, secondary: NSFont) {
		self.floatingLabel.font = secondary
		self.font = primary
	}

	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.setup()
	}

	required public init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setup()
	}

	open override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()

		// When we're added to the view, make sure that the floating label alignment matches us
		// (as the user might have changed the alignment BEFORE adding to the superview
		self.floatingLabel.alignment = self.alignment
	}

	private func setup() {
		// Setup the common elements of the control
		self.commonSetup()

		// Listen to changes in the primary font so we can reconfigure to match
		self.fontObserver = self.observe(\.font, options: [.new]) { [weak self] _, _ in
			self?.reconfigureControl()
		}

		// Listen to changes in the placeholder text so we can reflect it in the floater
		self.placeholderObserver = self.observe(\.placeholderString, options: [.new]) { [weak self] _, _ in
			guard let `self` = self else { return }
			self.floatingLabel.stringValue = self.placeholderString!
			self.reconfigureControl()
		}
	}

	/// Build the floating label
	private func createFloatingLabel() {
		if self.floatingLabel.superview == nil {
			self.addSubview(self.floatingLabel)
		}

		self.floatingLabel.wantsLayer = true
		self.floatingLabel.isEditable = false
		self.floatingLabel.isSelectable = false
		self.floatingLabel.isEnabled = true
		self.floatingLabel.isBezeled = false
		self.floatingLabel.isBordered = false
		self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
		self.floatingLabel.font = NSFont.systemFont(ofSize: self.placeholderTextSize)
		self.floatingLabel.textColor = self.floatTextColor
		self.floatingLabel.stringValue = self.placeholderString ?? ""
		self.floatingLabel.alphaValue = 0.0
		self.floatingLabel.alignment = self.alignment
		self.floatingLabel.drawsBackground = false

		self.floatingTop = NSLayoutConstraint(
			item: self.floatingLabel, attribute: .top,
			relatedBy: .equal,
			toItem: self, attribute: .top,
			multiplier: 1.0, constant: 10
		)
		self.addConstraint(self.floatingTop!)

		var x = NSLayoutConstraint(
			item: self.floatingLabel, attribute: .leading,
			relatedBy: .equal,
			toItem: self, attribute: .leading,
			multiplier: 1.0, constant: self.isBezeled ? 4 : 0
		)
		self.addConstraint(x)

		x = NSLayoutConstraint(
			item: self.floatingLabel, attribute: .trailing,
			relatedBy: .equal,
			toItem: self, attribute: .trailing,
			multiplier: 1.0, constant: self.isBezeled ? -4 : 0
		)
		self.addConstraint(x)
	}

	private func commonSetup() {
		self.wantsLayer = true
		self.translatesAutoresizingMaskIntoConstraints = false
		self.usesSingleLineMode = true
		self.delegate = self

		// Default to natural layout
		self.alignment = .natural

		self.createFloatingLabel()

		self.heightConstraint = NSLayoutConstraint(
			item: self, attribute: .height,
			relatedBy: .equal,
			toItem: nil, attribute: .notAnAttribute,
			multiplier: 1.0, constant: self.controlHeight
		)
		self.addConstraint(self.heightConstraint!)

		// If the field already has text, make sure the placeholder is shown
		if self.stringValue.count > 0 {
			self.showPlaceholder(animated: false)
		}
	}

	/// Change the layout if any changes occur
	private func reconfigureControl() {
		if self.isCurrentFocus() {
			/// If we are currently editing, then finish before changing.
			self.window?.endEditing(for: nil)
		}
		self.fieldCell.topOffset = self.placeholderHeight + self.placeholderSpacing

		self.expandFrame()
		self.needsLayout = true
	}

	/// Rebuild the frame of the text field to match the new settings
	private func expandFrame() {
		self.heightConstraint?.constant = self.controlHeight
		self.fieldCell.topOffset = self.placeholderHeight + self.placeholderSpacing
	}
}

// MARK: - Focus and editing

extension DSFFloatLabelledTextField: NSTextFieldDelegate {

	// Change the floating label color to represent active state
	private func setFloatingLabelActive(_ active: Bool) {
		if active {
			self.floatingLabel.textColor = self.floatTextColor
		}
		else {
			self.floatingLabel.textColor = NSColor.placeholderTextColor
		}
	}

	public func controlTextDidChange(_ obj: Notification) {
		guard let field = obj.object as? NSTextField else {
			return
		}

		if field.stringValue.count > 0, !self.isShowing {
			self.showPlaceholder(animated: true)
		}
		else if field.stringValue.count == 0, self.isShowing {
			self.hidePlaceholder()
		}
	}

	open override func becomeFirstResponder() -> Bool {
		let becomeResult = super.becomeFirstResponder()
		if becomeResult, self.isCurrentFocus() {
			// Set the color of the 'label' to match the current focus color.
			// We need to perform this on the main thread after the current set of notifications are processed
			// Why? We (occasionally) receive a 'controlTextDidEndEditing' message AFTER we receive a
			// 'becomeFirstResponder'.  I've read that this is related to the text field automatically selecting
			// text when taking focus, but I haven't been able to verify this in any useful manner.
			DispatchQueue.main.async { [weak self] in
				if let `self` = self {
					self.setFloatingLabelActive(true)
				}
			}
		}
		return becomeResult
	}

	open func controlTextDidEndEditing(_: Notification) {
		// When we lose focus, set the label color back to the placeholder color
		self.setFloatingLabelActive(false)
	}

	/// Does our text field currently have input focus?
	private func isCurrentFocus() -> Bool {
		// 1. Get the window's first responder
		// 2. Check is has an active field editor
		// 3. Is the delegate of the field editor us?
		if let fr = self.window?.firstResponder as? NSTextView,
			self.window?.fieldEditor(false, for: nil) != nil,
			fr.delegate === self {
			return true
		}
		return false
	}
}

// MARK: - Animations

extension DSFFloatLabelledTextField {

	/// Duration of the fade in/out of the secondary label
	private var animationDuration: TimeInterval {
		return shouldAnimate() ? 0.4 : 0.0
	}

	/// Returns true if the system is NOT set to reduce motion (accessibility settings)
	private func shouldAnimate() -> Bool {
		if #available(OSX 10.12, *) {
			return !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
		} else {
			// Fallback on earlier versions. Just animate
			return true
		}
	}

	private func showPlaceholder(animated: Bool) {
		self.isShowing = true
		if animated {
			NSAnimationContext.runAnimationGroup({ [weak self] context in
				guard let `self` = self else { return }
				context.allowsImplicitAnimation = true
				context.duration = self.animationDuration
				self.floatingTop?.constant = 0
				self.floatingLabel.alphaValue = 1.0
				self.layoutSubtreeIfNeeded()
			}, completionHandler: {
				//
			})
		}
		else {
			self.setFloatingLabelActive(false)
			self.floatingTop?.constant = 0
			self.floatingLabel.alphaValue = 1.0
		}
	}

	private func hidePlaceholder() {
		self.isShowing = false
		let duration = self.animationDuration
		NSAnimationContext.runAnimationGroup({ [weak self] context in
			guard let `self` = self else { return }
			context.allowsImplicitAnimation = true
			context.duration = duration
			self.floatingTop?.constant = self.textHeight / 1.5
			self.floatingLabel.alphaValue = 0.0
			self.layoutSubtreeIfNeeded()
		}, completionHandler: {
			//
		})
	}
}

// MARK: - Cell definition

private class DSFFloatLabelledTextFieldCell: NSTextFieldCell {
	var topOffset: CGFloat = 0

	private func offset() -> CGFloat {
		return self.topOffset - (self.isBezeled ? 5 : 1)
	}

	override func titleRect(forBounds rect: NSRect) -> NSRect {
		return NSRect(x: rect.origin.x, y: rect.origin.y + self.offset(), width: rect.width, height: rect.height)
	}

	override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
		let insetRect = NSRect(x: rect.origin.x, y: rect.origin.y + self.offset(), width: rect.width, height: rect.height)
		super.edit(withFrame: insetRect, in: controlView, editor: textObj, delegate: delegate, event: event)
	}

	override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
		let insetRect = NSRect(x: rect.origin.x, y: rect.origin.y + self.offset(), width: rect.width, height: rect.height)
		super.select(withFrame: insetRect, in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
	}

	override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
		let insetRect = NSRect(x: cellFrame.origin.x, y: cellFrame.origin.y + self.offset(), width: cellFrame.width, height: cellFrame.height)
		super.drawInterior(withFrame: insetRect, in: controlView)
	}
}

