//
//  ViewController.h
//  TicTacToe
//
//  Created by ETC ComputerLand on 7/24/14.
//  Copyright (c) 2014 cmeats. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) NSString *player;
@property (strong, nonatomic) NSString *computerPlayer;
@property (strong, nonatomic) NSMutableArray *labels;
@property (strong, nonatomic) NSTimer *playerTimer;
@property int secondsLeft;
@property BOOL playComputer;

@end
