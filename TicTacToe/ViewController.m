//
//  ViewController.m
//  TicTacToe
//
//  Created by ETC ComputerLand on 7/24/14.
//  Copyright (c) 2014 cmeats. All rights reserved.
//

#import "ViewController.h"
#import "CustomUILabel.h"

@interface ViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet CustomUILabel *myLabelOne;
@property (strong, nonatomic) IBOutlet CustomUILabel *myLabelTwo;
@property (strong, nonatomic) IBOutlet CustomUILabel *myLabelThree;
@property (strong, nonatomic) IBOutlet CustomUILabel *myLabelFour;
@property (strong, nonatomic) IBOutlet CustomUILabel *myLabelFive;
@property (strong, nonatomic) IBOutlet CustomUILabel *myLabelSix;
@property (strong, nonatomic) IBOutlet CustomUILabel *myLabelSeven;
@property (strong, nonatomic) IBOutlet CustomUILabel *myLabelEight;
@property (strong, nonatomic) IBOutlet CustomUILabel *myLabelNine;
@property (strong, nonatomic) IBOutlet UILabel *whichPlayerLabel;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;


@end

@implementation ViewController

int xTaken[10];
bool xPairs[16];
int yTaken[10];
bool yPairs[16];

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.player = @"X";
    self.whichPlayerLabel.text = self.player;

    self.labels = [NSMutableArray arrayWithObjects:
                              self.myLabelOne,
                              self.myLabelTwo,
                              self.myLabelThree,
                              self.myLabelFour,
                              self.myLabelFive,
                              self.myLabelSix,
                              self.myLabelSeven,
                              self.myLabelEight,
                              self.myLabelNine, nil];
    [self resetTimer];
    self.playerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    self.playComputer = NO;

    /*
     * Setup Grid Postion and Values
     * Grid Position:
     * 1 2 3
     * 4 5 6
     * 7 8 9
     *
     * Grid Values:
     * 8 1 6
     * 3 5 7
     * 4 9 2
     *
     * Grid Values are used to calculate perfect Square. 3 values will == 15 if and only if there is a winner.
     */
    self.myLabelOne.gridPosition = 1;
    self.myLabelOne.gridValue = 8;
    self.myLabelTwo.gridPosition = 2;
    self.myLabelTwo.gridValue = 1;
    self.myLabelThree.gridPosition = 3;
    self.myLabelThree.gridValue = 6;
    self.myLabelFour.gridPosition = 4;
    self.myLabelFour.gridValue = 3;
    self.myLabelFive.gridPosition = 5;
    self.myLabelFive.gridValue = 5;
    self.myLabelSix.gridPosition = 6;
    self.myLabelSix.gridValue = 7;
    self.myLabelSeven.gridPosition = 7;
    self.myLabelSeven.gridValue = 4;
    self.myLabelEight.gridPosition = 8;
    self.myLabelEight.gridValue = 9;
    self.myLabelNine.gridPosition = 9;
    self.myLabelNine.gridValue = 2;
}

-(CustomUILabel *)findLabelUsingPoint: (CGPoint)point
{
    // Pass in point
    // Check if point intersects with any labels
    for (CustomUILabel *label in self.labels) {
        if (CGRectContainsPoint(label.frame, point)) {
            return label;
        }
    }
    return nil;
}

-(void)doMove: (CustomUILabel *)selectedLabel
{
    NSString *playerMoving = @"";
    // Ensure only empty labels can be changed
    if ([selectedLabel.text isEqualToString:@""]) {
        if ([self.player isEqualToString:@"X"]) {
            playerMoving = @"X";
            selectedLabel.backgroundColor = [UIColor blueColor];
            // set label to player
            selectedLabel.text = self.player;
            // update xTaken
            xTaken[selectedLabel.gridPosition] = selectedLabel.gridValue;
            // switch to next player
            [self switchPlayer];
        } else {
            playerMoving = @"O";
            selectedLabel.backgroundColor = [UIColor redColor];
            // Do reverse of above
            selectedLabel.text = self.player;
            // Update yTaken
            yTaken[selectedLabel.gridPosition] = selectedLabel.gridValue;
            [self switchPlayer];
        }
        // find winner
        NSString *winner = [self whoWon:playerMoving withSelectedLabe:selectedLabel];
        if (winner) {
            UIAlertView *alertView = [[UIAlertView alloc] init];
            alertView.title = @"Winner";
            alertView.message = [NSString stringWithFormat:@"%@ has won the game", winner];
            [alertView addButtonWithTitle:@"Play Again"];
            alertView.delegate = self;
            [alertView show];
        } else {
            // Check for computer move
            if (self.playComputer && [self.computerPlayer isEqualToString:self.player]) {
                [self doComputerMove];
            }
        }


    }
}
-(void)switchPlayer
{
    if ([self.player isEqualToString:@"X"]) {
        // set player to O
        self.player = @"O";
        // update current player label
        self.whichPlayerLabel.text = self.player;
        [self resetTimer];
    } else {
        self.player = @"X";
        self.whichPlayerLabel.text = self.player;
        [self resetTimer];
    }
}

-(IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGesture
{

    CGPoint tappedPoint = [tapGesture locationInView:self.view];

    CustomUILabel *selectedLabel = [self findLabelUsingPoint:tappedPoint];

    if (selectedLabel) {
        [self doMove:selectedLabel];
    }
}
-(IBAction)onLabelDrag:(UIPanGestureRecognizer *)panGesture
{
    // Get Delta of dragged point
    CGPoint point = [panGesture translationInView:self.view];
    //Drag X from bottom of screen
    self.whichPlayerLabel.transform = CGAffineTransformMakeTranslation(point.x, point.y);

    point.x += self.whichPlayerLabel.center.x;
    point.y += self.whichPlayerLabel.center.y;

    CustomUILabel *selectedLabel = [self findLabelUsingPoint:point];

    if (selectedLabel) {
        [self doMove:selectedLabel];

        self.whichPlayerLabel.transform = CGAffineTransformMakeTranslation(0, 0);
    }
}
- (IBAction)onButtonClickPlayComputer:(id)sender {
    self.playComputer = YES;
    self.computerPlayer = self.player;
    [self doComputerMove];
}

-(void)doComputerMove
{
    for (CustomUILabel *label in self.labels) {
        if ([label.text isEqualToString:@""]) {
            [self doMove:label];
            break;
        }
    }
}
-(NSString *)whoWon:(NSString *) player withSelectedLabe:(CustomUILabel *)selectedLabel
{

    if ([player isEqualToString:@"X"]) {
        // use x arrays
        if (xPairs[15]) {
            return @"X";
        } else {
            for (int k = 1; k <= 10; k++) {
                if (xTaken[k] && k != selectedLabel.gridPosition) {
                    xPairs[selectedLabel.gridValue + xTaken[k]] = YES;
                }
            }
        }
    } else {
        // use y arrays
        if (yPairs[15]) {
            return @"O";
        } else {
            for (int k = 1; k <= 10; k++) {
                if (yTaken[k] && k!= selectedLabel.gridPosition) {
                    yPairs[selectedLabel.gridValue + yTaken[k]] = YES;
                }
            }
        }
    }

    return nil;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // Start Over
        for (CustomUILabel *label in self.labels) {
            label.text = @"";
            label.backgroundColor = [UIColor lightGrayColor];
            self.player = @"X";
            self.whichPlayerLabel.text = self.player;
            self.playComputer = NO;
            [self resetPrimitives];
            [self resetTimer];
        }
    }
}

-(void)resetPrimitives
{

    for (int i = 0; i <= 10; i++) {
        xTaken[i] = 0;
        yTaken[i] = 0;
    }
    for (int i = 0; i <= 16; i++) {
        xPairs[i] = NO;
        yPairs[i] = NO;
    }
}

-(void)updateCounter: (NSTimer *) timer
{
    if (self.secondsLeft > 0) {
        self.secondsLeft --;
    } else {
        // switch player
        [self switchPlayer];
        // reset counter
        [self resetTimer];
    }
    self.timerLabel.text = [NSString stringWithFormat:@"%d", self.secondsLeft];
}

-(void)resetTimer
{
    self.secondsLeft = 999999999;
    self.timerLabel.text = [NSString stringWithFormat:@"%d", self.secondsLeft];
}

@end
