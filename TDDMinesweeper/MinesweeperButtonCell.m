//
//  MinesweeperButtonCell.m
//  TDDMinesweeper
//
//  Created by Roshan Raghupathy on 05/11/13.
//  Copyright (c) 2013 Roshan Raghupathy. All rights reserved.
//

#import "MinesweeperButtonCell.h"
#import "MinesweeperMatrix.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation MinesweeperButtonCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [self drawInteriorWithFrame:cellFrame inView:controlView];
    
    [self drawBezelWithFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSBezierPath *border = [NSBezierPath bezierPathWithRect:cellFrame];
    border.lineWidth = cellFrame.size.width * 0.05;
    
    [[self gradientForState] drawInBezierPath:border angle:90];
    
    [self drawTextWithFrame:cellFrame inView:controlView];
    
    [self drawImage:self.image withFrame:cellFrame inView:controlView];
}

- (void)drawTextWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    if (self.state == NSOffState)
    {
        if (!([self.title  isEqual:@""]||[self.title isEqual:@"0"])) {
            [self drawTitle:self.attributedTitle withFrame:frame inView:controlView];
        }
    }
    else if (self.state == NSMixedState)
    {
        if (!([self.title  isEqual:@""]||[self.title isEqual:@"0"])) {
            [self drawTitle:self.attributedTitle withFrame:frame inView:controlView];
        }
    }
    else if (self.state == NSOnState)
    {
        if (!([self.alternateTitle  isEqual:@""]||[self.alternateTitle isEqual:@"0"])) {
            [self drawTitle:self.attributedAlternateTitle withFrame:frame inView:controlView];
        }
    }
}

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSBezierPath *border = [NSBezierPath bezierPathWithRect:frame];
    border.lineWidth = frame.size.width * 0.05;
    
    [[NSColor darkGrayColor] setStroke];
    [border stroke];
}

- (NSGradient *)gradientForState
{
    if (self.state == NSOffState) {
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithRed:230.0/256
                                                                                         green:230.0/256
                                                                                          blue:230.0/256
                                                                                         alpha:1.0]
                                                             endingColor:[NSColor whiteColor]];
        return gradient;
    } else if (self.state == NSMixedState) {
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithRed:128.0/256
                                                                                         green:128.0/256
                                                                                          blue:128.0/256
                                                                                         alpha:1.0]
                                                             endingColor:[NSColor colorWithRed:204.0/256
                                                                                         green:204.0/256
                                                                                          blue:204.0/256
                                                                                         alpha:1.0]];
        return gradient;
    } else if (self.state == NSOnState) {
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithRed:179.0/256
                                                                                         green:179.0/256
                                                                                          blue:179.0/256
                                                                                         alpha:1.0]
                                                             endingColor:[NSColor colorWithRed:236.0/256
                                                                                         green:236.0/256
                                                                                          blue:236.0/256
                                                                                         alpha:1.0]];
        return gradient;
    }
    
    return nil;
}

- (void)mouseEntered:(NSEvent *)event
{
    self.state = NSMixedState;
}

- (void)mouseExited:(NSEvent *)event
{
    NSEventType type = event.type;
    if (type == NSLeftMouseUp)
    {
        self.state = NSOnState;
        NSMatrix *control = (NSMatrix *)self.controlView;
        SuppressPerformSelectorLeakWarning([control.target performSelector:control.action withObject:self]);
    }
    else if (type == NSLeftMouseDragged)
    {
        self.state = NSOffState;
    }
    else if (type == NSRightMouseUp)
    {
        self.state = NSOffState;
        MinesweeperMatrix *control = (MinesweeperMatrix *)self.controlView;
        SuppressPerformSelectorLeakWarning([control.rtarget performSelector:control.raction withObject:self]);
    }
    else if (type == NSRightMouseDragged)
    {
        self.state = NSOffState;
    }
}

- (void)setState:(NSInteger)value
{
    if (self.state != NSOnState)
    {
        [super setState:value];
    }
}

@end
