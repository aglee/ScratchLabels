//
//  LabelPageView.h
//  ScratchLabels
//
//  Created by Andy Lee on 9/20/20.
//

#import <Cocoa/Cocoa.h>
#import "MailingAddress.h"

NS_ASSUME_NONNULL_BEGIN

/// This view is used to print mailing addresses on labels.  It is hard-coded to expect Avery 5260 address labels.
///
/// When this view is displayed in a window, it shows one page of labels, with outlines showing where the edges of the
/// labels are.  It's similar to a print preview, but with the addition of the label edges to help you check that the addresses
/// look right and they all fit on the labels.  In the actual print preview in the print panel, the label edges are not drawn.
@interface LabelPageView : NSView

/// One address will be printed on each label.
@property (copy) NSArray<MailingAddress *> *addresses;

/// When the view is displayed on-screen, it shows just one page of labels, no matter how many pages there are.  This property indicates which page.  The value is 1-based, i.e. 1 means the first page, 2 means the second page, etc.
@property (assign) NSInteger displayedPageNumber;

@property (readonly) NSInteger numberOfPages;

@end

NS_ASSUME_NONNULL_END
