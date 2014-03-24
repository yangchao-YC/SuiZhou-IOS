//
//  TableViewController.h
//  神韵随州
//
//  Created by 杨超 on 13-10-18.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
#import "ASIHTTPRequest.h"
#import "MyASIHTTPRequest.h"
@interface TableViewController : UIViewController<PullTableViewDelegate,UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    int count;
}
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
@property (retain, nonatomic) IBOutlet PullTableView *pullTableView;
@property (retain, nonatomic) IBOutlet UILabel *navLabel;

@property(nonatomic,strong)NSString *infoID;
@property (retain,nonatomic)NSString *dataURLString;//接收访问数据地址
@property(nonatomic,retain) NSString *navText;//接收导航条名
@property(nonatomic,retain) NSString *webJudge;//判断页面是否直接至网页页面
@property (retain, nonatomic) IBOutlet UIButton *backButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil infoID:(NSString *)infoID_;
@end
