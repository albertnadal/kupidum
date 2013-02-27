//
//  UserChatViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCellViewController : UIViewController
{
    IBOutlet UIImageView *image;
    IBOutlet UILabel *username;
    IBOutlet UILabel *subject;
    IBOutlet UILabel *headOfMessage;
    IBOutlet UILabel *dateUpdate;
}

@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, retain) UILabel *username;
@property (nonatomic, retain) UILabel *subject;
@property (nonatomic, retain) UILabel *headOfMessage;
@property (nonatomic, retain) UILabel *dateUpdate;

@end
