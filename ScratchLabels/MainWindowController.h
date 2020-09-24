//
//  MainWindowController.h
//  ScratchLabels
//
//  Created by Andy Lee on 9/20/20.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// The application's only window.  You paste addresses in the text view (a specific format is expected), you get a preview
/// of the address labels, you print the address labels.
@interface MainWindowController : NSWindowController <NSTextViewDelegate>
@end

NS_ASSUME_NONNULL_END
