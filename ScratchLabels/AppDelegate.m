//
//  AppDelegate.m
//  ScratchLabels
//
//  Created by Andy Lee on 9/20/20.
//

#import "AppDelegate.h"
#import "MainWindowController.h"

@interface AppDelegate ()
@property (strong) MainWindowController *mainWC;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	self.mainWC = [[MainWindowController alloc] initWithWindowNibName:@"MainWindowController"];
	[self.mainWC.window display];
}

@end
