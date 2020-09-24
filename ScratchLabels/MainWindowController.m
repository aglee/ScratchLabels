//
//  MainWindowController.m
//  ScratchLabels
//
//  Created by Andy Lee on 9/20/20.
//

#import "MainWindowController.h"
#import "LabelPageView.h"
#import "SLBPrintPanel.h"

@interface MainWindowController ()
@property (strong) IBOutlet NSTextView *addressesTextView;
@property (strong) IBOutlet LabelPageView *pageView;
@end

@implementation MainWindowController

#pragma mark - Action methods

- (IBAction)printLabels:(id)sender {
	NSPrintOperation *printOperation = [NSPrintOperation printOperationWithView:self.pageView];
	printOperation.printPanel = [SLBPrintPanel printPanel];
	[printOperation runOperationModalForWindow:self.window delegate:nil didRunSelector:nil contextInfo:NULL];
}

- (IBAction)useFakeData:(id)sender {
	NSMutableArray<MailingAddress *> *fakeAddresses = [[NSMutableArray alloc] init];
	for (NSInteger i = 0; i < 70; i++) {
		MailingAddress *addr = [[MailingAddress alloc] init];
		addr.name = [NSString stringWithFormat:@"Test Name #%ld", i+1];
		addr.street = @"1234 Elm Street";
		addr.city = @"Citizenville";
		addr.state = @"GA";
		addr.zip = @"98765";
		addr.zipAddOn = @"0088";

		[fakeAddresses addObject:addr];
	}
	self.pageView.addresses = fakeAddresses;
	self.addressesTextView.string = @"";
}

#pragma mark - NSWindowController methods

- (void)windowDidLoad {
	[super windowDidLoad];

	[self useFakeData:nil];
}

#pragma mark - <NSTextDelegate> methods

- (void)textDidChange:(NSNotification *)notification {
	NSArray<MailingAddress *> *addresses = [self _parseAddressesFromString:self.addressesTextView.textStorage.string];
	self.pageView.addresses = addresses;
}

#pragma mark - Private methods

static NSString *trim(NSString *s) {
	return [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//TODO: Add error handling.
- (NSArray<MailingAddress *> *)_parseAddressesFromString:(NSString *)s {
	NSMutableArray<MailingAddress *> *addresses = [[NSMutableArray alloc] init];
	NSArray<NSString *> *lines = [self _scrubLines:[s componentsSeparatedByString:@"\n"]];
	NSInteger lineIndex = 0;
	while (lines.count - lineIndex >= 7) {
		NSArray<NSString *> *addressFields = [lines subarrayWithRange:NSMakeRange(lineIndex, 7)];
		lineIndex += 7;
		[addresses addObject:[self _makeAddressFromFields:addressFields]];
	}
	return addresses;
}

- (NSArray<NSString *> *)_scrubLines:(NSArray<NSString *> *)rawLines {
	NSMutableArray<NSString *> *scrubbedLines = [[NSMutableArray alloc] init];

	for (NSString *line in rawLines) {
		NSString *trimmedLine = trim(line);
		if (trimmedLine.length > 0) {
			[scrubbedLines addObject:trimmedLine];
		}
	}

	return scrubbedLines;
}

- (MailingAddress *)_makeAddressFromFields:(NSArray<NSString *> *)addressFields {
	MailingAddress *addr = [[MailingAddress alloc] init];

	// First field is a row ID of some kind, we ignore it.
	addr.name = addressFields[1];
	addr.street = addressFields[2];
	addr.city = addressFields[3];
	addr.state = addressFields[4];
	addr.zip = addressFields[5];
	addr.zipAddOn = (addressFields.count >= 7 ? addressFields[6] : @"");
	
	return addr;
}

@end
