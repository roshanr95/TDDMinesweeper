//
//  MinesweeperGame.h
//  TDDMinesweeper
//
//  Created by Roshan Raghupathy on 27/09/13.
//  Copyright (c) 2013 Roshan Raghupathy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MinesweeperGame : NSObject
@property(nonatomic, readonly)NSUInteger remainingFlags;
@property(nonatomic, readonly)NSUInteger score;
@property(nonatomic, readonly)NSUInteger mineCount;

- (id)initWithMineCount:(NSUInteger)mineCount rows:(NSUInteger)rows columns:(NSUInteger)columns; //Designated

- (void)cellClickedAtRow:(NSUInteger)row column:(NSUInteger)column;

@end

NSString *MinesweeperGameRemainingFlagsDidChangeNotification;