//
//  SearchResultsViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 08/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *theTableView;
}

@property (strong, nonatomic) IBOutlet UITableView *theTableView;

@end
