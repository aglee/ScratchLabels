//
//  MailingAddress.h
//  ScratchLabels
//
//  Created by Andy Lee on 9/20/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Model object containing the fields of a mailing address.
@interface MailingAddress : NSObject

@property (copy) NSString *name;
@property (copy) NSString *street;
@property (copy) NSString *city;
@property (copy) NSString *state;
@property (copy) NSString *zip;
@property (copy) NSString *zipAddOn;

/// Standard 3-line address format.  Adds leading zeroes as needed to the ZIP and (if present) the ZIP add-on.
@property (readonly) NSString *formattedZIP;

@end

NS_ASSUME_NONNULL_END
