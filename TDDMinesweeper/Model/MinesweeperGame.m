//
//  MinesweeperGame.m
//  TDDMinesweeper
//
//  Created by Roshan Raghupathy on 27/09/13.
//  Copyright (c) 2013 Roshan Raghupathy. All rights reserved.
//

#import "MinesweeperGame.h"
#import "MinesweeperGrid.h"

@interface MinesweeperGame ()
@property(nonatomic)NSUInteger remainingFlags;
@property(nonatomic)NSUInteger score;
@property(nonatomic)NSUInteger mineCount;
@property(nonatomic, strong)MinesweeperGrid *grid;
@property(nonatomic)NSUInteger rows;
@property(nonatomic)NSUInteger columns;
@end

NSString *MinesweeperGameRemainingFlagsDidChangeNotification = @"MGRemainingFlagsChange";

@implementation MinesweeperGame

- (MinesweeperGrid *)grid
{
    if(!_grid) _grid = [[MinesweeperGrid alloc] initWithRows:self.rows columns:self.columns];
    return _grid;
}

- (id)initWithMineCount:(NSUInteger)mineCount rows:(NSUInteger)rows columns:(NSUInteger)columns
{
    self = [super init];
    
    if (self) {
        self.mineCount = mineCount;
        self.remainingFlags = mineCount;
        self.rows = rows;
        self.columns = columns;
    }
    
    return self;
}

- (void)cellClickedAtRow:(NSUInteger)row column:(NSUInteger)column
{
    
}

@end
