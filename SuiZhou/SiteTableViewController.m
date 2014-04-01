//
//  SiteTableViewController.m
//  神韵随州
//
//  Created by 杨超 on 13-10-15.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import "SiteTableViewController.h"
#import "ListViewCell.h"
#import "SiteIntroductionViewController.h"
@interface SiteTableViewController ()
@property (nonatomic,retain) NSArray *articles ;
@end

@implementation SiteTableViewController

@synthesize articles = _articles;


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
    // Do any additional setup after loading the view from its nib.
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"headers_bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, 44, 320, 416 + DISTANCE);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navBar.frame = CGRectMake(0, 20, 320, 44);
        
        self.navLabel.frame = CGRectMake(53, 31, 204, 21);
        self.backButton.frame=CGRectMake(5, 27, 40, 30);
        self.tableView.frame = CGRectMake(0, 64, 320, 416 + DISTANCE);
    }
    //与后台约定的检测更新地址
    NSString *url = @"http://119.36.193.147/index.php?option=com_content&view=category&layout=blog&id=155&statez=1";
    NSURL *dateURL = [[[NSURL alloc]initWithString:url]autorelease];
    //使用第三方包获取网络数据
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:dateURL];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSError *error;
    id rs = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
    
    // NSLog(@"%@--------------",rs);
    self.articles = rs;//将获得的数据存入自定义变量中
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"出错");
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    if (indexPath.section == 0 ) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        cell.textLabel.text = @"关于神韵随州";
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    cell.textLabel.text = @"检查更新";
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;//设置显示行数
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;//设置为只有一个分区
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section ==0) {
        SiteIntroductionViewController *sitePush = [[SiteIntroductionViewController alloc]init];
        [self.navigationController pushViewController:sitePush animated:YES];
        [sitePush release];
    }
    else
    {
        [self vercode];
      
    }
}


-(void)vercode
{
    NSString *version = [[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]autorelease];
    NSDictionary *article = [self.articles objectAtIndex:1];
    NSString *vercode = [article objectForKey:@"note"];
    NSString *updateURL = [article objectForKey:@"description"];
    //获得版本号后进行判断，如果是最新则提示用户此版本为最新，不是则调用系统进行更新处理
    if ([vercode isEqualToString:version]) {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                      message:@"当前版本是最新"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        //执行软件更新
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:updateURL]];
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}//设置模块内cell的高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    titleLabel.backgroundColor = [UIColor clearColor];
    switch (section) {
        case 0:
            titleLabel.text = @"   关于";
            break;
        case 1:
            titleLabel.text = @"   更新";
            break;
//        case 2:
//            titleLabel.text = @"更新设置";
//            break;
        default:
            break;
    }

    return titleLabel;

}

-(IBAction)btn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_navBar release];
    [_tableView release];
    [_backButton release];
    [_navLabel release];
    [super dealloc];
}
@end
