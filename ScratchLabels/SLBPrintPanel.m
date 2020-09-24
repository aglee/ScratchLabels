//
//  SLBPrintPanel.m
//  ScratchLabels
//
//  Created by Andy Lee on 9/23/20.
//

#import "SLBPrintPanel.h"
#import <ApplicationServices/ApplicationServices.h>

@implementation SLBPrintPanel

/// Returns the printInfo's duplex mode, which is either nil (meaning no duplex mode has been set) or the NSNumber
/// equivalent of a PMDuplexMode.  A value of 1 means single-sided printing, 2 means double-sided.  Other values are
/// also possible -- see the docs for PMDuplexMode.
static NSNumber *GetDuplexMode(NSPrintInfo *printInfo) {
	return printInfo.printSettings[@"com_apple_print_PrintSettings_PMDuplexing"];
}

/// Sets printInfo's duplex mode to kPMDuplexNone, meaning single-sided printing.  Returns noErr if successful.
static OSStatus SetDuplexModeToSingleSided(NSPrintInfo *printInfo) {
	PMPrintSettings pmPrintSettings = printInfo.PMPrintSettings;
	OSStatus result = PMSetDuplex(pmPrintSettings, kPMDuplexNone);
	if (result == noErr) {
		[printInfo updateFromPMPrintSettings];
	}
	return result;
}

#pragma mark - NSPrintPanel methods

+ (NSPrintPanel *)printPanel {
	NSPrintPanel *printPanel = [super printPanel];
	printPanel.options = (/*NSPrintPanelShowsCopies |*/ NSPrintPanelShowsPageRange | NSPrintPanelShowsPreview);
	return printPanel;
}

- (void)beginSheetWithPrintInfo:(NSPrintInfo *)incomingPrintInfo modalForWindow:(NSWindow *)docWindow delegate:(id)delegate didEndSelector:(SEL)didEndSelector contextInfo:(void *)contextInfo {

	OSStatus errorCode = noErr;

	// Set the incoming printInfo to be single-sided, just to prove I'm seeing what I
	// think I'm seeing.  In my tests with my printer, the incoming duplex mode is nil.
	NSLog(@"+++ beginSheet -- incoming duplex mode = %@", GetDuplexMode(incomingPrintInfo));
	errorCode = SetDuplexModeToSingleSided(incomingPrintInfo);
	if (errorCode != noErr) {
		NSLog(@"+++ ERROR: Failed to make incoming NSPrintInfo <%p> single-sided -- %d",  incomingPrintInfo, errorCode);
		return;
	}
	NSLog(@"+++ beginSheet -- incoming duplex mode after coercing = %@", GetDuplexMode(incomingPrintInfo));

	// Open the sheet.  In my tests with my printer, this call sets the print info's
	// duplex mode to double-sided, blowing away the value I set above.
	[super beginSheetWithPrintInfo:incomingPrintInfo modalForWindow:docWindow delegate:delegate didEndSelector:didEndSelector contextInfo:contextInfo];
	NSLog(@"+++ beginSheet -- duplex mode after opening sheet = %@", GetDuplexMode(self.printInfo));

	// Correct for this by immediately changing the print info back to single-sided.
	// Unfortunately this does not update the print panel's UI -- the check box still
	// shows double-sided.  For purposes of this app I don't want to show that check box
	// anyway, hence excluding NSPrintPanelShowsCopies in the override of +printPanel.
	// When the actual printing is done, it will be single-sided.
	errorCode = SetDuplexModeToSingleSided(self.printInfo);
	if (errorCode != noErr) {
		NSLog(@"+++ ERROR: Failed to make the print panel's NSPrintInfo <%p> single-sided -- %d",  self.printInfo, errorCode);
		return;
	}
	NSLog(@"+++ beginSheet -- duplex mode after re-coercing = %@", GetDuplexMode(self.printInfo));
}

@end
