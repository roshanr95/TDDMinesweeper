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
@property(nonatomic,readonly)MinesweeperCellState state;
@property(nonatomic, getter = isClicked, readonly)BOOL clicked;

- (void)reset;
- (void)click;
- (void)rightClick;

@end
