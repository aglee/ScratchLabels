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

/// How to parse the text in addressesTextView.  The first time I got GPP data it was in a PDF file, and when I copy-pasted
/// the text the result had one *field* per line.  The second time, I got an Excel file with one *address* per line, with
/// tab-separated fields.  I made the first request by email.  The second time, I used the new Google form to request the
/// addresses.  I expect to be using the Google form henceforth, and I'm guessing I'll keep getting Excel files, so this
/// defaults to YES.
@property (assign) BOOL oneAddressPerLine;

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

	self.oneAddressPerLine = YES;

	[self useFakeData:nil];
}

#pragma mark - <NSTextDelegate> methods

- (void)textDidChange:(NSNotification *)notification {
	NSArray<MailingAddress *> *addresses = [self _parseAddressesFromString:self.addressesTextView.textStorage.string];
	self.pageView.addresses = addresses;
}

#pragma mark - Private methods

//TODO: Add error handling.
- (NSArray<MailingAddress *> *)_parseAddressesFromString:(NSString *)s {
	NSMutableArray<MailingAddress *> *addresses = [[NSMutableArray alloc] init];
	NSArray<NSString *> *lines = [self _removeBlanksFromLines:[s componentsSeparatedByString:@"\n"]];
	NSArray<NSArray<NSString *> *> *groupsOfFields = [self _parseGroupsOfFieldsFromLines:lines];
	for (NSArray<NSString *> *addressFields in groupsOfFields) {
		[addresses addObject:[self _makeAddressFromFields:addressFields]];
	}
	return addresses;
}

/// Trims whitespace from each line, and removes empty lines.
- (NSArray<NSString *> *)_removeBlanksFromLines:(NSArray<NSString *> *)rawLines {
	NSMutableArray<NSString *> *scrubbedLines = [[NSMutableArray alloc] init];

	for (NSString *line in rawLines) {
		NSString *trimmedLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if (trimmedLine.length > 0) {
			[scrubbedLines addObject:trimmedLine];
		}
	}

	return scrubbedLines;
}

/// Assumes _removeBlanksFromLines: was called, so the given array of lines contains no extraneous whitespace.
- (NSArray<NSArray<NSString *> *> *)_parseGroupsOfFieldsFromLines:(NSArray<NSString *> *)lines {
	NSMutableArray<NSArray<NSString *> *> *groupsOfFields = [[NSMutableArray alloc] init];

	if (self.oneAddressPerLine) {
		// Expect each line to contain all the fields of an address, separated by tabs.
		// Skip any line that doesn't start with a VAN ID -- assume it contains Excel
		// column titles.  ("VAN" = "voter activation network".)
		for (NSString *line in lines) {
			NSArray<NSString *> *group = [line componentsSeparatedByString:@"\t"];
			NSString *firstField = group.firstObject;
			if (firstField.length < 7 || ![firstField isEqualToString:@(firstField.integerValue).stringValue]) {
				continue;
			}
			[groupsOfFields addObject:group];
		}
	} else {
		// Make the first 7 lines into a group, then the next 7 lines, then the next 7 lines, etc.
		NSInteger lineIndex = 0;
		while (lines.count - lineIndex >= 7) {
			[groupsOfFields addObject:[lines subarrayWithRange:NSMakeRange(lineIndex, 7)]];
			lineIndex += 7;
		}
	}

	return groupsOfFields;
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
