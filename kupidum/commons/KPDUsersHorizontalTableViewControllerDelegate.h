//
//  KPDUsersHorizontalTableViewControllerDelegate.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 09/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KPDUsersHorizontalTableViewController;

@protocol KPDUsersHorizontalTableViewControllerDelegate <NSObject>

- (void)usersHorizontalTableViewController:(KPDUsersHorizontalTableViewController *)tableViewController didSelectUser:(NSString *)theUser;
- (void)usersHorizontalTableViewControllerDidRefresh:(KPDUsersHorizontalTableViewController *)tableViewController;

@end
