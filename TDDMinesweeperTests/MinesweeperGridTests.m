//
//  MinesweeperGridTests.m
//  TDDMinesweeper
//
//  Created by Roshan Raghupathy on 27/09/13.
//  Copyright (c) 2013 Roshan Raghupathy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MinesweeperGrid.h"

#import "MinesweeperCell.h"

@interface MinesweeperGridTests : XCTestCase
@property(nonatomic, strong) MinesweeperGrid *testGrid;
@property(nonatomic) NSUInteger rows;
@property(nonatomic) NSUInteger columns;
@end

@implementation MinesweeperGridTests

#define maxRows 15
#define maxColumns 10

- (void)setUp
{
    [super setUp];
    self.rows = arc4random() % maxRows;
    self.columns = arc4random() % maxColumns;
    self.testGrid = [[MinesweeperGrid alloc] initWithRows:self.rows columns:self.columns];
    XCTAssertNotNil(self.testGrid);
}

- (void)tearDown
{
    self.testGrid = nil;
    [super tearDown];
}

- (void)testInitializerFillsRows
{
    XCTAssertEquals(self.testGrid.rows, self.rows);
}

- (void)testInitializerFillsColumns
{
    XCTAssertEquals(self.testGrid.columns, self.columns);
}

- (void)testInitializerFillsGrid
{
    for (int i=0; i<self.rows; i++) {
        for (int j=0; j<self.columns; j++) {
            XCTAssertNotNil(self.testGrid[i][j]);
            
            XCTAssertEqualObjects([MinesweeperCell class], [self.testGrid[i][j] class]);
        }
        XCTAssertThrowsSpecificNamed(self.testGrid[i][self.columns], NSException, NSRangeException);
    }
    
    XCTAssertThrowsSpecificNamed(self.testGrid[self.rows], NSException, NSRangeException);
}

@end
