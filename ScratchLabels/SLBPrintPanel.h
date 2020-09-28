//
//  SLBPrintPanel.h
//  ScratchLabels
//
//  Created by Andy Lee on 9/23/20.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// This NSPrintPanel subclass works around a "feature" in macOS where if your printer supports double-sided printing,
/// the print panel always defaults to double-sided.  You have to manually change it to single-sided every time if that's
/// what you want.  This is annoying in general, and specifically not desirable for a label-printing app, where it's never okay
/// if you accidentally print double-sided.
///
/// You would think you could simply set the PMDuplexMode in the NSPrintInfo, but that doesn't work -- the value of the
/// duplex mode gets reset to double-sided the moment the print panel is displayed.  The workaround here sets the
/// PMDuplexMode immediately **after** the print panel is displayed, before the user interacts with it.  This is done in an
/// override of beginSheetWithPrintInfo:modalForWindow:delegate:didEndSelector:contextInfo:.  So the hack only works
/// if you display the print panel in a sheet.
///
/// The workaround here also hides the "Two-Sided" check box, which happens to be what I want anyway for this app,
/// because I never want double-sided printing when I'm printing labels.  If I wanted to display that check box but forcing
/// single-sided to be the default, I don't know offhand how I'd do that.
///
/// More details about this problem and workaround are in the code comments.
///
/// [UPDATE 2020-09-27: I recently updated to the latest Big Sur beta, and I **think** the print panel now remembers the
/// duplex setting to whatever you last set it to.  But I still can't seem to force it to single-sided by updating the print info.]
@interface SLBPrintPanel : NSPrintPanel

#pragma mark - NSPrintPanel methods

/// Override.  Returns a print panel configured with NSPrintPanelOptions appropriate for this app:
///
/// - Show a preview.
/// - Show the page-range selection fields.
/// - **Don't** show the number-of-copies field.  See beginSheetWithPrintInfo:modalForWindow:delegate:didEndSelector:contextInfo: for why.
+ (NSPrintPanel *)printPanel;

/// Override. 
- (void)beginSheetWithPrintInfo:(NSPrintInfo *)incomingPrintInfo modalForWindow:(NSWindow *)docWindow delegate:(nullable id)delegate didEndSelector:(nullable SEL)didEndSelector contextInfo:(nullable void *)contextInfo;

@end

NS_ASSUME_NONNULL_END
