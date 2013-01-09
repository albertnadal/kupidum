//
//  HorizontalPullToRefreshTableViewController.h
//  HorizontalPullToRefreshTable
//
//  Created by Albert Nadal Garriga on 07/01/13.
//  Copyright (c) 2013 Albert Nadal Garriga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimplePullRefreshTableViewController.h"
#import "KPDUsersHorizontalTableViewControllerDelegate.h"

@interface KPDUsersHorizontalTableViewController : SimplePullRefreshTableViewController
{
    id<KPDUsersHorizontalTableViewControllerDelegate> delegate;
}

@property (nonatomic, retain) id<KPDUsersHorizontalTableViewControllerDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)scrollContentToLeft;

@end
