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
@property (weak) IBOutlet NSButton *resetButton;
@property (weak) IBOutlet NSTextField *flagLabel;
@property (weak) IBOutlet NSUserDefaultsController *userDefaultsController;
@property (weak) IBOutlet NSNumberFormatter *rowFormatter;

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)MinesweeperGame *game;
@property(nonatomic)NSUInteger rows;
@property(nonatomic)NSUInteger columns;
@property(nonatomic)NSUInteger mineCount;
@end

@implementation AppDelegate

#define HighScoresFilePath @"~/Documents/HighScores.txt"

- (MinesweeperGame *)game
{
    if(!_game) _game = [[MinesweeperGame alloc] initWithMineCount:10 rows:10 columns:10];
    return _game;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setUp];
}

- (void)setUp
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameOver) name:MinesweeperGameGameDidEndNotification object:self.game];
    
    [self.game addObserver:self forKeyPath:@"remainingFlags" options:NSKeyValueObservingOptionNew context:NULL];
    [self.game addObserver:self forKeyPath:@"gameEnded" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.game removeObserver:self forKeyPath:@"remainingFlags"];
    [self.game removeObserver:self forKeyPath:@"gameEnded"];
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
    
    if (modelCell.isClicked)
    {
        [viewCell setState:NSOnState];
        if (modelCell.isMine)
        {
            viewCell.alternateTitle = @"💥";
            viewCell.alternateImage = nil;
        }
        else
        {
            viewCell.alternateTitle = [NSString stringWithFormat:@"%lu", (unsigned long)modelCell.value];
            viewCell.attributedAlternateTitle = [self attributedStringForValue:modelCell.value];
            viewCell.alternateImage = nil;
        }
    }
    else
    {
        if (modelCell.state == MinesweeperCellStateDefault)
        {
            viewCell.title = nil;
            viewCell.image = nil;
        }
        else if (modelCell.state == MinesweeperCellStateFlag)
        {
            viewCell.title = @"🚩";
            viewCell.image = nil;
        }
        else
        {
            viewCell.title = @"❓";
            viewCell.image = nil;
        }
    }
}

- (NSColor *)colorForValue:(NSUInteger)value
{
    switch (value) {
        case 0:
            return [NSColor blackColor];
        case 1:
            return [NSColor blueColor];
        case 2:
            return [NSColor colorWithDeviceRed:0.0 green:0.5 blue:0 alpha:1];
        case 3:
            return [NSColor redColor];
        case 4:
            return [NSColor colorWithDeviceRed:0 green:0 blue:0.5 alpha:1];
        case 5:
            return [NSColor brownColor];
        case 6:
            return [NSColor cyanColor];
        case 7:
            return [NSColor blackColor];
        case 8:
            return [NSColor darkGrayColor];
        default:
            return nil;
    }
    
    return nil;
}

- (NSAttributedString *)attributedStringForValue:(NSUInteger)value
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = kCTTextAlignmentCenter;
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu", (unsigned long)value]
                                                                 attributes:@{NSForegroundColorAttributeName: [self colorForValue:value],
                                                                              NSParagraphStyleAttributeName: paragraphStyle}];
    
    return string;
}

- (void)gameOver
{
    for (NSUInteger i = 0; i<self.matrix.numberOfRows; i++) {
        for (NSUInteger j = 0; j<self.matrix.numberOfColumns; j++) {
            MinesweeperCell *modelCell = self.game.grid[i][j];
            MinesweeperButtonCell *viewCell = [self.matrix cellAtRow:modelCell.row column:modelCell.column];
            
            if (!modelCell.isClicked) {
                if (modelCell.isMine && modelCell.state != MinesweeperCellStateFlag) {
                    viewCell.title = @"💥";
                    viewCell.image = nil;
                }
            }
        }
    }

    [self.matrix setEnabled:NO];
}

- (void)gameEnded
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    alert.messageText = @"Congratulations!";
    alert.informativeText = @"You have succesfully completed the game";
    [alert runModal];
    [self.matrix setEnabled:NO];
}

- (IBAction)reset:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.game removeObserver:self forKeyPath:@"remainingFlags"];
    [self.game removeObserver:self forKeyPath:@"gameEnded"];
    self.flagLabel.stringValue = @"";
    self.game = nil;
    [self.matrix reset];
    [self.matrix setNeedsDisplay];
    [self setUp];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.game && [keyPath  isEqual: @"remainingFlags"])
    {
        self.flagLabel.objectValue = change[NSKeyValueChangeNewKey];
    }
    else if (object == self.game && [keyPath  isEqual: @"gameEnded"])
    {
        if ([change[NSKeyValueChangeNewKey] boolValue])
        {
            [self gameEnded];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
