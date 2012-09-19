//
//  MMAdiumTabStyle.m
//  MMTabBarView
//
//  Created by Kent Sutherland on 5/26/06.
//  Copyright 2006 Kent Sutherland. All rights reserved.
//

#import "MMAdiumTabStyle.h"
#import "MMAttachedTabBarButtonCell.h"
#import "MMTabBarView.h"
#import "MMAttachedTabBarButton.h"
#import "NSView+MMTabBarViewExtensions.h"

// #define Adium_CellPadding 2
#define Adium_MARGIN_X 4
#define kMMAdiumCounterPadding 3.0

@interface MMTabBarButtonCell(SharedPrivates)

- (void)_drawIconWithFrame:(NSRect)frame inView:(NSView *)controlView;
- (void)_drawCloseButtonWithFrame:(NSRect)frame inView:(NSView *)controlView;
- (void)_drawObjectCounterWithFrame:(NSRect)frame inView:(NSView *)controlView;

@end

@implementation MMAdiumTabStyle

+ (NSString *)name {
    return @"Adium";
}

- (NSString *)name {
	return [[self class] name];
}

#pragma mark -
#pragma mark Creation/Destruction

- (id)init {
	if ((self = [super init])) {
		[self loadImages];
		_drawsUnified = NO;
		_drawsRight = NO;
	}
	return self;
}

- (void)loadImages {
	_closeButton = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabClose_Front"]];
	_closeButtonDown = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabClose_Front_Pressed"]];
	_closeButtonOver = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabClose_Front_Rollover"]];

	_closeDirtyButton = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabCloseDirty_Front"]];
	_closeDirtyButtonDown = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabCloseDirty_Front_Pressed"]];
	_closeDirtyButtonOver = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabCloseDirty_Front_Rollover"]];

	_addTabButtonImage = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabNew"]];
	_addTabButtonPressedImage = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabNewPressed"]];
	_addTabButtonRolloverImage = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AquaTabNewRollover"]];

	_gradientImage = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"AdiumGradient"]];
}

- (void)dealloc {
	[_closeButton release];
	[_closeButtonDown release];
	[_closeButtonOver release];

	[_closeDirtyButton release];
	[_closeDirtyButtonDown release];
	[_closeDirtyButtonOver release];

	[_addTabButtonImage release];
	[_addTabButtonPressedImage release];
	[_addTabButtonRolloverImage release];

	[_gradientImage release];

	[super dealloc];
}

#pragma mark -
#pragma mark Drawing Style Accessors

- (BOOL)drawsUnified {
	return _drawsUnified;
}

- (void)setDrawsUnified:(BOOL)value {
	_drawsUnified = value;
}

- (BOOL)drawsRight {
	return _drawsRight;
}

- (void)setDrawsRight:(BOOL)value {
	_drawsRight = value;
}

#pragma mark -
#pragma mark Control Specific

- (CGFloat)leftMarginForTabBarView:(MMTabBarView *)tabBarView {
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation)
        return 3.0f;
    else
        return 0.0;
}

- (CGFloat)rightMarginForTabBarView:(MMTabBarView *)tabBarView {
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation)
        return 3.0;
    else
        return 0.0;
}

- (CGFloat)topMarginForTabBarView:(MMTabBarView *)tabBarView {
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation)
        return 0.0;
    else
        return 10.0f;
}

#pragma mark -
#pragma mark Add Tab Button

- (NSImage *)addTabButtonImage {
	return _addTabButtonImage;
}

- (NSImage *)addTabButtonPressedImage {
	return _addTabButtonPressedImage;
}

- (NSImage *)addTabButtonRolloverImage {
	return _addTabButtonRolloverImage;
}

#pragma mark -
#pragma mark Drag Support

- (NSRect)draggingRectForTabButton:(MMAttachedTabBarButton *)aButton ofTabBarView:(MMTabBarView *)tabBarView {

	NSRect dragRect = [aButton stackingFrame];

    MMTabBarOrientation orientation = [tabBarView orientation];

	if ([aButton state] == NSOnState) {
		if (orientation == MMTabBarHorizontalOrientation) {
			dragRect.size.width++;
			dragRect.size.height -= 2.0;
		}
	}

	return dragRect;    
}

#pragma mark -
#pragma mark Providing Images

- (NSImage *)closeButtonImageOfType:(MMCloseButtonImageType)type forTabCell:(MMTabBarButtonCell *)cell
{
    switch (type) {
        case MMCloseButtonImageTypeStandard:
            return _closeButton;
        case MMCloseButtonImageTypeRollover:
            return _closeButtonOver;
        case MMCloseButtonImageTypePressed:
            return _closeButtonDown;
            
        case MMCloseButtonImageTypeDirty:
            return _closeDirtyButton;
        case MMCloseButtonImageTypeDirtyRollover:
            return _closeDirtyButtonOver;
        case MMCloseButtonImageTypeDirtyPressed:
            return _closeDirtyButtonDown;
            
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark Determining Cell Size

- (CGFloat)heightOfTabBarButtonsForTabBarView:(MMTabBarView *)tabBarView {
    MMTabBarOrientation orientation = [tabBarView orientation];
	return((orientation == MMTabBarHorizontalOrientation) ? kMMTabBarViewHeight : kMMTabBarViewSourceListHeight);
}

- (NSRect)drawingRectForBounds:(NSRect)theRect ofTabCell:(MMTabBarButtonCell *)cell {
    NSRect resultRect;

    MMTabBarView *tabBarView = [cell tabBarView];

    if ([tabBarView orientation] == MMTabBarHorizontalOrientation && [cell state] == NSOnState) {
        resultRect = NSInsetRect(theRect,Adium_MARGIN_X,0.0);
        resultRect.origin.y += 1;
        resultRect.size.height -= MARGIN_Y + 2;
    } else {
        resultRect = NSInsetRect(theRect, Adium_MARGIN_X, MARGIN_Y);
        resultRect.size.height -= 1;
    }
    
    return resultRect;
}

- (NSRect)closeButtonRectForBounds:(NSRect)theRect ofTabCell:(MMTabBarButtonCell *)cell {

    if ([cell shouldDisplayCloseButton] == NO) {
        return NSZeroRect;
    }

    MMTabBarView *tabBarView = [cell tabBarView];
    MMTabBarOrientation orientation = [tabBarView orientation];
        
    // ask style for image
    NSImage *image = [cell closeButtonImageOfType:MMCloseButtonImageTypeStandard];
    if (!image)
        return NSZeroRect;
    
    // calculate rect
    NSRect drawingRect = [cell drawingRectForBounds:theRect];
        
    NSSize imageSize = [image size];
    
    NSSize scaledImageSize = [cell scaleImageWithSize:imageSize toFitInSize:NSMakeSize(imageSize.width, drawingRect.size.height) scalingType:NSImageScaleProportionallyDown];

    NSRect result;
    if (orientation == MMTabBarHorizontalOrientation) {
        result = NSMakeRect(drawingRect.origin.x, drawingRect.origin.y, scaledImageSize.width, scaledImageSize.height);    
    } else {
    
        NSRect constrainedDrawingRect = drawingRect;

        NSRect indicatorRect = [cell indicatorRectForBounds:theRect];
        if (!NSEqualRects(indicatorRect, NSZeroRect))
            {
            constrainedDrawingRect.size.width -= NSWidth(indicatorRect) + kMMTabBarCellPadding;
            }
    
        result = NSMakeRect(NSMaxX(constrainedDrawingRect)-scaledImageSize.width-Adium_MARGIN_X, constrainedDrawingRect.origin.y, scaledImageSize.width, scaledImageSize.height);
    }

    if (scaledImageSize.height < drawingRect.size.height) {
        result.origin.y += ceil((drawingRect.size.height - scaledImageSize.height) / 2.0);
    }

    return NSIntegralRect(result);
}

- (NSRect)iconRectForBounds:(NSRect)theRect ofTabCell:(MMTabBarButtonCell *)cell {
    
    if (![cell icon])
        return NSZeroRect;
    
    NSImage *icon = [cell icon];
    if (!icon)
        return NSZeroRect;

    MMTabBarView *tabBarView = [cell tabBarView];
    MMTabBarOrientation orientation = [tabBarView orientation];
    
    if ([cell largeImage] && orientation == MMTabBarVerticalOrientation)
        return NSZeroRect;

    // calculate rect
    NSRect drawingRect = [cell drawingRectForBounds:theRect];
                
    NSSize iconSize = [icon size];
    
    NSSize scaledIconSize = [cell scaleImageWithSize:iconSize toFitInSize:NSMakeSize(iconSize.width, drawingRect.size.height) scalingType:NSImageScaleProportionallyDown];

    NSRect result;
    if (orientation == MMTabBarHorizontalOrientation) {
        {
        result = NSMakeRect(drawingRect.origin.x, drawingRect.origin.y, scaledIconSize.width, scaledIconSize.height);
        }
    } else {
        result = NSMakeRect(drawingRect.origin.x, drawingRect.origin.y, scaledIconSize.width, scaledIconSize.height);
    }
    
    // center in available space (in case icon image is smaller than kMMTabBarIconWidth)
    if (scaledIconSize.width < kMMTabBarIconWidth) {
        result.origin.x += ceil((kMMTabBarIconWidth - scaledIconSize.width) / 2.0);
    }

    if (scaledIconSize.height < kMMTabBarIconWidth) {
        result.origin.y += ceil((kMMTabBarIconWidth - scaledIconSize.height) / 2.0 - 0.5);
    }

    return NSIntegralRect(result);    
    
}

- (NSRect)titleRectForBounds:(NSRect)theRect ofTabCell:(MMTabBarButtonCell *)cell {

    MMTabBarView *tabBarView = [cell tabBarView];
    MMTabBarOrientation orientation = [tabBarView orientation];
        
    NSRect drawingRect = [cell drawingRectForBounds:theRect];

    NSRect constrainedDrawingRect = drawingRect;
        
    NSRect indicatorRect = [cell indicatorRectForBounds:theRect];
    if (!NSEqualRects(indicatorRect, NSZeroRect)) {
        constrainedDrawingRect.size.width -= NSWidth(indicatorRect) + kMMTabBarCellPadding;
    }
        
    NSRect largeImageRect = [cell largeImageRectForBounds:theRect];
    if (!NSEqualRects(largeImageRect, NSZeroRect)) {
        constrainedDrawingRect.origin.x += NSWidth(largeImageRect) + kMMTabBarCellPadding;
        constrainedDrawingRect.size.width -= NSWidth(largeImageRect) + kMMTabBarCellPadding;
    }

    if (orientation == MMTabBarHorizontalOrientation) {

        NSRect closeButtonRect = [cell closeButtonRectForBounds:theRect];
        NSRect iconRect = [cell iconRectForBounds:theRect];
    
        if (!NSEqualRects(closeButtonRect, NSZeroRect) || !NSEqualRects(iconRect, NSZeroRect)) {
            constrainedDrawingRect.origin.x += MAX(NSWidth(closeButtonRect),NSWidth(iconRect)) + kMMTabBarCellPadding;
            constrainedDrawingRect.size.width -= MAX(NSWidth(closeButtonRect),NSWidth(iconRect)) + kMMTabBarCellPadding;
        }
        
        NSRect counterBadgeRect = [cell objectCounterRectForBounds:theRect];
        if (!NSEqualRects(counterBadgeRect, NSZeroRect)) {
            constrainedDrawingRect.size.width -= NSWidth(counterBadgeRect) + kMMTabBarCellPadding;
        }
    } else {
    
        if ([cell icon] && ![cell largeImage]) {
            NSRect iconRect = [cell iconRectForBounds:theRect];
            if (!NSEqualRects(iconRect, NSZeroRect) || !NSEqualRects(iconRect, NSZeroRect)) {
                constrainedDrawingRect.origin.x += NSWidth(iconRect) + kMMTabBarCellPadding;
                constrainedDrawingRect.size.width -= NSWidth(iconRect) + kMMTabBarCellPadding;
                }
        }
    
        NSRect closeButtonRect = [cell closeButtonRectForBounds:theRect];
        NSRect counterBadgeRect = [cell objectCounterRectForBounds:theRect];

        if (!NSEqualRects(closeButtonRect, NSZeroRect) || !NSEqualRects(counterBadgeRect, NSZeroRect)) {
            constrainedDrawingRect.size.width -= MAX(NSWidth(closeButtonRect),NSWidth(counterBadgeRect)) + kMMTabBarCellPadding;
        }    
    }

    NSAttributedString *attrString = [cell attributedStringValue];
    if ([attrString length] == 0)
        return NSZeroRect;
        
    NSSize stringSize = [attrString size];
    
    NSRect result = NSMakeRect(constrainedDrawingRect.origin.x, drawingRect.origin.y+ceil((drawingRect.size.height-stringSize.height)/2), constrainedDrawingRect.size.width, stringSize.height);
                    
    return NSIntegralRect(result);
}

- (NSRect)indicatorRectForBounds:(NSRect)theRect ofTabCell:(MMTabBarButtonCell *)cell {

    MMTabBarButton *controlView = [cell controlView];
    
    if ([[controlView indicator] isHidden]) {
        return NSZeroRect;
    }
    
    // calculate rect
    NSRect drawingRect = [cell drawingRectForBounds:theRect];
        
    NSSize indicatorSize = NSMakeSize(kMMTabBarIndicatorWidth, kMMTabBarIndicatorWidth);
    
    NSRect result = NSMakeRect(NSMaxX(drawingRect)-indicatorSize.width,NSMidY(drawingRect)-ceil(indicatorSize.height/2),indicatorSize.width,indicatorSize.height);
    
    return NSIntegralRect(result);
}

- (NSRect)objectCounterRectForBounds:(NSRect)theRect ofTabCell:(MMTabBarButtonCell *)cell {

    if ([cell objectCount] == 0) {
        return NSZeroRect;
    }

    NSRect drawingRect = [cell drawingRectForBounds:theRect];

    NSRect constrainedDrawingRect = drawingRect;

    NSRect indicatorRect = [cell indicatorRectForBounds:theRect];
    if (!NSEqualRects(indicatorRect, NSZeroRect))
        {
        constrainedDrawingRect.size.width -= NSWidth(indicatorRect) + kMMTabBarCellPadding;
        }
            
    NSSize counterBadgeSize = [cell objectCounterSize];
    
    // calculate rect
    NSRect result;
    result.size = counterBadgeSize; // temp
    result.origin.x = NSMaxX(constrainedDrawingRect)-counterBadgeSize.width;
    result.origin.y = ceil(constrainedDrawingRect.origin.y+(constrainedDrawingRect.size.height-result.size.height)/2);
                
    return NSIntegralRect(result);
}

-(NSRect)largeImageRectForBounds:(NSRect)theRect ofTabCell:(MMTabBarButtonCell *)cell
{
    NSImage *image = [cell largeImage];
    
    if (!image) {
        return NSZeroRect;
    }
    
    // calculate rect
    NSRect drawingRect = [cell drawingRectForBounds:theRect];

    NSRect constrainedDrawingRect = drawingRect;
                
    NSSize scaledImageSize = [cell scaleImageWithSize:[image size] toFitInSize:NSMakeSize(constrainedDrawingRect.size.width, constrainedDrawingRect.size.height) scalingType:NSImageScaleProportionallyUpOrDown];
    
    NSRect result = NSMakeRect(constrainedDrawingRect.origin.x,
                                         constrainedDrawingRect.origin.y - ((constrainedDrawingRect.size.height - scaledImageSize.height) / 2),
                                         scaledImageSize.width, scaledImageSize.height);

    if (scaledImageSize.width < kMMTabBarIconWidth) {
        result.origin.x += (kMMTabBarIconWidth - scaledImageSize.width) / 2.0;
    }
    if (scaledImageSize.height < constrainedDrawingRect.size.height) {
        result.origin.y += (constrainedDrawingRect.size.height - scaledImageSize.height) / 2.0;
    }
        
    return result;    
}  // -largeImageRectForBounds:ofTabCell:

#pragma mark -
#pragma mark Cell Drawing

- (void)drawBezelOfTabBarView:(MMTabBarView *)tabBarView inRect:(NSRect)rect {

	//Draw for our whole bounds; it'll be automatically clipped to fit the appropriate drawing area
	rect = [tabBarView bounds];

    MMTabBarOrientation orientation = [tabBarView orientation];

	switch(orientation) {
	case MMTabBarHorizontalOrientation :
		if (_drawsUnified) {
			if ([tabBarView isWindowActive]) {
                NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.835 alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:0.843 alpha:1.0]];
                [gradient drawInRect:rect angle:90.0];
                [gradient release];
			} else {
				[[NSColor windowBackgroundColor] set];
				NSRectFill(rect);
			}
		} else {
			[[NSColor colorWithCalibratedWhite:0.85 alpha:0.6] set];
			[NSBezierPath fillRect:rect];
		}
		break;

	case MMTabBarVerticalOrientation:
		//This is the Mail.app source list background color... which differs from the iTunes one.
		[[NSColor colorWithCalibratedRed:.9059
		  green:.9294
		  blue:.9647
		  alpha:1.0] set];
		NSRectFill(rect);
		break;
	}

	//Draw the border and shadow around the tab bar itself
	[NSGraphicsContext saveGraphicsState];
	[[NSGraphicsContext currentContext] setShouldAntialias:NO];

	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowBlurRadius:2];
	[shadow setShadowColor:[NSColor colorWithCalibratedWhite:0.65 alpha:1.0]];

	[[NSColor grayColor] set];

	NSBezierPath *path = [NSBezierPath bezierPath];
	[path setLineWidth:2.0];

	switch(orientation) {
	case MMTabBarHorizontalOrientation:
	{
		[path moveToPoint:NSMakePoint(rect.origin.x, rect.origin.y)];
		[path lineToPoint:NSMakePoint(rect.origin.x + rect.size.width, rect.origin.y)];
		[shadow setShadowOffset:NSMakeSize(0, -1.0)];

		[shadow set];
		[path stroke];

		break;
	}

	case MMTabBarVerticalOrientation:
	{
		NSPoint startPoint, endPoint;
		NSSize shadowOffset;

		//Draw vertical shadow
		if (_drawsRight) {
			startPoint = NSMakePoint(NSMinX(rect), NSMinY(rect));
			endPoint = NSMakePoint(NSMinX(rect), NSMaxY(rect));
			shadowOffset = NSMakeSize(0.5, -0.5);
		} else {
			startPoint = NSMakePoint(NSMaxX(rect), NSMinY(rect));
			endPoint = NSMakePoint(NSMaxX(rect), NSMaxY(rect));
			shadowOffset = NSMakeSize(-0.5, -1.0);
		}

		[path moveToPoint:startPoint];
		[path lineToPoint:endPoint];
		[shadow setShadowOffset:shadowOffset];

		[shadow set];
		[path stroke];

		[path removeAllPoints];

		//Draw top horizontal shadow
		startPoint = NSMakePoint(NSMinX(rect), NSMinY(rect));
		endPoint = NSMakePoint(NSMaxX(rect), NSMinY(rect));
		shadowOffset = NSMakeSize(0, 0);

		[path moveToPoint:startPoint];
		[path lineToPoint:endPoint];
		[shadow setShadowOffset:shadowOffset];

		[shadow set];
		[path stroke];

		break;
	}
	}

	[shadow release];
	[NSGraphicsContext restoreGraphicsState];
}

- (void)drawBezelOfTabCell:(MMTabBarButtonCell *)cell withFrame:(NSRect)frame inView:(NSView *)controlView {

    NSRect cellFrame = frame;
	NSColor *lineColor = nil;
	NSBezierPath *bezier = [NSBezierPath bezierPath];
	lineColor = [NSColor grayColor];

    MMTabBarView *tabBarView = [controlView enclosingTabBarView];
    
    MMTabBarOrientation orientation = [tabBarView orientation];

	[bezier setLineWidth:1.0];

	//disable antialiasing of bezier paths
	[NSGraphicsContext saveGraphicsState];
	[[NSGraphicsContext currentContext] setShouldAntialias:NO];

	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowOffset:NSMakeSize(-1.5, -1.5)];
	[shadow setShadowBlurRadius:2];
	[shadow setShadowColor:[NSColor colorWithCalibratedWhite:0.65 alpha:1.0]];

	if ([cell state] == NSOnState) {
		// selected tab
		if (orientation == MMTabBarHorizontalOrientation) {
			NSRect aRect = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, NSWidth(cellFrame), cellFrame.size.height - 2.5);

			// background
			if (_drawsUnified) {
				if ([tabBarView isWindowActive]) {
                
                    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.835 alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:0.843 alpha:1.0]];
                    [gradient drawInRect:aRect angle:90.0];
                    [gradient release];                
				} else {
					[[NSColor windowBackgroundColor] set];
					NSRectFill(aRect);
				}
			} else {
				[_gradientImage drawInRect:NSMakeRect(NSMinX(aRect), NSMinY(aRect), NSWidth(aRect), NSHeight(aRect)) fromRect:NSMakeRect(0, 0, [_gradientImage size].width, [_gradientImage size].height) operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
			}

			// frame
			[lineColor set];
			[bezier setLineWidth:1.0];
			[bezier moveToPoint:NSMakePoint(aRect.origin.x, aRect.origin.y)];
			[bezier lineToPoint:NSMakePoint(aRect.origin.x, aRect.origin.y + aRect.size.height)];

			[shadow setShadowOffset:NSMakeSize(-1.0, -1.0)];
			[shadow set];
			[bezier stroke];

			bezier = [NSBezierPath bezierPath];
			[bezier setLineWidth:1.0];
			[bezier moveToPoint:NSMakePoint(NSMinX(aRect), NSMaxY(aRect))];
			[bezier lineToPoint:NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
			[bezier lineToPoint:NSMakePoint(NSMaxX(aRect), NSMinY(aRect))];

			if ([[cell controlView] frame].size.height < 2) {
				// special case of hidden control; need line across top of cell
				[bezier moveToPoint:NSMakePoint(aRect.origin.x, aRect.origin.y + 0.5)];
				[bezier lineToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y + 0.5)];
			}

			[shadow setShadowOffset:NSMakeSize(1.0, -1.0)];
			[shadow set];
			[bezier stroke];
		} else {
			NSRect aRect;

			if (_drawsRight) {
				aRect = NSMakeRect(cellFrame.origin.x - 1, cellFrame.origin.y, cellFrame.size.width - 3, cellFrame.size.height);
			} else {
				aRect = NSMakeRect(cellFrame.origin.x + 2, cellFrame.origin.y, cellFrame.size.width - 2, cellFrame.size.height);
			}

			// background
			if (_drawsUnified) {
				if ([tabBarView isWindowActive]) {
                
                    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.835 alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:0.843 alpha:1.0]];
                    [gradient drawInRect:aRect angle:90.0];
                    [gradient release];
				} else {
					[[NSColor windowBackgroundColor] set];
					NSRectFill(aRect);
				}
			} else {
            
                NSGradient *gradient = nil;
                if (_drawsRight) {
                    gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.92 alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:0.98 alpha:1.0]];
                } else {
                    gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.98 alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:0.92 alpha:1.0]];
                }
                
                [gradient drawInRect:aRect angle:0.0];
                [gradient release];
			}

			// frame
			//top line
			[lineColor set];
			[bezier setLineWidth:1.0];
			[bezier moveToPoint:NSMakePoint(NSMinX(aRect), NSMinY(aRect))];
			[bezier lineToPoint:NSMakePoint(NSMaxX(aRect), NSMinY(aRect))];
			[bezier stroke];

			//outer edge and bottom lines
			bezier = [NSBezierPath bezierPath];
			[bezier setLineWidth:1.0];
			if (_drawsRight) {
				//Right
				[bezier moveToPoint:NSMakePoint(NSMaxX(aRect), NSMinY(aRect))];
				[bezier lineToPoint:NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
				//Bottom
				[bezier lineToPoint:NSMakePoint(NSMinX(aRect), NSMaxY(aRect))];
			} else {
				//Left
				[bezier moveToPoint:NSMakePoint(NSMinX(aRect), NSMinY(aRect))];
				[bezier lineToPoint:NSMakePoint(NSMinX(aRect), NSMaxY(aRect))];
				//Bottom
				[bezier lineToPoint:NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
			}
			[shadow setShadowOffset:NSMakeSize((_drawsRight ? 1.0 : -1.0), -1.0)];
			[shadow set];
			[bezier stroke];
		}
	} else {
		// unselected tab
		NSRect aRect = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);

		// rollover
		if ([cell mouseHovered]) {
			[[NSColor colorWithCalibratedWhite:0.0 alpha:0.1] set];
			NSRectFillUsingOperation(aRect, NSCompositeSourceAtop);
		}

		// frame
		[lineColor set];

		if (orientation == MMTabBarHorizontalOrientation) {
			[bezier moveToPoint:NSMakePoint(aRect.origin.x, aRect.origin.y)];
			[bezier lineToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y)];
			if (!([cell tabState] & MMTab_RightIsSelectedMask)) {
				//draw the tab divider
				[bezier lineToPoint:NSMakePoint(aRect.origin.x + aRect.size.width, aRect.origin.y + aRect.size.height)];
			}
			[bezier stroke];
		} else {
			//No outline for vertical
		}
	}

	[NSGraphicsContext restoreGraphicsState];
	[shadow release];
}

- (void)drawIconOfTabCell:(MMTabBarButtonCell *)cell withFrame:(NSRect)frame inView:(NSView *)controlView {

    MMTabBarView *tabBarView = [controlView enclosingTabBarView];
    
    MMRolloverButton *closeButton = [cell closeButton];
    MMRolloverButtonCell *closeButtonCell = [closeButton cell];
    
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation) {
        if (![cell shouldDisplayCloseButton] || ([cell shouldDisplayCloseButton] && ![closeButton mouseHovered] && ![closeButtonCell mouseHovered])) {
            [cell _drawIconWithFrame:frame inView:controlView];
        }
    } else {
        if (![cell largeImage])
            [cell _drawIconWithFrame:frame inView:controlView];
    }
}

- (void)drawCloseButtonOfTabCell:(MMTabBarButtonCell *)cell withFrame:(NSRect)frame inView:(NSView *)controlView {

    MMTabBarView *tabBarView = [controlView enclosingTabBarView];

    MMRolloverButton *closeButton = [cell closeButton];
    MMRolloverButtonCell *closeButtonCell = [closeButton cell];
    
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation) {
    
        if (![cell icon] || ([cell icon] && [cell shouldDisplayCloseButton] && ([closeButton mouseHovered] || [closeButtonCell mouseHovered])))
    
        [cell _drawCloseButtonWithFrame:frame inView:controlView];
    } else {
    
        if (![cell showObjectCount] || ([cell showObjectCount] && ([closeButton mouseHovered] || [closeButtonCell mouseHovered])))
            [cell _drawCloseButtonWithFrame:frame inView:controlView];
    }
}

- (void)drawObjectCounterOfTabCell:(MMTabBarButtonCell *)cell withFrame:(NSRect)frame inView:(NSView *)controlView {

    MMTabBarView *tabBarView = [controlView enclosingTabBarView];

    MMRolloverButton *closeButton = [cell closeButton];
    MMRolloverButtonCell *closeButtonCell = [closeButton cell];
     
    if ([tabBarView orientation] == MMTabBarHorizontalOrientation) {
        [cell _drawObjectCounterWithFrame:frame inView:controlView];
    } else {
        if (![cell shouldDisplayCloseButton] || ([cell shouldDisplayCloseButton] && ![closeButton mouseHovered] && ![closeButtonCell mouseHovered])) {
            [cell _drawObjectCounterWithFrame:frame inView:controlView];
        }
    }
}

#pragma mark -
#pragma mark Archiving

- (void)encodeWithCoder:(NSCoder *)aCoder {
	if ([aCoder allowsKeyedCoding]) {
		[aCoder encodeObject:_closeButton forKey:@"closeButton"];
		[aCoder encodeObject:_closeButtonDown forKey:@"closeButtonDown"];
		[aCoder encodeObject:_closeButtonOver forKey:@"closeButtonOver"];
		[aCoder encodeObject:_closeDirtyButton forKey:@"closeDirtyButton"];
		[aCoder encodeObject:_closeDirtyButtonDown forKey:@"closeDirtyButtonDown"];
		[aCoder encodeObject:_closeDirtyButtonOver forKey:@"closeDirtyButtonOver"];
		[aCoder encodeObject:_addTabButtonImage forKey:@"addTabButtonImage"];
		[aCoder encodeObject:_addTabButtonPressedImage forKey:@"addTabButtonPressedImage"];
		[aCoder encodeObject:_addTabButtonRolloverImage forKey:@"addTabButtonRolloverImage"];
		[aCoder encodeBool:_drawsUnified forKey:@"drawsUnified"];
		[aCoder encodeBool:_drawsRight forKey:@"drawsRight"];
	}
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		if ([aDecoder allowsKeyedCoding]) {
			_closeButton = [[aDecoder decodeObjectForKey:@"closeButton"] retain];
			_closeButtonDown = [[aDecoder decodeObjectForKey:@"closeButtonDown"] retain];
			_closeButtonOver = [[aDecoder decodeObjectForKey:@"closeButtonOver"] retain];
			_closeDirtyButton = [[aDecoder decodeObjectForKey:@"closeDirtyButton"] retain];
			_closeDirtyButtonDown = [[aDecoder decodeObjectForKey:@"closeDirtyButtonDown"] retain];
			_closeDirtyButtonOver = [[aDecoder decodeObjectForKey:@"closeDirtyButtonOver"] retain];
			_addTabButtonImage = [[aDecoder decodeObjectForKey:@"addTabButtonImage"] retain];
			_addTabButtonPressedImage = [[aDecoder decodeObjectForKey:@"addTabButtonPressedImage"] retain];
			_addTabButtonRolloverImage = [[aDecoder decodeObjectForKey:@"addTabButtonRolloverImage"] retain];
			_drawsUnified = [aDecoder decodeBoolForKey:@"drawsUnified"];
			_drawsRight = [aDecoder decodeBoolForKey:@"drawsRight"];
		}
	}
	return self;
}

@end

