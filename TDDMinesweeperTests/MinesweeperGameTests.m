//
//  MinesweeperGameTests.m
//  TDDMinesweeper
//
//  Created by Roshan Raghupathy on 27/09/13.
//  Copyright (c) 2013 Roshan Raghupathy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MinesweeperGame.h"

#import "MinesweeperGrid.h"
#import "MinesweeperCell.h"

@interface MinesweeperGameTests : XCTestCase
@property(nonatomic, strong)MinesweeperGame *testGame;
@property(nonatomic)NSUInteger mineCount;
@property(nonatomic)NSUInteger rows;
@property(nonatomic)NSUInteger columns;

@property(nonatomic)BOOL gameOverNotified;
@property(nonatomic)BOOL remainingFlagChangeNotified;
@end

@interface MinesweeperGame (Testing)
@property(nonatomic)NSUInteger rows;
@property(nonatomic)NSUInteger columns;
@property(nonatomic, strong)MinesweeperGrid *grid;

- (void)setGameOver:(BOOL)gameOver;
- (void)setRemainingFlags:(BOOL)remainingFlags;
@end

@interface MinesweeperCell (Testing)
- (void)setMine:(BOOL)mine;
@end

@implementation MinesweeperGameTests

- (void)setUp
{
    [super setUp];
    self.mineCount = 1 + arc4random() % 20;
    self.rows = 1 + arc4random() % 20;
    self.columns = 1 + arc4random() % 20;
    self.gameOverNotified = NO;

    self.testGame = [[MinesweeperGame alloc] initWithMineCount:self.mineCount rows:self.rows columns:self.columns];
        
    XCTAssertNotNil(self.testGame);
}

- (void)tearDown
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.testGame = nil;
    
    [super tearDown];
}

- (void)testInitializer
{
    XCTAssertEquals(self.mineCount, self.testGame.mineCount);
    XCTAssertEquals(self.mineCount, self.testGame.remainingFlags);
    XCTAssertEquals(self.rows, self.testGame.rows);
    XCTAssertEquals(self.columns, self.testGame.columns);
    XCTAssertEquals(NO, self.testGame.gameOver);

    XCTAssertNotNil(self.testGame.grid);
    NSUInteger mineCount = 0;
    for (int i=0; i<self.rows; i++) {
        for (int j=0; j<self.columns; j++) {
            NSUInteger v=0;
            MinesweeperCell *cell = self.testGame.grid[i][j];
            for (int r = MAX(0, i-1); r<MIN(i+2, self.rows); r++) {
                for (int c = MAX(0, j-1); c<MIN(j+2, self.columns); c++) {
                    if(cell.column==c && r==cell.row) continue;
                    if ([self.testGame.grid[r][c] isMine]) {
                        v++;
                    }
                }
            }
            XCTAssertEquals(v, cell.value);

            if ([self.testGame.grid[i][j] isMine]) {
                mineCount++;
            }
        }
    }
    XCTAssertEquals(self.mineCount, mineCount);
}

- (void)testClickingCellMarksCellAsClicked
{
    NSUInteger row = arc4random() % self.rows;
    NSUInteger col = arc4random() % self.columns;
    
    [self.testGame cellClickedAtRow:row column:col];
    
    MinesweeperCell *cell = self.testGame.grid[row][col];
    XCTAssertEquals(cell.isClicked, YES);
}

- (void)testClickingMineSetsGameOver
{
    NSUInteger row,col = 0;
    BOOL b = YES;
    
    for (row=0; row<self.rows && b; row++)
    {
        for (col=0; col<self.columns && b; col++)
        {
            if ([self.testGame.grid[row][col] isMine])
            {
                b = NO;
            }
        }
    }
    
    [self.testGame cellClickedAtRow:(row-1) column:(col-1)];
    
    XCTAssertTrue(self.testGame.gameOver);
}

- (void)remainingFlagChangeReceived
{
    self.remainingFlagChangeNotified = YES;
}

- (void)gameOverReceived
{
    self.gameOverNotified = YES;
}

- (void)testSettingGameOverPostsNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameOverReceived) name:MinesweeperGameGameDidEndNotification object:self.testGame];

    [self.testGame setGameOver:YES];
    
    XCTAssertTrue(self.gameOverNotified);
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)testRightClicking
{
    NSUInteger row = arc4random() % self.rows;
    NSUInteger col = arc4random() % self.columns;
    
    MinesweeperCell *cell = self.testGame.grid[row][col];
    XCTAssertEquals(cell.state, MinesweeperCellStateDefault);
    
    [self.testGame cellRightClickedAtRow:row column:col];    
    XCTAssertEquals(cell.state, MinesweeperCellStateFlag);
    
    [self.testGame cellRightClickedAtRow:row column:col];
    XCTAssertEquals(cell.state, MinesweeperCellStateQuestionMark);

    [self.testGame cellRightClickedAtRow:row column:col];
    XCTAssertEquals(cell.state, MinesweeperCellStateDefault);
}

- (void)testChangingRemainingFlagsPostsNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remainingFlagChangeReceived) name:MinesweeperGameRemainingFlagsDidChangeNotification object:self.testGame];
    self.remainingFlagChangeNotified = NO;
    self.testGame.remainingFlags++;
    XCTAssertTrue(self.remainingFlagChangeNotified);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)testRightClickingUpdatesRemainingFlag
{
    NSUInteger row = arc4random() % self.rows;
    NSUInteger col = arc4random() % self.columns;
    NSUInteger flags = self.testGame.remainingFlags;
    
    MinesweeperCell *cell = self.testGame.grid[row][col];
    XCTAssertEquals(cell.state, MinesweeperCellStateDefault);
    
    [self.testGame cellRightClickedAtRow:row column:col];
    XCTAssertEquals(self.testGame.remainingFlags, flags+1);
    
    [self.testGame cellRightClickedAtRow:row column:col];
    XCTAssertEquals(self.testGame.remainingFlags, flags);
}

- (void)testClickingFlagUpdatesRemainingFlag
{
    NSUInteger row = arc4random() % self.rows;
    NSUInteger col = arc4random() % self.columns;
    
    MinesweeperCell *cell = self.testGame.grid[row][col];
    XCTAssertEquals(cell.state, MinesweeperCellStateDefault);
    
    [self.testGame cellRightClickedAtRow:row column:col];
    NSUInteger flags = self.testGame.remainingFlags;
    
    [self.testGame cellClickedAtRow:row column:col];
    XCTAssertEquals(self.testGame.remainingFlags, flags-1);
}

- (void)testClickingOnMineRevealsMines
{
    NSUInteger row,col = 0;
    BOOL b = YES;
    
    for (row=0; row<self.rows && b; row++)
    {
        for (col=0; col<self.columns && b; col++)
        {
            if ([self.testGame.grid[row][col] isMine])
            {
                b = NO;
            }
        }
    }
    
    [self.testGame cellClickedAtRow:(row-1) column:(col-1)];
    
    for (int i=0; i<self.rows; i++) {
        for (int j=0; j<self.columns; j++) {
            MinesweeperCell *cell = self.testGame.grid[i][j];
            if (cell.isMine) {
                XCTAssertTrue(cell.revealed);
            }
        }
    }
}

@end
