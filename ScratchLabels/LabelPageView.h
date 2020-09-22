//
//  LabelPageView.h
//  ScratchLabels
//
//  Created by Andy Lee on 9/20/20.
//

#import <Cocoa/Cocoa.h>
#import "MailingAddress.h"

NS_ASSUME_NONNULL_BEGIN

/// This view is used to print mailing addresses on labels.  It is hard-coded to expect Avery 5260 address labels.  Each label is 1" x 2 5/8".  Each sheet contains 30 labels, arranged in 10 rows of 3.
///
/// When the view is displayed in a window, it shows one page of labels.  It's essentially a print preview.
///
/// For help understanding Cocoa printing logic, see "Laying Out Page Content" at <https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Printing/osxp_pagination/osxp_pagination.html#//apple_ref/doc/uid/20001051-BBCHHAHI>.  The high-level story is:
///
/// - Your program prints by telling AppKit to print a view (see the use of NSPrintOperation).
/// - AppKit displays a print panel to the user.  It handles the business of selecting the printer and connecting to it.
/// - The view's drawRect: is invoked to draw the view's contents on a special graphics context that represents printer output.
/// - Printing introduces the notion of pagination.  Depending on the size of the view and the requirements of your application, the printing of the view may have to span multiple pages of paper.  You may want to draw things differently when printing than when displaying the view on the screen.  To customize pagination behavior, LabelPageView does the following:
/// 	- Overrides `knowsPageRange:` and `rectForPage:`.
///		- Has different code branches in drawRect: to draw differently depending on whether it's drawing on-screen or to the printer.
@interface LabelPageView : NSView

/// One address will be printed on each label.
@property (copy) NSArray<MailingAddress *> *addresses;

/// When the view is displayed on-screen, it shows just one page of labels, no matter how many pages there are.  This property indicates which page.  The value is 0-based, i.e. 0 means the first page, 1 means the second page, etc.
@property (assign) NSInteger displayedPageNumber;

@end

NS_ASSUME_NONNULL_END
