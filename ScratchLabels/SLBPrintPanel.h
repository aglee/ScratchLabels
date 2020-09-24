//
//  SLBPrintPanel.h
//  ScratchLabels
//
//  Created by Andy Lee on 9/23/20.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// This NSPrintPanel subclass works around a problem where the print panel always defaults to double-sided.
///
/// In my testing, with my printer, I find I have to uncheck the "Two-Sided" check box every time to get single-sided.  It's
/// not just in this app -- it happens *every* time when I print in *any* app.  It's really annoying when I forget and print
/// double-sided by mistake.  The printer is a Brother HL-L2395DW, and I'm seeing the problem on Mojave and the
/// Big Sur beta.
///
/// You would think I could simply set the PMDuplexMode in the NSPrintInfo, but when I do that in what seems a normal
/// way, the value of the duplex mode gets reset to double-sided the moment the print panel is displayed.  The kludgy
/// workaround here sets the PMDuplexMode inside an overridden NSPrintPanel method.
///
/// The workaround here also hides the "Two-Sided" check box, which happens to be what I want anyway for this app,
/// because I never want double-sided printing when I'm printing labels..  If I wanted to display that check box but forcing
/// single-sided to be the default, I don't know offhand how I'd do that.
///
/// More details about this problem and workaround are in the code comments.
@interface SLBPrintPanel : NSPrintPanel

#pragma mark - NSPrintPanel methods

/// Returns a print panel configured with NSPrintPanelOptions appropriate for this app.
+ (NSPrintPanel *)printPanel;

@end

NS_ASSUME_NONNULL_END
