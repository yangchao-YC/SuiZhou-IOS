//
//  ListViewController.m
//  SuiZhou
//
//  Created by 杨超 on 13-10-10.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import "ListViewController.h"
#import "ListViewCell.h"
#import "HomeViewController.h"
#import "SiteIntroductionViewController.h"
#import "SiteTableViewController.h"
#import "TableViewController.h"
@interface ListViewController ()

@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    count = 1;
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor whiteColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.navLabel.text = self.navText;
    
    [self.NavBar setBackgroundImage:[UIImage imageNamed:@"headers_bg.png"] forBarMetrics:UIBarMetricsDefault];
    [self.pullTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //self.TableView.bounces = NO;
    
    self.view.frame = CGRectMake(0, 44, 320, 416 + DISTANCE);
    self.pullTableView.frame = CGRectMake(0, 2, 320, 414 + DISTANCE);
    

    
    // Do any additional setup after loading the view from its nib.
}



- (UITableViewCell *)tableView:(PullTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListViewCell" owner:self options:nil] lastObject];//自定义时必须的一句(需有XIB)
    }
      return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10 * count;//设置显示行数
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;//设置为只有一个模块
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}//设置模块内cell的高度


- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.  刷新代码放在这
     
     */
    count = 1;
    [self.pullTableView reloadData];
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = NO;
    
}

- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.  加载更多实现代码放在在这
     
     */
    count ++;
    [self.pullTableView reloadData];
    self.pullTableView.pullTableIsLoadingMore = NO;
    
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"选中了" message:[NSString stringWithFormat:@"您选中了第%d行",indexPath.row] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
//    [alert show];
    TableViewController *tablePush = [[TableViewController alloc]init];
    [self.navigationController pushViewController:tablePush animated:YES];
    [tablePush release];
}




-(IBAction)btn:(UIButton *)sender
{
    if (sender.tag == 1) {
        SiteTableViewController * sitePush = [[SiteTableViewController alloc]init];
        [self.navigationController pushViewController:sitePush animated:YES];
        [sitePush release];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    [_NavBar release];
    [_bgView release];
    [_navLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNavBar:nil];
    [self setBgView:nil];
    [super viewDidUnload];
}
@end
