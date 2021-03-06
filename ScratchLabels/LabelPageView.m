//
//  LabelPageView.m
//  ScratchLabels
//
//  Created by Andy Lee on 9/20/20.
//

#import "LabelPageView.h"

@interface LabelPageView ()

/// The 1-based page number of the page being printed (or previewed in the print panel).  Meaningful only during printing.  This property is set by rectForPage: so that the information can be available to drawRect:.
@property (assign) NSInteger currentlyPrintingPageNumber;

/// The bounds of the page being printed (or previewed in the print panel).  Meaningful only during printing.  This property is set by rectForPage: so that the information can be available to drawRect:.
@property (assign) NSRect currentlyPrintingPageRect;

@end


@implementation LabelPageView

@synthesize addresses = _addresses;
@synthesize displayedPageNumber = _displayedPageNumber;

#pragma mark - Constants -- page layout

// Layout for a page of Avery 5260 address labels.  Each label is 1" x 2 5/8".  Each sheet is 8.5"x11" and contains 30 labels, arranged in 10 rows of 3.
static const NSInteger kNumLabelRows = 10;
static const NSInteger kNumLabelColumns = 3;
static const NSInteger kNumLabelsPerPage = kNumLabelRows*kNumLabelColumns;
static const NSRect kPageRectInInches = {
	.origin = { .x = 0, .y = 0 },
	.size = { .width = 8.5, .height = 11.0 }
};
static const CGSize kLabelSizeInInches = { .width = 2.625, .height = 1.0 };
static const CGFloat kTopMarginInInches = 0.5;
static const CGFloat kLeftMarginInInches = 0.1875;  // 3/16
static const CGFloat kSpacingBetweenColumns = 0.125;
static const CGFloat kSpacingBetweenRows = 0.0;

#pragma mark - Init/awake/dealloc

- (instancetype)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if (self) {
		self.displayedPageNumber = 1;
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self) {
		self.displayedPageNumber = 1;
	}
	return self;
}

#pragma mark - Getters and setters

- (NSArray<MailingAddress *> *)addresses {
	return _addresses;
}

- (void)setAddresses:(NSArray<MailingAddress *> *)addresses {
	_addresses = [addresses copy];
	self.displayedPageNumber = 1;
	self.needsDisplay = YES;
}

- (NSInteger)displayedPageNumber {
	return _displayedPageNumber;
}

- (void)setDisplayedPageNumber:(NSInteger)displayedPageNumber {
	_displayedPageNumber = displayedPageNumber;
	self.needsDisplay = YES;
}

- (NSInteger)numberOfPages {
	return (self.addresses.count + kNumLabelsPerPage - 1)/kNumLabelsPerPage;
}

#pragma mark - NSView methods

/// Returns YES.  Using a flipped view makes calculating the label rectangles slightly easier.
- (BOOL)isFlipped {
	return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];

	if ([self _isDrawingToScreen]) {
		[NSColor.lightGrayColor set];
		NSRectFill(self.bounds);

		NSRect pageRect = [self _scaleAndCenterRect:kPageRectInInches toExactlyFitRect:self.bounds];
		[self _drawPage:self.displayedPageNumber inRect:pageRect];
	} else {
		[self _drawPage:self.currentlyPrintingPageNumber inRect:self.currentlyPrintingPageRect];
	}
}

- (BOOL)knowsPageRange:(NSRangePointer)range {
	range->location = 1;
	range->length = self.numberOfPages;
	return YES;
}

- (NSRect)rectForPage:(NSInteger)page {
	// Remember what page we're printing and what the destination rectangle is, so that
	// -drawRect: can use this information.
	self.currentlyPrintingPageNumber = page;
	self.currentlyPrintingPageRect = (NSRect) {
		.origin = NSZeroPoint,
		.size = NSPrintOperation.currentOperation.printInfo.paperSize };

	return self.currentlyPrintingPageRect;
}

#pragma mark - <NSKeyValueObserving> methods

+ (NSSet<NSString *> *)keyPathsForValuesAffectingNumberOfPages {
	return [NSSet setWithArray:@[ @"addresses" ]];
}

#pragma mark - Private methods

/// If we're not drawing to the screen, we assume we're drawing output for the printer.
- (BOOL)_isDrawingToScreen {
	return [NSGraphicsContext currentContextDrawingToScreen];
}

/// Draws one page of labels.  It's up to the caller to make sure pageRect has the same aspect ratio as kPageRectInInches.  If it doesn't, the drawing will be scaled.  Expects pageNumber to be 1-based.
- (void)_drawPage:(NSInteger)pageNumber inRect:(NSRect)pageRect {
	// Draw the page background and border.
	if ([self _isDrawingToScreen]) {
		[NSColor.whiteColor set];
		NSRectFill(pageRect);
		[NSColor.blackColor set];
		NSFrameRect(pageRect);
	}

	// Draw the labels.
	[NSColor.blackColor set];
	NSInteger addressIndex = (pageNumber - 1)*kNumLabelsPerPage;
	NSInteger labelRow = 0;
	NSInteger labelColumn = 0;
	for (NSInteger i = 0; i < kNumLabelsPerPage; i++) {
		// See if we've reached the end of the address list before we were able to fill
		// the page.  Checking at the top of the loop handles the case where the address
		// list is empty.
		if (addressIndex >= self.addresses.count) {
			break;
		}

		// Print one label.
		[self _drawAddress:self.addresses[addressIndex] inPageRect:pageRect atLabelRow:labelRow column:labelColumn];

		// Update variables for the next loop iteration.
		addressIndex += 1;
		labelColumn += 1;
		if (labelColumn >= kNumLabelColumns) {
			labelRow += 1;
			labelColumn = 0;
		}
	}
}

/// Draws one label, using pageRect to define the boundaries of the page as a whole.
- (void)_drawAddress:(MailingAddress *)address inPageRect:(NSRect)pageRect atLabelRow:(NSInteger)row column:(NSInteger)column {
	// Construct the multi-line address string.
	NSString *line1 = address.name;
	NSString *line2 = address.street;
	NSString *line3 = [NSString stringWithFormat:@"%@, %@ %@",
					   address.city, address.state, address.formattedZIP];
	NSString *addressText = [@[line1, line2, line3] componentsJoinedByString:@"\n"];

	// Calculate on-paper bounding rectangles of the label and the text within the label.
	NSRect labelRectInInches = [self _rectInInchesForLabelAtRow:row column:column];
	NSRect textRectInInches = NSInsetRect(labelRectInInches, 0.125, 0.2);

	// Convert the rectangles to coordinates relative to pageRect.
	NSRect labelRect = [self _convertRect:labelRectInInches fromReference:kPageRectInInches toReference:pageRect];
	NSRect textRect = [self _convertRect:textRectInInches fromReference:kPageRectInInches toReference:pageRect];

	// Draw a background (on-screen only).
	if ([self _isDrawingToScreen]) {
		[NSColor.lightGrayColor set];
		NSFrameRect(labelRect);
	}

	// Draw the address text.  The font size calculation was derived by trial and error.
	// This is not really the right way to do it, but close enough.
	[addressText drawAtPoint:textRect.origin withAttributes: @{ NSFontAttributeName: [NSFont fontWithName:@"Times" size:NSHeight(textRect)/4.0] }];
}

/// Returns the label's bounding rect in "paper" coordinates.
- (NSRect)_rectInInchesForLabelAtRow:(NSInteger)row column:(NSInteger)column {
	CGFloat labelTop = kTopMarginInInches + row*(kLabelSizeInInches.height + kSpacingBetweenRows);
	CGFloat labelLeft = kLeftMarginInInches + column*(kLabelSizeInInches.width + kSpacingBetweenColumns);
	NSRect physicalLabelRect = {
		.origin = { .x = labelLeft, .y = labelTop },
		.size = kLabelSizeInInches
	};
	return physicalLabelRect;
}

/// Calculates a rectangle that is proportionally the same relative to newRef as r is to oldRef.
///
/// Examples:
///
/// - If r is the top-left quadrant of oldRef, the returned rectangle is the top-left quadrant of newRef.
/// - If r is centered in oldRef, the returned rectangle is centered in newRef.
/// - If oldRef and newRef are the same, the returned rectangle is the same as r.
///
/// It doesn't matter whether r lies entirely (or at all) inside oldRef.  The logic is the same.
///
/// NOTE: Doesn't check for divide by zero.
- (NSRect)_convertRect:(NSRect)r fromReference:(NSRect)oldRef toReference:(NSRect)newRef {
	CGFloat scaleX = NSWidth(newRef) / NSWidth(oldRef);
	CGFloat scaleY = NSHeight(newRef) / NSHeight(oldRef);

	CGFloat newX = NSMinX(newRef) + scaleX*(r.origin.x - NSMinX(oldRef));
	CGFloat newY = NSMinY(newRef) + scaleY*(r.origin.y - NSMinY(oldRef));

	CGFloat newWidth = scaleX * r.size.width;
	CGFloat newHeight = scaleY * r.size.height;

	return NSMakeRect(newX, newY, newWidth, newHeight);
}

/// Returns the result of scaling r1 so it exactly fits r2 in one dimension and is centered within r2 in the other dimension.
///
/// NOTE: Doesn't check for divide by zero.
- (NSRect)_scaleAndCenterRect:(NSRect)r1 toExactlyFitRect:(NSRect)r2 {
	CGFloat aspectRatio1 = NSWidth(r1)/NSHeight(r1);
	CGFloat aspectRatio2 = NSWidth(r2)/NSHeight(r2);

	// Make a copy of r2 and adjust it either horizontally or vertically so that it has
	// the same aspect ratio as r1.
	NSRect result = r2;
	if (aspectRatio1 > aspectRatio2) {
		// The result will fill r2 horizontally and be centered vertically.
		result.size.height = NSWidth(result) / aspectRatio1;
		result.origin.y += (NSHeight(r2) - NSHeight(result)) / 2.0;
	} else {
		// The result will fill r2 vertically and be centered horizontally.
		result.size.width = NSHeight(result) * aspectRatio1;
		result.origin.x += (NSWidth(r2) - NSWidth(result)) / 2.0;
	}

	return result;
}

@end
