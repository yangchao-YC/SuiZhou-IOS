//
//  ListViewController.h
//  SuiZhou
//
//  Created by 杨超 on 13-10-10.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
@interface ListViewController : UIViewController<PullTableViewDelegate,UITableViewDataSource>
{
    int count;
}
@property (retain, nonatomic) IBOutlet UINavigationBar *NavBar;
@property (retain, nonatomic) IBOutlet PullTableView *pullTableView;
@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UILabel *navLabel;

@property(nonatomic,retain) NSString *navText;

@end
