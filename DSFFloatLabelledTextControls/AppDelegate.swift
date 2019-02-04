//
//  AppDelegate.swift
//  DSFFloatLabelledTextControls
//
//  Created by Darren Ford on 4/2/19.
//  Copyright © 2019 Darren Ford. All rights reserved.
//

import Cocoa

import DSFFloatLabelledTextControl

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!
	@IBOutlet weak var firstField: DSFFloatLabelledTextField!


	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

		self.firstField.setFonts(
			primary: NSFont.systemFont(ofSize: 24),
			secondary: NSFont.systemFont(ofSize: 14)
		)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}
