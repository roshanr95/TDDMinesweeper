//
//  MinesweeperGrid.h
//  TDDMinesweeper
//
//  Created by Roshan Raghupathy on 25/09/13.
//  Copyright (c) 2013 Roshan Raghupathy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MinesweeperCell;

@interface MinesweeperGrid : NSObject
@property(nonatomic, readonly) NSUInteger rows;
@property(nonatomic, readonly) NSUInteger columns;
@property(nonatomic, readonly, strong) NSMutableArray *cellGrid;

- (id)initWithRows:(NSUInteger)rows columns:(NSUInteger)columns; //Designated

- (id)objectAtIndexedSubscript:(NSUInteger)idx;

@end
