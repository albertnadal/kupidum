//
//  KMUIUtilities.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 12/02/12.
//  Copyright (c) 2012 Albert Nadal Garriga. All rights reserved.
//

#import "KPDUIUtilities.h"

@implementation KPDUIUtilities

+ (UIButton*)customBackBarButtonWithImage:(NSString*)imageName 
                                 andTitle:(NSString*)title 
                              andSelector:(SEL)selector 
                                andTarget:(id)target
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BACK_BUTTON_WIDTH, BACK_BUTTON_HEIGHT)];
    [backButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    return backButton;
}

+ (UIButton*)customRectangledBarButtonWithImage:(NSString*)imageName 
                                 andInsideImage:(NSString*)insideImageName 
                                    andSelector:(SEL)selector 
                                      andTarget:(id)target
{
    NSInteger height = RECTANGLE_BUTTON_HEIGHT_PORTRAIT;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, RECTANGLE_BUTTON_WIDTH, height)];
    [button setContentMode:UIViewContentModeScaleAspectFill];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:insideImageName]];
    [imageView setFrame:button.frame];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [button addSubview:imageView];
    return button;
}

+ (UIButton*)customCircleBarButtonWithImage:(NSString*)imageName
                                 andInsideImage:(NSString*)insideImageName
                                    andSelector:(SEL)selector
                                      andTarget:(id)target
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CIRCLE_BUTTON_WIDTH, CIRCLE_BUTTON_HEIGHT)];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:insideImageName]];
    [imageView setFrame:button.frame];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [button addSubview:imageView];
    return button;
}

@end
