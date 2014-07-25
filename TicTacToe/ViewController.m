//
//  ViewController.m
//  TicTacToe
//
//  Created by ETC ComputerLand on 7/24/14.
//  Copyright (c) 2014 cmeats. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *myLabelOne;
@property (strong, nonatomic) IBOutlet UILabel *myLabelTwo;
@property (strong, nonatomic) IBOutlet UILabel *myLabelThree;
@property (strong, nonatomic) IBOutlet UILabel *myLabelFour;
@property (strong, nonatomic) IBOutlet UILabel *myLabelFive;
@property (strong, nonatomic) IBOutlet UILabel *myLabelSix;
@property (strong, nonatomic) IBOutlet UILabel *myLabelSeven;
@property (strong, nonatomic) IBOutlet UILabel *myLabelEight;
@property (strong, nonatomic) IBOutlet UILabel *myLabelNine;
@property (strong, nonatomic) IBOutlet UILabel *whichPlayerLabel;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;


@end

@implementation ViewController



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
}

-(UILabel *)findLabelUsingPoint: (CGPoint)point
{
    // Pass in point
    // Check if point intersects with any labels
    for (UILabel *label in self.labels) {
        if (CGRectContainsPoint(label.frame, point)) {
            return label;
        }
    }
    return nil;
}

-(void)doMove: (UILabel *)selectedLabel
{
    // Ensure only empty labels can be changed
    if ([selectedLabel.text isEqualToString:@""]) {
        if ([self.player isEqualToString:@"X"]) {
            selectedLabel.backgroundColor = [UIColor blueColor];
            // set label to player
            selectedLabel.text = self.player;
            // switch to next player
            [self switchPlayer];
        } else {
            selectedLabel.backgroundColor = [UIColor redColor];
            // Do reverse of above
            selectedLabel.text = self.player;
            [self switchPlayer];
        }
        // find winner
        NSString *winner = [self whoWon];
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

    UILabel *selectedLabel = [self findLabelUsingPoint:tappedPoint];

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

    UILabel *selectedLabel = [self findLabelUsingPoint:point];

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
    for (UILabel *label in self.labels) {
        if ([label.text isEqualToString:@""]) {
            [self doMove:label];
            break;
        }
    }
}
-(NSString *)whoWon
{

    // Check for winner in the leftmost column and top row
    // 1==2 && 1==3 || 1==4 && 1 == 7
    if (![self.myLabelOne.text isEqualToString:@""]) {
        if ((([self.myLabelOne.text isEqualToString:self.myLabelTwo.text]) && ([self.myLabelOne.text isEqualToString:self.myLabelThree.text])) ||
            (([self.myLabelOne.text isEqualToString:self.myLabelFour.text]) && ([self.myLabelOne.text isEqualToString:self.myLabelSeven.text]))
            ) {
            return self.myLabelOne.text;

        }
    }

    // Check for winner through middle
    // 5==4 && 5==6
    // 5==2 && 5==8
    // 5==1 && 5==9
    // 5==3 && 5==7
    if (![self.myLabelFive.text isEqualToString:@""]) {
        if ((([self.myLabelFive.text isEqualToString:self.myLabelFour.text]) && ([self.myLabelFive.text isEqualToString:self.myLabelSix.text])) ||
            (([self.myLabelFive.text isEqualToString:self.myLabelTwo.text]) && ([self.myLabelFive.text isEqualToString:self.myLabelEight.text])) ||
            (([self.myLabelFive.text isEqualToString:self.myLabelOne.text]) && ([self.myLabelFive.text isEqualToString:self.myLabelNine.text])) ||
            (([self.myLabelFive.text isEqualToString:self.myLabelThree.text]) && ([self.myLabelFive.text isEqualToString:self.myLabelSeven.text]))
            ) {
            return self.myLabelFive.text;
            
        }
    }

    // Check for win the right and low
    // 9==6 && 9==3
    // 9==8 && 9==7
    if (![self.myLabelNine.text isEqualToString:@""]) {
        if ((([self.myLabelNine.text isEqualToString:self.myLabelSix.text]) && ([self.myLabelNine.text isEqualToString:self.myLabelThree.text])) ||
            (([self.myLabelNine.text isEqualToString:self.myLabelEight.text]) && ([self.myLabelNine.text isEqualToString:self.myLabelSeven.text]))
            ) {
            return self.myLabelNine.text;
            
        }
    }
    return nil;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // Start Over
        for (UILabel *label in self.labels) {
            label.text = @"";
            label.backgroundColor = [UIColor lightGrayColor];
            self.player = @"X";
            self.whichPlayerLabel.text = self.player;
            self.playComputer = NO;
            [self resetTimer];
        }
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
    self.secondsLeft = 10;
    self.timerLabel.text = [NSString stringWithFormat:@"%d", self.secondsLeft];
}

@end
