//
//  DSFFloatLabelledTextField.swift
//  DSFFloatLabelledTextControls
//
//  Created by Darren Ford on 4/2/19.
//  Copyright © 2019 Darren Ford. All rights reserved.
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

class DSFFloatLabelledTextFieldCell: NSTextFieldCell
{
	var topOffset: CGFloat = 0

	private func offset() -> CGFloat
	{
		return self.topOffset - (self.isBezeled ? 5 : 1)
	}

	override func titleRect(forBounds rect: NSRect) -> NSRect
	{
		return NSRect(x: rect.origin.x, y: rect.origin.y + self.offset(), width: rect.width, height: rect.height)
	}

	override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?)
	{
		let insetRect = NSRect(x: rect.origin.x, y: rect.origin.y + self.offset(), width: rect.width, height: rect.height)
		super.edit(withFrame: insetRect, in: controlView, editor: textObj, delegate: delegate, event: event)
	}

	override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int)
	{
		let insetRect = NSRect(x: rect.origin.x, y: rect.origin.y + self.offset(), width: rect.width, height: rect.height)
		super.select(withFrame: insetRect, in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
	}

	override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView)
	{
		let insetRect = NSRect(x: cellFrame.origin.x, y: cellFrame.origin.y + self.offset(), width: cellFrame.width, height: cellFrame.height)
		super.drawInterior(withFrame: insetRect, in: controlView)
	}
}

@IBDesignable open class DSFFloatLabelledTextField: NSTextField
{
	@IBInspectable public var placeholderTextSize: CGFloat = 10
		{
		didSet
		{
			self.floatingLabel?.font = NSFont.systemFont(ofSize: self.placeholderTextSize)
			self.reconfigureControl()
		}
	}

	/// Floating label
	private var floatingLabel: NSTextField?

	/// Is the label currently showing
	private var isShowing: Bool = false

	/// Constraint to tie the label to the top of the control
	private var floatingTop: NSLayoutConstraint?

	/// Height of the control
	private var heightConstraint: NSLayoutConstraint?

	/// Observers for the font and placeholder text
	private var fontObserver: NSKeyValueObservation?
	private var placeholderObserver: NSKeyValueObservation?

	/// Set the fonts to be used in the control
	open func setFonts(primary: NSFont, secondary: NSFont)
	{
		self.floatingLabel?.font = secondary
		self.font = primary
	}

	open override func viewDidMoveToWindow()
	{
		// Clean up if the view has been moved to another parent
		self.floatingLabel?.removeFromSuperview()

		// Setup the control
		self.commonSetup()

		// Listen to changes in the primary font so we can reconfigure to match
		self.fontObserver = self.observe(\.font, options: [.new])
		{ _, _ in
			self.reconfigureControl()
		}

		// Listen to changes in the placeholder text so we can reflect it in the floater
		self.placeholderObserver = self.observe(\.placeholderString, options: [.new])
		{ _, _ in
			self.floatingLabel?.stringValue = self.placeholderString!
			self.reconfigureControl()
		}
	}

	private func createFloatingLabel()
	{
		let label = NSTextField()
		label.wantsLayer = true
		label.isEditable = false
		label.isSelectable = false
		label.isEnabled = true
		label.isBezeled = false
		label.isBordered = false
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = NSFont.systemFont(ofSize: self.placeholderTextSize)
		label.textColor = NSColor.controlAccentColor
		label.stringValue = self.placeholderString ?? ""
		label.alphaValue = 0.0
		label.alignment = self.alignment
		label.drawsBackground = false
		self.addSubview(label)
		self.floatingLabel = label

		self.floatingTop = NSLayoutConstraint(
			item: self.floatingLabel!, attribute: .top,
			relatedBy: .equal,
			toItem: self, attribute: .top,
			multiplier: 1.0, constant: 10)
		self.addConstraint(self.floatingTop!)

		var x = NSLayoutConstraint(
			item: label, attribute: .leading,
			relatedBy: .equal,
			toItem: self, attribute: .leading,
			multiplier: 1.0, constant: self.isBezeled ? 4 : 0)
		self.addConstraint(x)

		x = NSLayoutConstraint(
			item: label, attribute: .trailing,
			relatedBy: .equal,
			toItem: self, attribute: .trailing,
			multiplier: 1.0, constant: self.isBezeled ? -4 : 0)
		self.addConstraint(x)
	}

	private func createCustomCell()
	{
		let customCell = DSFFloatLabelledTextFieldCell()
		customCell.topOffset = self.placeholderHeight()

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

		self.cell? = customCell
	}

	private func commonSetup()
	{
		self.wantsLayer = true
		self.translatesAutoresizingMaskIntoConstraints = false
		self.usesSingleLineMode = true
		self.delegate = self

		self.createFloatingLabel()
		self.createCustomCell()

		self.heightConstraint = NSLayoutConstraint(
			item: self, attribute: .height,
			relatedBy: .equal,
			toItem: nil, attribute: .notAnAttribute,
			multiplier: 1.0, constant: self.controlHeight())
		self.addConstraint(self.heightConstraint!)

		// If the field already has text, make sure the placeholder is shown
		if self.stringValue.count > 0
		{
			self.showPlaceholder()
		}
	}

	/// Returns the height of the placeholder text
	private func placeholderHeight() -> CGFloat
	{
		let text: NSString = self.placeholderString! as NSString
		let rect = text.boundingRect(with: NSSize(width: 0, height: 0), options: [], attributes: [.font: self.floatingLabel!.font!], context: nil)
		return rect.height
	}

	/// Returns the height of the primary (editable) text
	private func textHeight() -> CGFloat
	{
		let text: NSString = self.placeholderString! as NSString
		let rect = text.boundingRect(with: NSSize(width: 0, height: 0), options: [], attributes: [.font: self.font!], context: nil)
		return rect.height
	}

	/// Returns the total height of the control given the font settings
	private func controlHeight() -> CGFloat
	{
		return self.textHeight() + self.placeholderHeight()
	}

	/// Change the layout if any changes occur
	private func reconfigureControl()
	{
		if self.currentlyBeingEdited()
		{
			self.window?.endEditing(for: nil)
		}
		self.fieldCell().topOffset = self.placeholderHeight()

		self.expandFrame()
		self.needsLayout = true
	}

	/// Rebuild the frame of the text field to match the new settings
	private func expandFrame()
	{
		self.heightConstraint?.constant = self.controlHeight()
		self.fieldCell().topOffset = self.placeholderHeight()
	}
}

// MARK: - Focus and editing

extension DSFFloatLabelledTextField: NSTextFieldDelegate
{
	public func controlTextDidChange(_ obj: Notification)
	{
		guard let field = obj.object as? NSTextField else
		{
			return
		}

		if field.stringValue.count > 0 && !self.isShowing
		{
			self.showPlaceholder()
		}
		else if field.stringValue.count == 0 && self.isShowing
		{
			self.hidePlaceholder()
		}
	}

	fileprivate func isCurrentFocus() -> Bool
	{
		if let fr = self.window?.firstResponder as? NSTextView,
			self.window?.fieldEditor(false, for: nil) != nil,
			fr.delegate === self
		{
			return true
		}
		return false
	}

	open override func becomeFirstResponder() -> Bool
	{
		let becomeResult = super.becomeFirstResponder()
		if becomeResult && self.isCurrentFocus()
		{
			self.floatingLabel?.textColor = NSColor.controlAccentColor
			self.floatingLabel?.needsDisplay = true
		}
		return becomeResult
	}

	open func controlTextDidEndEditing(_ obj: Notification)
	{
		self.floatingLabel?.textColor = NSColor.secondaryLabelColor
	}

	/// Helper function to get the current cell as the custom cell type
	private func fieldCell() -> DSFFloatLabelledTextFieldCell
	{
		return self.cell as! DSFFloatLabelledTextFieldCell
	}

	/// If we are currently being edited (has focus) then lose focus BEFORE the changes
	private func currentlyBeingEdited() -> Bool
	{
		if let responder = self.window?.firstResponder,
			let view = responder as? NSTextView,
			view.isFieldEditor, view.delegate === self
		{
			return true
		}
		return false
	}
}

// MARK: - Animations

extension DSFFloatLabelledTextField
{
	private func showPlaceholder()
	{
		self.isShowing = true
		NSAnimationContext.runAnimationGroup({ context in
			context.allowsImplicitAnimation = true
			context.duration = 0.4
			self.floatingTop?.constant = 0
			self.floatingLabel?.alphaValue = 1.0
			self.layoutSubtreeIfNeeded()
		}, completionHandler: {
			//
		})
	}

	private func hidePlaceholder()
	{
		self.isShowing = false
		NSAnimationContext.runAnimationGroup({ context in
			context.allowsImplicitAnimation = true
			context.duration = 0.4
			self.floatingTop?.constant = self.textHeight() / 1.5
			self.floatingLabel?.alphaValue = 0.0
			self.layoutSubtreeIfNeeded()
		}, completionHandler: {
			//
		})
	}
}
