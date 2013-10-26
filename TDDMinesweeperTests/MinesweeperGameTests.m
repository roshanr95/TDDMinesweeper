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

@interface MinesweeperGameTests : XCTestCase
@property(nonatomic, strong)MinesweeperGame *testGame;
@property(nonatomic)NSUInteger mineCount;
@property(nonatomic)NSUInteger rows;
@property(nonatomic)NSUInteger columns;
@end

@interface MinesweeperGame (Test)
@property(nonatomic)NSUInteger rows;
@property(nonatomic)NSUInteger columns;
@property(nonatomic, strong)MinesweeperGrid *grid;
@end

@implementation MinesweeperGameTests

- (void)setUp
{
    [super setUp];
    self.mineCount = arc4random() % 20;
    self.rows = arc4random() % 20;
    self.columns = arc4random() % 20;

    self.testGame = [[MinesweeperGame alloc] initWithMineCount:self.mineCount rows:self.rows columns:self.columns];
    
    XCTAssertNotNil(self.testGame);
}

- (void)tearDown
{
    self.testGame = nil;
    [super tearDown];
}

- (void)testInitializerFillsMineCount
{
    XCTAssertEquals(self.mineCount, self.testGame.mineCount);
}

- (void)testInitializerFillsRemainingFlags
{
    XCTAssertEquals(self.mineCount, self.testGame.remainingFlags);
}

- (void)testInitializerFillsRows
{
    XCTAssertEquals(self.rows, self.testGame.rows);
}

- (void)testInitializerFillsColumns
{
    XCTAssertEquals(self.columns, self.testGame.columns);
}

- (void)testInitializerFillsGrid
{
    XCTAssertNotNil(self.testGame.grid);
}

- (void)testClickingCell
{
    
}

@end
