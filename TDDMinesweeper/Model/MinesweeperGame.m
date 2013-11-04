//
//  MinesweeperGame.m
//  TDDMinesweeper
//
//  Created by Roshan Raghupathy on 27/09/13.
//  Copyright (c) 2013 Roshan Raghupathy. All rights reserved.
//

#import "MinesweeperGame.h"
#import "MinesweeperGrid.h"
#import "MinesweeperCell.h"

@interface MinesweeperGame ()
@property(nonatomic)NSUInteger remainingFlags;
@property(nonatomic)NSUInteger score;
@property(nonatomic)NSUInteger mineCount;
@property(nonatomic, strong)MinesweeperGrid *grid;
@property(nonatomic)NSUInteger rows;
@property(nonatomic)NSUInteger columns;
@property(nonatomic)BOOL gameOver;
@end

NSString *const MinesweeperGameRemainingFlagsDidChangeNotification = @"MGRemainingFlagsChange";
NSString *const MinesweeperGameGameDidEndNotification = @"MGGameOver";

@interface MinesweeperCell (MineSetting)
- (void)setMine:(BOOL)mine;
@end

@implementation MinesweeperGame

- (MinesweeperGrid *)grid
{
    if(!_grid) _grid = [[MinesweeperGrid alloc] initWithRows:self.rows columns:self.columns];
    return _grid;
}

- (instancetype)initWithMineCount:(NSUInteger)mineCount rows:(NSUInteger)rows columns:(NSUInteger)columns
{
    self = [super init];
    
    if (self) {
        self.mineCount = mineCount;
        self.remainingFlags = mineCount;
        self.rows = rows;
        self.columns = columns;
        
        for (int i=0; i<mineCount; i++) {
            NSUInteger row = arc4random() % self.rows;
            NSUInteger col = arc4random() % self.columns;
            
            MinesweeperCell *cell = self.grid[row][col];
            if (cell.isMine)
                i--;
            else
                [cell setMine:YES];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flagAppearReceived) name:MinesweeperCellFlagDidAppear object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flagDisappearReceived) name:MinesweeperCellFlagDidDisappear object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)flagAppearReceived
{
    self.remainingFlags++;
}

- (void)flagDisappearReceived
{
    self.remainingFlags--;
}

- (void)setGameOver:(BOOL)gameOver
{
    if(_gameOver != gameOver)
    {
        _gameOver = gameOver;
        if (gameOver) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MinesweeperGameGameDidEndNotification object:self];
        }
    }
}

- (void)cellClickedAtRow:(NSUInteger)row column:(NSUInteger)column
{
    MinesweeperCell *cell = self.grid[row][column];
    [cell click];
    
    if ([cell isMine]) {
        self.gameOver = YES;
    }
}

- (void)cellRightClickedAtRow:(NSUInteger)row column:(NSUInteger)column
{
    MinesweeperCell *cell = self.grid[row][column];
    [cell rightClick];
}

- (void)setRemainingFlags:(NSUInteger)remainingFlags
{
    if (_remainingFlags != remainingFlags) {
        _remainingFlags = remainingFlags;
        [[NSNotificationCenter defaultCenter] postNotificationName:MinesweeperGameRemainingFlagsDidChangeNotification object:self];
    }
}

@end
