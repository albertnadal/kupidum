//
//  UserChatCell.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserChatViewController.h"

@interface UserChatCell : UITableViewCell
{
    UserChatViewController *ucvc;
}

@property (nonatomic, retain) UserChatViewController *ucvc;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier username:(NSString *)username lastMessage:(NSString *)lastMessage lastDateMessage:(NSString *)lastDate;

@end
