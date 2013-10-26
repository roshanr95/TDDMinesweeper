//
//  MinesweeperCellTests.m
//  TDDMinesweeper
//
//  Created by Roshan Raghupathy on 25/09/13.
//  Copyright (c) 2013 Roshan Raghupathy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MinesweeperCell.h"

@interface MinesweeperCellTests : XCTestCase
@property (nonatomic, strong) MinesweeperCell *testCell;
@end

@implementation MinesweeperCellTests

- (MinesweeperCellState)nextState:(MinesweeperCellState)state
{
    switch (state) {
        case MinesweeperCellStateDefault:
            return MinesweeperCellStateFlag;
        case MinesweeperCellStateFlag:
            return MinesweeperCellStateQuestionMark;
        case MinesweeperCellStateQuestionMark:
            return MinesweeperCellStateDefault;
        default:
            [NSException raise:@"Invalid State" format:@"%u is not a valid state", state];
    }
}

- (void)setUp
{
    [super setUp];
    self.testCell = [[MinesweeperCell alloc] init];
    XCTAssertNotNil(self.testCell);
}

- (void)tearDown
{
    self.testCell = nil;
    [super tearDown];
}

- (void)testDescriptionWhenCellIsMine
{
    self.testCell.mine = YES;
    XCTAssertEqualObjects([self.testCell description], @"M");
}

- (void)testDescriptionWhenCellIsNotMineWithRandomValueFrom0To8
{
    NSUInteger randomValue = arc4random() % 9;
    
    self.testCell.mine = NO;
    self.testCell.value = randomValue;
    
    NSString *desc = [NSString stringWithFormat:@"%lu", (unsigned long)randomValue];
    
    XCTAssertEqualObjects([self.testCell description], desc);
}

- (void)testReset
{
    [self.testCell reset];
    
    XCTAssertFalse(self.testCell.isMine);
    XCTAssertEquals(self.testCell.value, (NSUInteger)0);
    XCTAssertEquals(self.testCell.state, MinesweeperCellStateDefault);
    XCTAssertFalse(self.testCell.isClicked);
}

- (void)testClickSetsClickedToYes
{
    [self.testCell reset];
    
    [self.testCell click];
    
    XCTAssertTrue(self.testCell.isClicked);
}

- (void)testRightClickChangesStateFromDefaultToFlag
{    
    while (self.testCell.state != MinesweeperCellStateDefault) {
        [self.testCell rightClick];
    }
    [self.testCell rightClick];
    
    XCTAssertEquals(self.testCell.state, MinesweeperCellStateFlag);
}

- (void)testRightClickChangesStateFromFlagToQuestionMark
{
    while (self.testCell.state != MinesweeperCellStateFlag) {
        [self.testCell rightClick];
    }
    [self.testCell rightClick];
    
    XCTAssertEquals(self.testCell.state, MinesweeperCellStateQuestionMark);
}

- (void)testRightClickChangesStateFromQuestionMarkToDefault
{
    while (self.testCell.state != MinesweeperCellStateQuestionMark) {
        [self.testCell rightClick];
    }
    [self.testCell rightClick];
    
    XCTAssertEquals(self.testCell.state, MinesweeperCellStateDefault);
}

@end
