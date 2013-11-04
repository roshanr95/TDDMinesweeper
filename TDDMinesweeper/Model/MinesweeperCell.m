//
//  MinesweeperCell.m
//  TDDMinesweeper
//
//  Created by Roshan Raghupathy on 25/09/13.
//  Copyright (c) 2013 Roshan Raghupathy. All rights reserved.
//

#import "MinesweeperCell.h"

@interface MinesweeperCell ()
@property(nonatomic)MinesweeperCellState state;
@property(nonatomic, getter = isClicked)BOOL clicked;
@property(nonatomic)NSUInteger value;
@property(nonatomic)NSUInteger row;
@property(nonatomic)NSUInteger column;
@end

NSString *const MinesweeperCellDidUpdate = @"MCUpdate";
NSString *const MinesweeperCellFlagDidAppear = @"MCFlagAppear";
NSString *const MinesweeperCellFlagDidDisappear = @"MCFlagDisappear";
@implementation MinesweeperCell

- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column
{
    self = [super init];
    
    if (self) {
        self.row = row;
        self.column = column;
    }
    
    return self;
}

- (NSString *)description
{
    if (self.isMine) {
        return @"M";
    } else {
        return [NSString stringWithFormat:@"%lu", (unsigned long)self.value];
    }
}

- (void)reset
{
    self.mine = NO;
    self.value = 0;
    self.state = MinesweeperCellStateDefault;
    self.clicked = NO;
}

- (void)click
{
    self.state = MinesweeperCellStateDefault;
    self.clicked = YES;
}

- (void)rightClick
{
    switch (self.state) {
        case MinesweeperCellStateDefault:
            self.state = MinesweeperCellStateFlag;
            break;
        case MinesweeperCellStateFlag:
            self.state = MinesweeperCellStateQuestionMark;
            break;
        case MinesweeperCellStateQuestionMark:
            self.state = MinesweeperCellStateDefault;
            break;
        default:
            [NSException raise:@"InvalidState" format:@"%u is not a valid state", self.state];
    }
}

- (void)setState:(MinesweeperCellState)state
{
    if (!self.isClicked) {
        if (_state != state) {
            if (_state == MinesweeperCellStateFlag) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MinesweeperCellFlagDidDisappear object:self];
            }
            _state = state;
            [[NSNotificationCenter defaultCenter] postNotificationName:MinesweeperCellDidUpdate object:self];
            if (_state == MinesweeperCellStateFlag) {
                [[NSNotificationCenter defaultCenter] postNotificationName:MinesweeperCellFlagDidAppear object:self];
            }
        }
    }
}

- (void)setClicked:(BOOL)clicked
{
    if (_clicked != clicked) {
        _clicked = clicked;
            [[NSNotificationCenter defaultCenter] postNotificationName:MinesweeperCellDidUpdate object:self];
    }
}

@end
