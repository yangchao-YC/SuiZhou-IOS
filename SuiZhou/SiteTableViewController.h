//
//  SiteTableViewController.h
//  神韵随州
//
//  Created by 杨超 on 13-10-15.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface SiteTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property (retain, nonatomic) IBOutlet UILabel *navLabel;

@end
