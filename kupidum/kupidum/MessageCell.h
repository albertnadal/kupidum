//
//  UserChatCell.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCellViewController.h"
#import "KPDMessage.h"

@interface MessageCell : UITableViewCell
{
    MessageCellViewController *ucvc;
    KPDMessage *msg;
}

@property (nonatomic, retain) MessageCellViewController *ucvc;
@property (nonatomic, retain) KPDMessage *msg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withMessage:(KPDMessage *)_msg remoteUser:(NSString *)_remote_user withDate:(NSString *)_date;

@end
