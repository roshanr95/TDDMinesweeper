//
//  MinesweeperCell.h
//  TDDMinesweeper
//
//  Created by Roshan Raghupathy on 25/09/13.
//  Copyright (c) 2013 Roshan Raghupathy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MinesweeperCellStateDefault = 0,
    MinesweeperCellStateFlag,
    MinesweeperCellStateQuestionMark
}MinesweeperCellState;

@interface MinesweeperCell : NSObject
@property(nonatomic, getter = isMine)BOOL mine;
@property(nonatomic)NSUInteger value;
@property(nonatomic, readonly)MinesweeperCellState state;
@property(nonatomic, getter = isClicked, readonly)BOOL clicked;
@property(nonatomic, readonly)NSInteger row;
@property(nonatomic, readonly)NSInteger column;
@property(nonatomic, getter = isRevealed)BOOL revealed;

- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column;

- (void)reset;
- (void)click;
- (void)rightClick;

@end

FOUNDATION_EXPORT NSString *const MinesweeperCellDidUpdate;
FOUNDATION_EXPORT NSString *const MinesweeperCellFlagDidAppear;
FOUNDATION_EXPORT NSString *const MinesweeperCellFlagDidDisappear;
FOUNDATION_EXPORT NSString *const MinesweeperCellClicked;
