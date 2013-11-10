//
//  AppDelegate.m
//  TDDMinesweeper
//
//  Created by Roshan Raghupathy on 24/09/13.
//  Copyright (c) 2013 Roshan Raghupathy. All rights reserved.
//

#import "AppDelegate.h"
#import "MinesweeperGame.h"
#import "MinesweeperMatrix.h"
#import "MinesweeperButtonCell.h"
#import "MinesweeperCell.h"

@interface AppDelegate ()
@property (weak) IBOutlet MinesweeperMatrix *matrix;

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)MinesweeperGame *game;
@end

@implementation AppDelegate

- (MinesweeperGame *)game
{
    if(!_game) _game = [[MinesweeperGame alloc] initWithMineCount:10 rows:10 columns:10];
    return _game;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    for (int i=0; i<self.matrix.numberOfRows; i++) {
        for (int j=0; j<self.matrix.numberOfColumns; j++) {
            MinesweeperButtonCell *viewCell = [self.matrix cellAtRow:i column:j];
            MinesweeperCell *modelCell = self.game.grid[i][j];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelCellChanged:) name:MinesweeperCellDidUpdate object:modelCell];
            viewCell.representedObject = modelCell;
        }
    }
    
    [self.matrix setTarget:self];
    [self.matrix setAction:@selector(leftClick:)];
    self.matrix.rtarget = self;
    self.matrix.raction = @selector(rightClick:);
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)leftClick:(id)sender
{
    MinesweeperButtonCell *cell = (MinesweeperButtonCell *)sender;
    MinesweeperCell *modelCell = (MinesweeperCell *)cell.representedObject;
    [self.game cellClickedAtRow:modelCell.row column:modelCell.column];
}

- (IBAction)rightClick:(id)sender
{
    MinesweeperButtonCell *cell = (MinesweeperButtonCell *)sender;
    MinesweeperCell *modelCell = (MinesweeperCell *)cell.representedObject;
    [self.game cellRightClickedAtRow:modelCell.row column:modelCell.column];
}

- (void)modelCellChanged:(NSNotification *)aNotification
{
    MinesweeperCell *modelCell = aNotification.object;
    MinesweeperButtonCell *viewCell = [self.matrix cellAtRow:modelCell.row column:modelCell.column];
    
    NSLog(@"%lu%lu", (unsigned long)modelCell.row, (unsigned long)modelCell.column);
}

@end
