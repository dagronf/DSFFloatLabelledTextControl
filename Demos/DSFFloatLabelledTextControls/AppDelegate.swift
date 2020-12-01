//
//  AppDelegate.swift
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

import DSFFloatLabelledTextField

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!
	@IBOutlet weak var topFloatingLabel: DSFFloatLabelledTextField!

	@IBOutlet weak var passwordFloatingLabel: DSFFloatLabelledTextField!

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

		let ft = DSFFloatLabelledTextField()
		ft.alignment = .natural
		ft.placeholderString = "Dynamic Created"
		ft.font = NSFont.systemFont(ofSize: 16)

		let cv = self.window.contentView!

		let x = NSLayoutConstraint(item: ft, attribute: .width,
								   relatedBy: .equal,
								   toItem: nil, attribute: .notAnAttribute,
								   multiplier: 1, constant: 300)
		ft.addConstraint(x)
		cv.addSubview(ft)



		let x1 = NSLayoutConstraint(item: ft, attribute: .left,
									relatedBy: .equal,
									toItem: cv, attribute: .left,
									multiplier: 1, constant: 20)
		cv.addConstraint(x1)

		let x2 = NSLayoutConstraint(item: ft, attribute: .bottom,
									relatedBy: .equal,
									toItem: cv, attribute: .bottom,
									multiplier: 1, constant: -20)
		cv.addConstraint(x2)
	}

	@IBAction func resetPressed(_ sender: Any) {
		// Verify that when we programatically change the string value the control updates accordingly
		self.topFloatingLabel.stringValue = "Reset the content"
		self.topFloatingLabel.placeholderString = "Updated placeholder string"
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
}

extension AppDelegate: DSFFloatLabelledTextFieldDelegate {
	func floatLabelledTextField(_ field: DSFFloatLabelledTextField, didShowFloatingLabel didShow: Bool) {
		if field === topFloatingLabel {
			if didShow {
				Swift.print("Title Field floating label is now visible")
			}
			else {
				Swift.print("Title Field floating label is no longer visible")
			}
		}
	}

	func floatLabelledTextField(_ field: DSFFloatLabelledTextField, didFocus: Bool) {
		if field === topFloatingLabel {
			if didFocus {
				Swift.print("Title Field did focus")
			}
			else {
				Swift.print("Title Field lost focus")
			}
		}
	}

	func floatLabelledTextFieldContentChanged(_ field: DSFFloatLabelledTextField) {
		if field === passwordFloatingLabel {
			Swift.print("Password is now '\(self.passwordFloatingLabel.stringValue)'")
		}
	}
}
