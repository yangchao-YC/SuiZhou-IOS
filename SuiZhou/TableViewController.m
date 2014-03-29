//
//  TableViewController.m
//  神韵随州
//
//  Created by 杨超 on 13-10-18.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import "TableViewController.h"
#import "ListViewCell.h"
#import "ScrollImageCell.h"
#import "UIImageView+My.h"
#import "UIViewController+HUD.h"
#import "WebScrollViewController.h"
#import "WebViewController.h"
#import "base64.h"
#import "FMDatabase.h"

#import "ArticleVO.h"
#import "UIImageView+WebCache.h"
#define DB_NAME @"suizhouData.db"
#define TABLE_NAME @"suizhou"
#define DB_PATH [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

@interface TableViewController ()<ScrollImageCellTapDelegate>
{
    NSString *styleNSString;
    
    BOOL _hasFocusImage;
    BOOL _hasImage;
    BOOL _focusImageCount;
}
@property (nonatomic,retain) NSMutableArray *articles ;
@property(nonatomic,strong)MyASIHTTPRequest *request;
@end

@implementation TableViewController

@synthesize articles = _articles;
@synthesize dataURLString = _dataURLString;
@synthesize infoID = _infoID;
@synthesize request = _request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil infoID:(NSString *)infoID_
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.infoID = infoID_;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor whiteColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.navLabel.text = self.navText;
    
    // NSLog(@"%@---我是web判断",self.webJudge);//此变量控制是否跳转至网页显示页面WebViewController
    
    //设置导航条图片
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"headers_bg.png"] forBarMetrics:UIBarMetricsDefault];
    [self.pullTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //self.TableView.bounces = NO;
    self.pullTableView.frame = CGRectMake(0, 46, 320, 414 + DISTANCE);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        if (IS_IPHONE_5) {
            self.navBar.frame = CGRectMake(0, 20, 320, 44);
            self.navLabel.frame = CGRectMake(53, 31, 204, 21);
            self.pullTableView.frame = CGRectMake(0, 66, 320, 328 + DISTANCE);
            self.backButton.frame=CGRectMake(5, 27, 40, 30);
        }
        else
        {
            self.pullTableView.frame = CGRectMake(0, 44, 320, 436);
        }
        
    }
    
    
    [self showHUDInfo:@"数据加载中..."];//数据加载提示框
    
    //先加载数据库的数据
    [self initDataFromDB];
    
    
    //开始加载数据
    NSURL *dateURL = [[[NSURL alloc]initWithString:self.dataURLString]autorelease];
    self.request = [MyASIHTTPRequest requestWithURL:dateURL];
    self.request.key = 1;
    [self.request setDelegate:self];
    [self.request startAsynchronous];

}

- (void)initDataFromDB
{
    self.articles = [NSMutableArray array];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[DB_PATH stringByAppendingPathComponent:DB_NAME]];
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where infoid = '%@'",TABLE_NAME,self.infoID];
    
    if ([db open]) {
        FMResultSet *result = [db executeQuery:sqlString];
        while ([result next])
        {
            ArticleVO *vo = [[ArticleVO alloc] init];
            vo.articleID = [result intForColumn:@"id"];
            vo.infoID = [result stringForColumn:@"infoid"];
            vo.title = [result stringForColumn:@"title"];//信息标题
            vo.note = [result stringForColumn:@"note"];//判断是否为滑动
            vo.introtext = [result stringForColumn:@"introtext"];//判断是否为滑动
            vo.modified_time = [result stringForColumn:@"modified_time"];//时间
            vo.cnparams = [result stringForColumn:@"cnparams"];//图片地址
            vo.description = [result stringForColumn:@"description"];//内容简介
            vo.zcategory = [result stringForColumn:@"zcategoryStrings"];//判断列表等级
            vo.zcategoryurl = [result stringForColumn:@"zcategoryurl"];//下级列表数据地址
            vo.haveimg = [result stringForColumn:@"haveimg"];
            [self.articles addObject:vo];
        }
        
    }

    [self refreshTable];//刷新列表

}

//CREATE TABLE suizhou (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, infoid TEXT , description TEXT, note TEXT, cnparams TEXT, modified_time TEXT, introtext TEXT, zcategoryurl TEXT, azhuadong TEXT, zcategoryStrings TEXT);
- (void)saveData:(NSArray *)dataArray
{
    FMDatabase *db = [FMDatabase databaseWithPath:[DB_PATH stringByAppendingPathComponent:DB_NAME]];
    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM suizhou WHERE infoid = '%@'",self.infoID];
    if ([db open]) {
        [db executeUpdate:sqlString];
    }
    
    if ([db open]) {
        
        [db beginTransaction];
        for (NSDictionary *article in dataArray) {
            NSMutableString *sql = [NSMutableString string];
            [sql appendString:@"INSERT INTO suizhou(title,infoid,mark,description,note,cnparams,modified_time,introtext,zcategoryurl,azhuadong,zcategoryStrings,haveimg) VALUES ("];
            [sql appendString:[NSString stringWithFormat:@"'%@',",[article objectForKey:@"title"]]];  //title
            [sql appendString:[NSString stringWithFormat:@"'%@',",self.infoID]];  //infoid
            [sql appendString:[NSString stringWithFormat:@"'%@',",[article objectForKey:@"id"]]];  //description
            [sql appendString:[NSString stringWithFormat:@"'%@',",[article objectForKey:@"description"]]];  //description
            [sql appendString:[NSString stringWithFormat:@"'%@',",[article objectForKey:@"note"]]];  //note
            [sql appendString:[NSString stringWithFormat:@"'%@',",[article objectForKey:@"cnparams"]]];  //cnparams
            [sql appendString:[NSString stringWithFormat:@"'%@',",[article objectForKey:@"modified_time"]]];  //modified_time
            [sql appendString:[NSString stringWithFormat:@"'%@',",[article objectForKey:@"introtext"]]];  //introtext
            [sql appendString:[NSString stringWithFormat:@"'%@',",[article objectForKey:@"zcategoryurl"]]];  //zcategoryurl
            [sql appendString:[NSString stringWithFormat:@"'%@',",[article objectForKey:@"azhuadong"]]];  //azhuadong
            [sql appendString:[NSString stringWithFormat:@"'%@',",[article objectForKey:@"zcategory"]]];  //zcategoryStrings
            [sql appendString:[NSString stringWithFormat:@"'%@'",[article objectForKey:@"haveimg"]]];
            [sql appendString:@");"];
            
            [db executeUpdate:sql];
        }

        [db commit];
    }

}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self removeHUDInfo];
    MyASIHTTPRequest *MYASI = (MyASIHTTPRequest *)request;
    
    if (MYASI.key == 1) {
        
        NSError *error;
        id rs = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        
        
        
        [self saveData:rs];
        [self initDataFromDB];
    }
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    [self removeHUDInfo];
    
    NSLog(@"出错");
}


- (UITableViewCell *)tableView:(PullTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier_1 = @"Cell1";
    
    if (_hasFocusImage) {//判断列表是否要显示滑动图片
        if (!indexPath.section) {
            //滑动图片设置
            ScrollImageCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier_1];//设置为第一个标签模块，此模块为自定义的MyTableViewCell样式，
            
            if (!cell) {
                cell = [[[ScrollImageCell alloc]initWithStyle:/* 设置样式*/UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_1]autorelease];
                //实例这个样式
            }
            cell.tapDelegate = self;
            //设置焦点图的计数
            _focusImageCount = self.articles.count > 4 ? 4:self.articles.count;
            NSArray *data = [self.articles subarrayWithRange:NSMakeRange(0, _focusImageCount)];
            [cell initData:data];
            return cell;
            
        }
        else
        {//非滑动图片列表设置
            ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ListViewCell" owner:self options:nil] lastObject];//自定义时必须的一句(需有XIB)
            }
            //获得此行该显示的数据
            ArticleVO *article = [self.articles objectAtIndex:indexPath.row + _focusImageCount];
            
            BOOL hasSubCategory = [article.zcategory boolValue];
            
            cell.TitleLabel.text = article.title;
            if ([self.webJudge isEqualToString:@"yes"] ||hasSubCategory)
            {
                cell.TimeLabel.text = article.description;
            }
            else
            {
                cell.CountLabel.text = article.description;
            }
            [cell.image setImageWithURL:[NSURL URLWithString:article.cnparams] placeholderImage:[UIImage imageNamed:@"icon.png"]];
            return cell;
        }
    }
    else
    {//无滑动图片列表的数据显示
        ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ListViewCell" owner:self options:nil] lastObject];//自定义时必须的一句(需有XIB)
        }
        
        ArticleVO *article = [self.articles objectAtIndex:indexPath.row];
        BOOL hasSubCategory = [article.zcategory boolValue];
        
        cell.TitleLabel.text = article.title;
        if ([self.webJudge isEqualToString:@"yes"] || hasSubCategory)
        {
            cell.TimeLabel.text = article.description;
        }
        else
        {
            cell.CountLabel.text = article.description;
        }
        [cell.image setImageWithURL:[NSURL URLWithString:article.cnparams] placeholderImage:[UIImage imageNamed:@"icon.png"]];
        return cell;
    }
}
//点击时间设置

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.webJudge isEqualToString:@"yes"]) {//判断是否直接跳转至网页显示，如果是使用base64解码后传递网页地址
        NSLog(@"%@---------",self.webJudge);
        
        ArticleVO *article = [self.articles objectAtIndex:indexPath.row];
        
       //  [self Articlecount:article.mark];
        
        WebViewController *webPush = [[WebViewController alloc]init];
        webPush.navText = article.title;
        NSString *base = [base64 decodeBase64String:article.introtext];
        webPush.webPushString = base;
        
        [self.navigationController pushViewController:webPush animated:YES];
        [webPush release];
    }
    else
    {
    if (_hasFocusImage) {
        if (!indexPath.section) {
            //焦点图的点击
        }
        else
        {//判断后进行跳转，此时继续push到本页面，重新加载数据
            ArticleVO *article = [self.articles objectAtIndex:indexPath.row + _focusImageCount];
            BOOL hasSubCategory = [article.zcategory boolValue];
            if (hasSubCategory) {
                
             //   [self count: article.mark];
                
                NSString *urlString = article.zcategoryurl;
                NSString *infoID = [NSString stringWithFormat:@"%@-%@",self.infoID,article.title];
                TableViewController *controller = [[[TableViewController alloc] initWithNibName:@"TableViewController" bundle:nil infoID:infoID] autorelease];
                controller.dataURLString = urlString;
                controller.navText = article.title;
                NSLog(@"%@----------",controller.navText);
                [self.navigationController pushViewController:controller animated:YES];
            }
           else
           {//判断后跳转，此时判断为最后一页，跳转至网页详情页面
               ///
               [self Articlecount:article.mark];
               
               WebScrollViewController *controller = [[[WebScrollViewController alloc] initWithNibName:@"WebScrollViewController" bundle:nil] autorelease];
               [controller initDataAndIndex:self.articles selectIndex:indexPath.row + _focusImageCount];
               [self.navigationController pushViewController:controller animated:YES];
           }
            
        }
    }
    else
    {//判断后进行跳转，此时继续push到本页面，重新加载数据
        ArticleVO *article = [self.articles objectAtIndex:indexPath.row];
        BOOL hasSubCategory = [article.zcategory boolValue];
        if (hasSubCategory) {
            
          //  [self count:article.mark];
            
            NSString *urlString = article.zcategoryurl;
            NSString *infoID = [NSString stringWithFormat:@"%@-%@",self.infoID,article.title];
            TableViewController *controller = [[[TableViewController alloc] initWithNibName:@"TableViewController" bundle:nil infoID:infoID] autorelease];
            controller.dataURLString = urlString;
            controller.navText = article.title;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else
        {
            //判断后跳转，此时判断为最后一页，跳转至网页详情页面
            ///
            [self Articlecount:article.mark];
            
            WebScrollViewController *controller = [[[WebScrollViewController alloc] initWithNibName:@"WebScrollViewController" bundle:nil] autorelease];
            [controller initDataAndIndex:self.articles selectIndex:indexPath.row];
            [self.navigationController pushViewController:controller animated:YES];
        }

    }
        
    }
}
//滑动列表点击事件，根据参数判断点击的哪项，然后进行判断是否有下级列表，如果没有则直接跳转至网页详情页面
- (void)focusTaped:(int)articleIndex_
{
    ArticleVO *article_ = [self.articles objectAtIndex:articleIndex_];
    BOOL hasSubCategory = [article_.zcategory boolValue];
    if (hasSubCategory) {
        
     //   [self count:article_.mark];
        
        NSString *urlString = article_.zcategoryurl;
        NSLog(@"%@",urlString);
        NSString *infoID = [NSString stringWithFormat:@"%@-%@",self.infoID,article_.title];
        TableViewController *controller = [[[TableViewController alloc] initWithNibName:@"TableViewController" bundle:nil infoID:infoID] autorelease];
        controller.dataURLString = urlString;
        controller.navText = article_.title;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
         [self Articlecount:article_.mark];
        
        ///
        WebScrollViewController *controller = [[[WebScrollViewController alloc] initWithNibName:@"WebScrollViewController" bundle:nil] autorelease];
        [controller initDataAndIndex:self.articles selectIndex:articleIndex_];
        [self.navigationController pushViewController:controller animated:YES];
    }

}
//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_hasFocusImage) {
        if (!section) {
            return 1;
        }
        else
        {
            int counts = count - 4;
            return counts < 0 ? 0:counts;
        }
    }
    else
    {
       return count;
    }
        //return self.articles.count;
    
}
//设置模块
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_hasFocusImage) {
        return 2;
    }
    else
    {
        return 1;
    }
}
//设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_hasFocusImage) {
        if (!indexPath.section) {
            return 172.0f;
        }
    }
    
    return 80.0f;
}

- (void)refreshTable
{
    /*
     Code to actually refresh goes here.  刷新代码放在这
     */
    
    [self removeHUDInfo];
    if (self.articles.count != 0) {
        ArticleVO *firstArticle = [self.articles objectAtIndex:0];
        _hasFocusImage = [firstArticle.note boolValue];
        if (!_hasFocusImage) {
            _hasImage = [firstArticle.haveimg boolValue];
        }
        
        if (self.articles.count > 10) {
            count = 10;
        }
        else
        {
            count = self.articles.count;
        }
        [self.pullTableView reloadData];
        self.pullTableView.pullLastRefreshDate = [NSDate date];
        self.pullTableView.pullTableIsRefreshing = NO;
    }
    else
    {
        //[self Alert];
    }
    
}
//如果没有数据弹出提示，确定后返回上级
-(void)Alert
{
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"您好，暂时无数据"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"关闭",nil] autorelease];
    [alert show];
    
}




//分类统计
/*
-(void)count:(NSString *)key
{
    NSString *URL = [NSString stringWithFormat:@"http://119.36.193.148/suizhou/api/categoryc/%@",key];
    
    NSURL *dateURL = [[[NSURL alloc]initWithString:URL]autorelease];
    self.request = [MyASIHTTPRequest requestWithURL:dateURL];
    self.request.key = 2;
    [self.request setDelegate:self];
    [self.request startAsynchronous];
}
*/
//文章统计
-(void)Articlecount:(NSString *)key
{
    NSString *URL = [NSString stringWithFormat:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&aid=%@&statez=3",key];
    
    NSURL *dateURL = [[[NSURL alloc]initWithString:URL]autorelease];
    self.request = [MyASIHTTPRequest requestWithURL:dateURL];
    self.request.key = 2;
    [self.request setDelegate:self];
    [self.request startAsynchronous];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self backPush];
}
- (void)loadMoreDataToTable
{
    /*
     Code to actually load more data goes here.  加载更多实现代码放在在这
     */
    if (self.articles.count > 10) {
        if ((self.articles.count - count)>=10) {
            count +=10;
        }
        else
        {
            count = self.articles.count;
        }
    }
    else
    {
        count = self.articles.count;
    }
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

-(IBAction)btn:(UIButton *)sender
{
    [self backPush];
}

-(void)backPush
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.request.delegate = nil;
    self.request = nil;
    
    [_pullTableView release];
    [_navBar release];
    [_navLabel release];
    [_backButton release];
    [super dealloc];
}
@end


