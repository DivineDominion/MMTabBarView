//
//  MMAttachedTabBarButton.m
//  MMTabBarView
//
//  Created by Michael Monscheuer on 9/5/12.
//
//

#import "MMAttachedTabBarButton.h"

#import "MMAttachedTabBarButtonCell.h"
#import "MMTabDragAssistant.h"
#import "MMTabStyle.h"
#import "NSView+MMTabBarViewExtensions.h"

@interface MMAttachedTabBarButton (/*Private*/)

- (MMAttachedTabBarButton *)_selectedAttachedTabBarButton;
- (BOOL)_allowsDragging;
- (NSRect)_draggingRect;

@end

@implementation MMAttachedTabBarButton

@synthesize tabViewItem = _tabViewItem;
@dynamic slidingFrame;

+ (void)initialize {
    [super initialize];    
}

+ (Class)cellClass {
    return [MMAttachedTabBarButtonCell class];
}

- (id)initWithFrame:(NSRect)frame tabViewItem:(NSTabViewItem *)anItem {

    self = [super initWithFrame:frame];
    if (self) {
        _tabViewItem = [anItem retain];
    }

    return self;
}

- (id)initWithFrame:(NSRect)frame {

    NSAssert(FALSE,@"please use designated initializer -initWithFrame:tabViewItem:");

    [self release];
    return nil;
}

- (void)dealloc
{
    [_tabViewItem release], _tabViewItem = nil;
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (MMAttachedTabBarButtonCell *)cell {
    return (MMAttachedTabBarButtonCell *)[super cell];
}

- (void)setCell:(MMAttachedTabBarButtonCell *)aCell {
    [super setCell:aCell];
}

#pragma mark -
#pragma mark Accessors

- (NSRect)slidingFrame {
    @synchronized(self) {
        return [self frame];
    }
}

- (void)setSlidingFrame:(NSRect)aRect {
    @synchronized(self) {
        aRect.origin.y = [self frame].origin.y;
        [self setFrame:aRect];
    }
}

#pragma mark -
#pragma mark Event Handling

- (void)mouseDown:(NSEvent *)theEvent {

    MMAttachedTabBarButton *previousSelectedButton = [self _selectedAttachedTabBarButton];

    MMTabBarView *tabBarView = [self tabBarView];

        // select immediately
    if ([tabBarView selectsTabsOnMouseDown]) {
        [previousSelectedButton setState:NSOffState];
        [self performClick:self];
    }
    
        // eventually begin dragging of button
    if ([self mm_dragShouldBeginFromMouseDown:theEvent withExpiration:[NSDate distantFuture]]) {
        [tabBarView startDraggingAttachedTabBarButton:self withMouseDownEvent:theEvent];
    }
}

- (void)mouseUp:(NSEvent *)theEvent {

    MMTabBarView *tabBarView = [self tabBarView];
    
    NSPoint mouseUpPoint = [theEvent locationInWindow];
    NSPoint mousePt = [self convertPoint:mouseUpPoint fromView:nil];
    
    if (NSMouseInRect(mousePt, [self bounds], [self isFlipped])) {
        if (![tabBarView selectsTabsOnMouseDown]) {
            MMAttachedTabBarButton *previousSelectedButton = [self _selectedAttachedTabBarButton];
            [previousSelectedButton setState:NSOffState];
            [self performClick:self];
        }
    }
}

#pragma mark -
#pragma mark Drag Support

- (NSRect)draggingRect {

    id <MMTabStyle> style = [self style];
    MMTabBarView *tabBarView = [self tabBarView];

    NSRect draggingRect = NSZeroRect;
    
    if (style && [style respondsToSelector:@selector(dragRectForTabButton:ofTabBarView:)]) {
        draggingRect = [style draggingRectForTabButton:self ofTabBarView:tabBarView];
    } else {
        draggingRect = [self _draggingRect];
    }
    
    return draggingRect;
}

- (NSImage *)dragImage {

        // assure that we will draw the tab bar contents correctly
    [self setFrame:[self stackingFrame]];

    MMTabBarView *tabBarView = [self tabBarView];

    NSRect draggingRect = [self draggingRect];
        
	[tabBarView lockFocus];
    [tabBarView display];  // forces update to ensure that we get current state
	NSBitmapImageRep *rep = [[[NSBitmapImageRep alloc] initWithFocusedViewRect:draggingRect] autorelease];
	[tabBarView unlockFocus];
	NSImage *image = [[[NSImage alloc] initWithSize:[rep size]] autorelease];
	[image addRepresentation:rep];
	NSImage *returnImage = [[[NSImage alloc] initWithSize:[rep size]] autorelease];
	[returnImage lockFocus];
    [image drawAtPoint:NSMakePoint(0.0, 0.0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	[returnImage unlockFocus];
	if (![[self indicator] isHidden]) {
		NSImage *pi = [[NSImage alloc] initByReferencingFile:[[MMTabBarView bundle] pathForImageResource:@"pi"]];
		[returnImage lockFocus];
		NSPoint indicatorPoint = NSMakePoint([self frame].size.width - MARGIN_X - kMMTabBarIndicatorWidth, MARGIN_Y);
        [pi drawAtPoint:indicatorPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
		[returnImage unlockFocus];
		[pi release];
	}
	return returnImage;
}

#pragma mark -
#pragma mark Private Methods

- (MMAttachedTabBarButton *)_selectedAttachedTabBarButton {

    MMTabBarView *tabBarView = [self enclosingTabBarView];
    return [tabBarView selectedAttachedButton];
}

- (BOOL)_allowsDragging {

    MMTabBarView *tabBarView = [self tabBarView];
    NSTabView *tabView = [tabBarView tabView];
    id <MMTabBarViewDelegate>tabBarViewDelegate = [tabBarView delegate];

    // ask delegate 
    if (tabBarViewDelegate && [tabBarViewDelegate respondsToSelector:@selector(tabView:shouldDragTabViewItem:inTabBar:)]) {
        if ([tabBarViewDelegate tabView:tabView shouldDragTabViewItem:[self tabViewItem] inTabBar:tabBarView])
            return YES;
    }
        
    return NO;
}

- (NSRect)_draggingRect {
    return [self frame];
}

@end
