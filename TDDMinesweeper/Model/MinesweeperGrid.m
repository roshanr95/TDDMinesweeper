//
//  MinesweeperGrid.m
//  TDDMinesweeper
//
//  Created by Roshan Raghupathy on 25/09/13.
//  Copyright (c) 2013 Roshan Raghupathy. All rights reserved.
//

#import "MinesweeperGrid.h"
#import "MinesweeperCell.h"

@interface MinesweeperGrid ()
@property(nonatomic) NSUInteger rows;
@property(nonatomic) NSUInteger columns;
@property(nonatomic, strong) NSMutableArray *cellGrid;
@end

@implementation MinesweeperGrid

- (instancetype)initWithRows:(NSUInteger)rows columns:(NSUInteger)columns
{
    self = [super init];
    
    if(self)
    {
        self.rows = rows;
        self.columns = columns;
        self.cellGrid = [[NSMutableArray alloc] initWithCapacity:rows];
        for (int i=0; i<rows; i++) {
            self.cellGrid[i] = [[NSMutableArray alloc] initWithCapacity:columns];
            for (int j=0; j<columns; j++) {
                self.cellGrid[i][j] = [[MinesweeperCell alloc] init];
            }
        }
    }
    
    return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return self.cellGrid[idx];
}

@end
