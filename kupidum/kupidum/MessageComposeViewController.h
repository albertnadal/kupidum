//
//  MessageComposeViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 27/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPDMessage.h"
#import "KPDUser.h"

@interface MessageComposeViewController : UIViewController
{
    IBOutlet UIImageView *fromAvatar;
    IBOutlet UILabel *fromLabel;
    IBOutlet UIScrollView *scroll;
    IBOutlet UITextField *subjectField;
    IBOutlet UITextView *messageText;

    KPDUser *fromUser;
    KPDUser *toUser;
}

@property (nonatomic, retain) KPDUser *fromUser;
@property (nonatomic, retain) KPDUser *toUser;
@property (nonatomic, retain) UIImageView *fromAvatar;
@property (nonatomic, retain) UILabel *fromLabel;
@property (nonatomic, retain) UIScrollView *scroll;
@property (nonatomic, retain) UITextField *subjectField;
@property (nonatomic, retain) UITextView *messageText;

- (id)initWithNibName:(NSString *)nibNameOrNil toUser:(KPDUser *)tuser fromUser:(KPDUser *)fuser;

@end
