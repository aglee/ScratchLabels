//
//  MailingAddress.h
//  ScratchLabels
//
//  Created by Andy Lee on 9/20/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MailingAddress : NSObject

@property (copy) NSString *name;
@property (copy) NSString *street;
@property (copy) NSString *city;
@property (copy) NSString *state;
@property (copy) NSString *zip;
@property (copy) NSString *zipAddOn;

@property (readonly) NSString *formattedZIP;

@end

NS_ASSUME_NONNULL_END
