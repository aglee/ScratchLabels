//
//  MainWindowController.m
//  ScratchLabels
//
//  Created by Andy Lee on 9/20/20.
//

#import "MainWindowController.h"
#import "LabelPageView.h"

@interface MainWindowController ()

@property (strong) IBOutlet LabelPageView *pageView;

@end

@implementation MainWindowController

#pragma mark - NSWindowController methods

- (void)windowDidLoad {
	[super windowDidLoad];

	MailingAddress *addr = [[MailingAddress alloc] init];
	addr.name = @"Valued Voter";
	addr.street = @"1234 Elm Street";
	addr.city = @"Citizenville";
	addr.state = @"GA";
	addr.zip = @"98765";
	addr.zipAddOn = @"0088";

	NSMutableArray *fakeAddresses = [[NSMutableArray alloc] init];
	for (NSInteger i = 0; i <= 50; i++) {
		[fakeAddresses addObject:addr];
	}

	self.pageView.addresses = fakeAddresses;
}

@end
