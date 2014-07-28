//
//  CustomUILabel.m
//  TicTacToe
//
//  Created by ETC ComputerLand on 7/25/14.
//  Copyright (c) 2014 cmeats. All rights reserved.
//

#import "CustomUILabel.h"

@implementation CustomUILabel

@synthesize gridPosition;
@synthesize gridValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
