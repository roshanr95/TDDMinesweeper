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
@end

@implementation MinesweeperCell

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
            [NSException raise:@"Invalid State" format:@"%u is not a valid state", self.state];
    }
    
}

@end
