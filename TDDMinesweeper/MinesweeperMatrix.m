//
//  MinesweeperMatrix.m
//  TDDMinesweeper
//
//  Created by Roshan Raghupathy on 10/11/13.
//  Copyright (c) 2013 Roshan Raghupathy. All rights reserved.
//

#import "MinesweeperMatrix.h"
#import "MinesweeperButtonCell.h"

@interface MinesweeperMatrix ()
@property(nonatomic)BOOL leftClickPossible;
@property(nonatomic)BOOL rightClickPossible;

@property(nonatomic)NSInteger lrow,lcolumn,rrow,rcolumn;
@end

@implementation MinesweeperMatrix

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint locationInWindow = theEvent.locationInWindow;
    NSPoint locationInMatrix = [self convertPoint:locationInWindow fromView:self.window.contentView];
    
    NSInteger row,column;
    BOOL found = [self getRow:&row column:&column forPoint:locationInMatrix];
    
    if (found) {
        self.leftClickPossible = YES;
        self.lrow = row;
        self.lcolumn = column;
        [[self cellAtRow:row column:column] mouseEntered:theEvent];
    }
}

- (void)mouseDragged:(NSEvent *)theEvent
{    
    if (self.leftClickPossible)
    {
        NSPoint locationInWindow = theEvent.locationInWindow;
        NSPoint locationInMatrix = [self convertPoint:locationInWindow fromView:self.window.contentView];
        
        NSInteger row,column;
        BOOL found = [self getRow:&row column:&column forPoint:locationInMatrix];

        if (found)
        {
            if (self.lrow != row || self.lcolumn != column) {
                [[self cellAtRow:self.lrow column:self.lcolumn] mouseExited:theEvent];
                self.lrow = row; self.lcolumn = column;
                [[self cellAtRow:row column:column] mouseEntered:theEvent];
            }
        }
        else
        {
            [[self cellAtRow:self.lrow column:self.lcolumn] mouseExited:theEvent];
        }
    }
    NSLog(@"%@", [theEvent description]);
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (self.leftClickPossible)
    {
        NSPoint locationInWindow = theEvent.locationInWindow;
        NSPoint locationInMatrix = [self convertPoint:locationInWindow fromView:self.window.contentView];
        
        NSInteger row,column;
        BOOL found = [self getRow:&row column:&column forPoint:locationInMatrix];
        
        if (found)
        {
            [[self cellAtRow:self.lrow column:self.lcolumn] mouseExited:theEvent];
        }
        self.leftClickPossible = NO;
    }
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
    if (!self.leftClickPossible)
    {
        NSPoint locationInWindow = theEvent.locationInWindow;
        NSPoint locationInMatrix = [self convertPoint:locationInWindow fromView:self.window.contentView];
        
        NSInteger row,column;
        BOOL found = [self getRow:&row column:&column forPoint:locationInMatrix];
        
        if (found) {
            self.rightClickPossible = YES;
            self.rrow = row;
            self.rcolumn = column;
            [[self cellAtRow:row column:column] mouseEntered:theEvent];
        }
    }
}

- (void)rightMouseDragged:(NSEvent *)theEvent
{
    if (self.rightClickPossible)
    {
        NSPoint locationInWindow = theEvent.locationInWindow;
        NSPoint locationInMatrix = [self convertPoint:locationInWindow fromView:self.window.contentView];
        
        NSInteger row,column;
        BOOL found = [self getRow:&row column:&column forPoint:locationInMatrix];
        
        if (found)
        {
            if (self.rrow != row || self.rcolumn != column) {
                [[self cellAtRow:self.rrow column:self.rcolumn] mouseExited:theEvent];
                self.rrow = row; self.rcolumn = column;
                [[self cellAtRow:row column:column] mouseEntered:theEvent];
            }
        }
        else
        {
            [[self cellAtRow:self.rrow column:self.rcolumn] mouseExited:theEvent];
        }
    }
}

- (void)rightMouseUp:(NSEvent *)theEvent
{
    if (self.rightClickPossible)
    {
        NSPoint locationInWindow = theEvent.locationInWindow;
        NSPoint locationInMatrix = [self convertPoint:locationInWindow fromView:self.window.contentView];
        
        NSInteger row,column;
        BOOL found = [self getRow:&row column:&column forPoint:locationInMatrix];
        
        if (found)
        {
            [[self cellAtRow:self.rrow column:self.rcolumn] mouseExited:theEvent];
        }
        self.rightClickPossible = NO;
    }
}

@end
