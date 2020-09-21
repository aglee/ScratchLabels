//
//  LabelPageView.m
//  ScratchLabels
//
//  Created by Andy Lee on 9/20/20.
//

#import "LabelPageView.h"

@implementation LabelPageView

// All label layout measurements are in inches.
static const NSInteger kNumLabelRows = 10;
static const NSInteger kNumLabelColumns = 3;
static const CGSize kPageSize = {.width = 8.5, .height = 11.0 };
static const CGSize kLabelSize = { .width = 2.625, .height = 1.0 };
static const CGFloat kTopMargin = 0.75;
static const CGFloat kLeftMargin = 0.25;

#pragma mark - NSView methods

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];

	NSInteger labelsPerPage = kNumLabelRows*kNumLabelColumns;
	NSInteger addressIndex = self.currentPageNumber*labelsPerPage;
	NSInteger labelRow = 0;
	NSInteger labelColumn = 0;
	for (NSInteger i = 0; i < labelsPerPage; i++) {
		// See if we've reached the end of the address list before we were able to fill
		// the page.  Checking at the top of the loop handles the case where the address
		// list is empty.
		if (addressIndex >= self.addresses.count) {
			break;
		}

		// Print one label.
		[self _printAddress:self.addresses[addressIndex] atLabelRow:labelRow column:labelColumn];

		// Update variables for the next loop iteration.
		addressIndex += 1;
		labelColumn += 1;
		if (labelColumn >= kNumLabelColumns) {
			labelRow += 1;
			labelColumn = 0;
		}
	}
}

#pragma mark - Private methods

/// Called by `-drawRect:`, which means we assume there is an active graphics context.
- (void)_printAddress:(MailingAddress *)address atLabelRow:(NSInteger)row column:(NSInteger)column {
	NSRect labelRect = [self _boundingRectForLabelAtRow:row column:column];
	[NSColor.redColor set];
	NSFrameRect(labelRect);
}

- (NSRect)_pageRect {
	return self.bounds;
}

- (NSRect)_boundingRectForLabelAtRow:(NSInteger)row column:(NSInteger)column {
	NSRect r = self.bounds;


	return r;
}

@end
