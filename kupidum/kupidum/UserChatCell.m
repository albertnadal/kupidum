//
//  UserChatCell.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "UserChatCell.h"

@implementation UserChatCell

@synthesize ucvc;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier username:(NSString *)username lastMessage:(NSString *)lastMessage lastDateMessage:(NSString *)lastDate
{
    if(self = [[UserChatCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        [[ucvc username] setText:username];
        [[ucvc lastMessage] setText:lastMessage];
        [[ucvc dateUpdate] setText:lastDate];
    }

    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];

        ucvc = [[UserChatViewController alloc] initWithNibName:@"UserChatViewController" bundle:nil];
        [self.contentView addSubview:ucvc.view];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
