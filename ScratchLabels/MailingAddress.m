//
//  MailingAddress.m
//  ScratchLabels
//
//  Created by Andy Lee on 9/20/20.
//

#import "MailingAddress.h"

@implementation MailingAddress

#pragma mark - Getters and setters

- (NSString *)formattedZIP {
	NSString *paddedZIP = [self _padZIPComponent:self.zip toLength:5];
	if (self.zipAddOn.length == 0) {
		// Return a 5-digit ZIP.
		return paddedZIP;
	} else {
		return [NSString stringWithFormat:@"%@-%@",
				paddedZIP, [self _padZIPComponent:self.zipAddOn toLength:4]];
	}
}

#pragma mark - NSObject methods

- (NSString *)description {
	return [NSString stringWithFormat:@"%@\n%@\n%@, %@ %@", self.name, self.street, self.city, self.state, self.formattedZIP];
}

#pragma mark - Private methods

/// Assumes the desired length is at most 5, since it's a ZIP code component.
- (NSString *)_padZIPComponent:(NSString *)s toLength:(NSInteger)desiredLength {
	NSString *result = s;

	if (result == nil) {
		result = @"";
	}

	if (result.length < desiredLength) {
		result = [@"00000" stringByAppendingString:result];
		result = [result substringFromIndex:(result.length - desiredLength)];
	}

	return result;
}

@end
