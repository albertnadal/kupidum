//
//  KMUIUtilities.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 12/02/12.
//  Copyright (c) 2012 Albert Nadal Garriga. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BACK_BUTTON_WIDTH 50
#define BACK_BUTTON_HEIGHT 28

#define CIRCLE_BUTTON_HEIGHT 40
#define CIRCLE_BUTTON_WIDTH 56
#define RECTANGLE_BUTTON_WIDTH 40
#define RECTANGLE_BUTTON_HEIGHT_PORTRAIT 40
#define RECTANGLE_BUTTON_HEIGHT_LANDSCAPE 28

@interface KMUIUtilities : NSObject

+ (UIButton*)customBackBarButtonWithImage:(NSString*)imageName andTitle:(NSString*)title andSelector:(SEL)selector andTarget:(id)target;
+ (UIButton*)customRectangledBarButtonWithImage:(NSString*)imageName andInsideImage:(NSString*)insideImageName andSelector:(SEL)selector andTarget:(id)target;
+ (UIButton*)customCircleBarButtonWithImage:(NSString*)imageName andInsideImage:(NSString*)insideImageName andSelector:(SEL)selector andTarget:(id)target;

@end
