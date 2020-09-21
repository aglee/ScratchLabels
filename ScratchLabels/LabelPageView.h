//
//  LabelPageView.h
//  ScratchLabels
//
//  Created by Andy Lee on 9/20/20.
//

#import <Cocoa/Cocoa.h>
#import "MailingAddress.h"

NS_ASSUME_NONNULL_BEGIN

@interface LabelPageView : NSView

@property (copy) NSArray<MailingAddress *> *addresses;
@property (assign) NSInteger currentPageNumber;

@end

NS_ASSUME_NONNULL_END
