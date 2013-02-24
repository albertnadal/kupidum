//
//  UserChatViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserChatViewController : UIViewController
{
    IBOutlet UIImageView *image;
    IBOutlet UILabel *username;
    IBOutlet UILabel *lastMessage;
    IBOutlet UILabel *dateUpdate;
}

@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, retain) UILabel *username;
@property (nonatomic, retain) UILabel *lastMessage;
@property (nonatomic, retain) UILabel *dateUpdate;

@end
