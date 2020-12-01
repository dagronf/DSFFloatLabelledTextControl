//
//  AppDelegate.m
//  DSFFloatLabelledTextControls Demo objc
//
//  Created by Darren Ford on 18/2/20.
//  Copyright © 2020 Darren Ford. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

- (void)floatLabelledTextFieldContentChanged:(DSFFloatLabelledTextField *)field {
	NSLog(@"Password is now `%@`", field.stringValue);
}

@end
