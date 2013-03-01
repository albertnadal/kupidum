//
//  MessageDetailViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 27/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPDMessage.h"

@interface MessageDetailViewController : UIViewController
{
    IBOutlet UIImageView *fromAvatar;
    IBOutlet UIImageView *toAvatar;
    IBOutlet UILabel *fromLabel;
    IBOutlet UILabel *toLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *subjectLabel;
    IBOutlet UILabel *messageLabel;
    IBOutlet UIScrollView *scroll;
    IBOutlet UIButton *sendMessageButton;

    KPDMessage *msg;
}

@property (nonatomic, retain) KPDMessage *msg;
@property (nonatomic, retain) UIImageView *fromAvatar;
@property (nonatomic, retain) UIImageView *toAvatar;
@property (nonatomic, retain) UILabel *fromLabel;
@property (nonatomic, retain) UILabel *toLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *subjectLabel;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UIScrollView *scroll;
@property (nonatomic, retain) UIButton *sendMessageButton;

- (id)initWithNibName:(NSString *)nibNameOrNil withMsg:(KPDMessage *)_msg;
- (IBAction)replyMessage:(id)sender;

@end
