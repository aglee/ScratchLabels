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
static const NSRect kPageRectInInches = {
	.origin = { .x = 0, .y = 0 },
	.size = { .width = 8.5, .height = 11.0 }
};
static const CGSize kLabelSizeInInches = { .width = 2.625, .height = 1.0 };
static const CGFloat kTopMarginInInches = 0.5;
static const CGFloat kLeftMarginInInches = 0.1875;  // 3/16
static const CGFloat kSpacingBetweenColumns = 0.125;
static const CGFloat kSpacingBetweenRows = 0.0;

#pragma mark - NSView methods

/// This is a flipped view.  Makes calculating the label rectangles easier.
- (BOOL)isFlipped {
	return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];

	// Draw the page border.
	[NSColor.greenColor set];
	NSFrameRect([self _displayedPageRect]);

	// Draw the labels.
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

- (NSRect)_displayedPageRect {
	return self.bounds;
}

/// Called by `-drawRect:`, which means we assume there is an active graphics context.
- (void)_printAddress:(MailingAddress *)address atLabelRow:(NSInteger)row column:(NSInteger)column {
	NSRect labelRect = [self _boundingRectForLabelAtRow:row column:column];
	[NSColor.redColor set];
	NSFrameRect(labelRect);
}

- (NSRect)_boundingRectForLabelAtRow:(NSInteger)row column:(NSInteger)column {
	CGFloat labelTop = kTopMarginInInches + row*(kLabelSizeInInches.height + kSpacingBetweenRows);
	CGFloat labelLeft = kLeftMarginInInches + column*(kLabelSizeInInches.width + kSpacingBetweenColumns);
	NSRect physicalLabelRect = {
		.origin = { .x = labelLeft, .y = labelTop },
		.size = kLabelSizeInInches
	};
	return [self _convertRect:physicalLabelRect fromReference:kPageRectInInches toReference:[self _displayedPageRect]];
}

/// Calculates a rectangle that is proportionally the same relative to `newRef` as `r` is to `oldRef`.
///
/// Doesn't check for e.g. dividing by zero.
- (NSRect)_convertRect:(NSRect)r fromReference:(NSRect)oldRef toReference:(NSRect)newRef {
	CGFloat scaleX = NSWidth(newRef) / NSWidth(oldRef);
	CGFloat scaleY = NSHeight(newRef) / NSHeight(oldRef);

	CGFloat newX = NSMinX(newRef) + scaleX*(r.origin.x - NSMinX(oldRef));
	CGFloat newY = NSMinY(newRef) + scaleY*(r.origin.y - NSMinY(oldRef));

	CGFloat newWidth = scaleX * r.size.width;
	CGFloat newHeight = scaleY * r.size.height;

	return NSMakeRect(newX, newY, newWidth, newHeight);
}

@end
