//
//  UsersNavigatorContainerView.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 30/03/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "UsersNavigatorContainerView.h"

@interface UsersNavigatorContainerView ()
{
    IBOutlet UIScrollView *scroll;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scroll;

@end

@implementation UsersNavigatorContainerView

@synthesize scroll;

- (UIView *) hitTest:(CGPoint) point withEvent:(UIEvent *)event
{
    if ([self pointInside:point withEvent:event])
    {
        return self.scroll;
    }
    return nil;
}

@end
