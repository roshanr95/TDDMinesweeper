//
//  MinesweeperMatrix.h
//  TDDMinesweeper
//
//  Created by Roshan Raghupathy on 10/11/13.
//  Copyright (c) 2013 Roshan Raghupathy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MinesweeperMatrix : NSMatrix
@property(nonatomic, weak)id rtarget;
@property(nonatomic)SEL raction;

- (void)reset;
@end
