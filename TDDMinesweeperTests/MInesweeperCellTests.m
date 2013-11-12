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
@property(nonatomic, strong) MinesweeperCell *testCell;
@property(nonatomic)NSInteger row;
@property(nonatomic)NSInteger column;

@property(nonatomic)BOOL update;
@property(nonatomic)BOOL flagAppear;
@property(nonatomic)BOOL flagDisappear;
@end

@interface MinesweeperCell (Testing)
- (void)setState:(MinesweeperCellState)state;
- (void)setValue:(NSUInteger)value;
@end

@implementation MinesweeperCellTests

- (void)setUp
{
    [super setUp];
    self.row = arc4random() % 20;
    self.column = arc4random() % 20;
    self.update = NO;
    self.flagAppear = NO;
    self.flagDisappear = NO;
    self.testCell = [[MinesweeperCell alloc] initWithRow:self.row column:self.column];
    XCTAssertNotNil(self.testCell);
}

- (void)tearDown
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.testCell = nil;
    [super tearDown];
}

- (void)updateReceived
{
    self.update = YES;
}

- (void)testInitializer
{
    XCTAssertEquals(self.row, self.testCell.row);
    XCTAssertEquals(self.column, self.testCell.column);
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

- (void)testClick
{
    [self.testCell rightClick];
    [self.testCell click];
    XCTAssertTrue(self.testCell.isClicked);
    XCTAssertEquals(self.testCell.state, MinesweeperCellStateDefault);
}

- (void)testRightClick
{    
    [self.testCell setState:MinesweeperCellStateDefault];
    
    [self.testCell rightClick];
    XCTAssertEquals(self.testCell.state, MinesweeperCellStateFlag);
    
    [self.testCell rightClick];
    XCTAssertEquals(self.testCell.state, MinesweeperCellStateQuestionMark);
    
    [self.testCell rightClick];
    XCTAssertEquals(self.testCell.state, MinesweeperCellStateDefault);
    
    [self.testCell setState:5];
    XCTAssertThrowsSpecificNamed([self.testCell rightClick], NSException, @"InvalidState");
}

- (void)testUpdateNotificationUponRightClicking
{
    XCTAssertFalse(self.update);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateReceived) name:MinesweeperCellDidUpdate object:self.testCell];

    [self.testCell rightClick];
    
    XCTAssertTrue(self.update);

    [self.testCell click];
    self.update = NO;
    
    [self.testCell rightClick];
    
    XCTAssertFalse(self.update);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)testUpdateNotificationUponClicking
{
    XCTAssertFalse(self.update);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateReceived) name:MinesweeperCellDidUpdate object:self.testCell];
    
    [self.testCell click];

    XCTAssertTrue(self.update);
    
    self.update = NO;
    
    [self.testCell click];
    
    XCTAssertFalse(self.update);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)flagAppearReceived
{
    self.flagAppear = YES;
}

- (void)flagDisappearReceived
{
    self.flagDisappear = YES;
}

- (void)testFlagAppearNotification
{
    XCTAssertFalse(self.flagAppear);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flagAppearReceived) name:MinesweeperCellFlagDidAppear object:self.testCell];
    
    [self.testCell rightClick];
    
    XCTAssertTrue(self.flagAppear);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)testFlagDisappearNotification
{
    XCTAssertFalse(self.flagDisappear);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flagDisappearReceived) name:MinesweeperCellFlagDidDisappear object:self.testCell];
    
    [self.testCell rightClick];
    [self.testCell rightClick];
    
    XCTAssertTrue(self.flagDisappear);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
