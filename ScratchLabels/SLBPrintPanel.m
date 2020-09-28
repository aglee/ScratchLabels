//
//  SLBPrintPanel.m
//  ScratchLabels
//
//  Created by Andy Lee on 9/23/20.
//

#import "SLBPrintPanel.h"
#import <ApplicationServices/ApplicationServices.h>

@implementation SLBPrintPanel

///// Useful for debugging.  Returns the printInfo's duplex mode, which is either nil (meaning no duplex mode has been set)
///// or the NSNumber equivalent of a PMDuplexMode.  A value of 1 means single-sided printing, 2 means double-sided.
///// Other values are possible -- see the docs for PMDuplexMode.
//static NSNumber *GetDuplexMode(NSPrintInfo *printInfo) {
//	return printInfo.printSettings[@"com_apple_print_PrintSettings_PMDuplexing"];
//}

/// Sets printInfo's duplex mode to kPMDuplexNone, meaning single-sided printing.  Returns noErr if successful.
static OSStatus SetDuplexModeToSingleSided(NSPrintInfo *printInfo) {
	PMPrintSettings pmPrintSettings = printInfo.PMPrintSettings;
	OSStatus result = PMSetDuplex(pmPrintSettings, kPMDuplexNone);
	if (result == noErr) {
		[printInfo updateFromPMPrintSettings];
	} else {
		NSLog(@"+++ WARNING: Failed to make print info <%p> single-sided -- %d", printInfo, result);
	}
	return result;
}

#pragma mark - NSPrintPanel methods

+ (NSPrintPanel *)printPanel {
	NSPrintPanel *printPanel = [super printPanel];
	printPanel.options = (/*NSPrintPanelShowsCopies |*/ NSPrintPanelShowsPageRange | NSPrintPanelShowsPreview);
	return printPanel;
}

- (void)beginSheetWithPrintInfo:(NSPrintInfo *)incomingPrintInfo modalForWindow:(NSWindow *)docWindow delegate:(nullable id)delegate didEndSelector:(nullable SEL)didEndSelector contextInfo:(nullable void *)contextInfo {

	// Open the sheet by calling super.  In macOS as of this writing, this call sets the
	// print info's duplex mode to double-sided, no matter what the user previously chose.
	[super beginSheetWithPrintInfo:incomingPrintInfo modalForWindow:docWindow delegate:delegate didEndSelector:didEndSelector contextInfo:contextInfo];

	// Hack around this by immediately changing the print info to single-sided.  This does
	// not update the print panel's UI -- the check box still shows double-sided -- but
	// for purposes of this app I don't want to show that check box anyway, so I hide it
	// by excluding NSPrintPanelShowsCopies in the override of +printPanel.  This means
	// the number-of-copies text field is also hidden, but again that happens to be what I
	// want for this app.
	OSStatus errorCode = SetDuplexModeToSingleSided(self.printInfo);
	if (errorCode != noErr) {
		NSLog(@"+++ ERROR: Failed to make the print panel's NSPrintInfo <%p> single-sided -- %d",  self.printInfo, errorCode);
		return;
	}
}

@end
