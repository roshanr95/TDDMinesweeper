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
@property(nonatomic)BOOL gameEnded;
@property(nonatomic)NSUInteger cellsClicked;
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
            int row = arc4random() % self.rows;
            int col = arc4random() % self.columns;
            
            MinesweeperCell *cell = self.grid[row][col];
            if (cell.isMine)
                i--;
            else
            {
                [cell setMine:YES];
                
                MinesweeperCell *nearCell;
                for (int r = MAX(0, row-1); r<MIN(row+2, self.rows); r++)
                {
                    for (int c = MAX(0, col-1); c<MIN(col+2, self.columns); c++)
                    {
                        if(c==cell.column && r==cell.row) continue;
                        nearCell = self.grid[r][c];
                        nearCell.value++;
                    }
                }
            }
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flagAppearReceived) name:MinesweeperCellFlagDidAppear object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flagDisappearReceived) name:MinesweeperCellFlagDidDisappear object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellClicked) name:MinesweeperCellClicked object:nil];
    }
    
    [self addObserver:self forKeyPath:@"cellsClicked" options:NSKeyValueObservingOptionNew context:NULL];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"cellsClicked"];
}
         
- (void)cellClicked
{
    self.cellsClicked++;
    NSLog(@"%lu", (unsigned long)self.cellsClicked);
}

- (void)flagAppearReceived
{
    self.remainingFlags--;
}

- (void)flagDisappearReceived
{
    self.remainingFlags++;
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
    
    if ([cell isMine])
    {
        [self revealMines];
        self.gameOver = YES;
    }
    
    if (cell.value == 0 && !cell.isMine)
    {
        for (NSUInteger r = MAX(0, cell.row-1); r<MIN(cell.row+2, self.rows); r++)
        {
            for (NSUInteger c = MAX(0, cell.column-1); c<MIN(cell.column+2, self.columns); c++)
            {
                if(c==cell.column && r==cell.row) continue;
                if([self.grid[r][c] isClicked]) continue;
                [self cellClickedAtRow:r column:c];
            }
        }
    }
}

- (void)cellRightClickedAtRow:(NSUInteger)row column:(NSUInteger)column
{
    MinesweeperCell *cell = self.grid[row][column];
    if(self.remainingFlags == 0 && cell.state == MinesweeperCellStateDefault) return;
    [cell rightClick];
}

- (void)setRemainingFlags:(NSUInteger)remainingFlags
{
    if (_remainingFlags != remainingFlags) {
        _remainingFlags = remainingFlags;
        [[NSNotificationCenter defaultCenter] postNotificationName:MinesweeperGameRemainingFlagsDidChangeNotification object:self];
    }
}

- (void)revealMines
{
    for (int i=0; i<self.rows; i++) {
        for (int j=0; j<self.columns; j++) {
            MinesweeperCell *cell = self.grid[i][j];
            if (cell.isMine) {
                cell.revealed = YES;
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath  isEqual: @"cellsClicked"] && object == self) {
        if ([change[NSKeyValueChangeNewKey] integerValue] == self.rows*self.columns - self.mineCount) {
            self.gameEnded = YES;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
