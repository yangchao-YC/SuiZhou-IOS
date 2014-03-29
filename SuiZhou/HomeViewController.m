//
//  HomeViewController.m
//  SuiZhou
//
//  Created by 杨超 on 13-10-10.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//




#import "HomeViewController.h"
#import "ListViewController.h"
#import "SiteTableViewController.h"
#import "SiteIntroductionViewController.h"
#import "DevelopViewController.h"
#import "WebViewController.h"
#import "TableViewController.h"
#import "FMDatabase.h"
#import "MBProgressHUD.h"
#import "UIViewController+HUD.h"
#define DB_NAME @"suizhouData.db"
#define TABLE_NAME @"suizhou"
#define DB_PATH [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

@interface HomeViewController ()
{
    int pageSum;
    NSString* phoneModel;
    NSString *UUIDString;
}

@property(nonatomic,retain)NSMutableArray * articles;

@end

@implementation HomeViewController
@synthesize NavBar = _NavBar;

- (void)initDB
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[DB_PATH stringByAppendingPathComponent:DB_NAME]]) {
        FMDatabase *db = [FMDatabase databaseWithPath:[DB_PATH stringByAppendingPathComponent:DB_NAME]];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"suizhou" ofType:@"sql" ];
        NSError *error;
        NSString *sqlStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        NSArray *sqls = [sqlStr componentsSeparatedByString:@"\n"];
        if ([db open])
        {
            [db beginTransaction];
            for (int i=0; i<sqls.count; i++) {
                [db executeUpdate:[sqls objectAtIndex:i]];
            }
            [db commit];
            return;
        }
    };
}

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

    if (IS_IPHONE_5) {
        self.bgView.frame = CGRectMake(0, 0, 320, 480 + 88);
        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"start5.png"]] ;
    }
    else
    {
        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"start.png"]] ;
    }
    

    
    //phoneModel = [phoneModel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    
   // NSLog(@"%@",phoneModel);
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSInteger myInt = [user integerForKey:@"myint"];
    if (myInt !=1) {//判断是否注册，注册则不进行用户统计
       
        
        phoneModel = [[UIDevice currentDevice] localizedModel];//获取国际化名称
        UUIDString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//获取设备ID
        
        UUIDString = [UUIDString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        UUIDString = [UUIDString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        phoneModel = [phoneModel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉左右空格
        phoneModel = [phoneModel stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉中间空格
        
        [user setInteger:1 forKey:@"myint"];
        [user setObject:phoneModel forKey:@"phoneModel"];
        [user setObject:UUIDString forKey:@"UUIDString"];
        
        NSString *date  = [NSString stringWithFormat:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&sbid=%@&sbxh=%@&statez=4",UUIDString,phoneModel];
        NSURL *dateURL = [[NSURL alloc]initWithString:date];
        MyASIHTTPRequest *request = [MyASIHTTPRequest requestWithURL:dateURL];
        request.key = 1;
        [request setDelegate:self];
        [request startAsynchronous];
        
    }
    
    phoneModel = [user stringForKey:@"phoneModel"];
    UUIDString = [user stringForKey:@"UUIDString"];
    
    [self initDB];

    self.navigationController.navigationBar.translucent = NO;
    //隐藏自带导航条
    [self.navigationController setNavigationBarHidden:YES];
    //设置自定义导航条
    [_NavBar setBackgroundImage:[UIImage imageNamed:@"header_bg.png"] forBarMetrics:UIBarMetricsDefault];
    //设置判断如果是iphone5的适应，使用对应的坐标大小以及图片
    //IS_IPHONE_5与DISTANCE   常量在  神韵随州-Prefix  中查看
    if (IS_IPHONE_5) {
        [self.HomeBgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg5.png"]]];
    }
    else
    {
        [self.HomeBgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg.png"]]];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        _NavBar.frame = CGRectMake(0, 20, 320, 44);
        self.HomeBgView.frame = CGRectMake(0, 64, 320, 436 + DISTANCE);
        self.ScrollView.frame = CGRectMake(0, 0, 320, 416 + DISTANCE);
        self.PageContol.frame = CGRectMake(135, 445 + DISTANCE, 50, 36);
        self.BackGroundView.frame = CGRectMake(0, 0, 320, 416 + DISTANCE);
        self.TwoView.frame = CGRectMake(320, 0, 320, 416 + DISTANCE);
        self.ThreeView.frame = CGRectMake(640, 0, 320, 416 + DISTANCE);
    }
    else {
        self.HomeBgView.frame = CGRectMake(0, 44, 320, 416 + DISTANCE);
        self.ScrollView.frame = CGRectMake(0, 0, 320, 416 + DISTANCE);
        self.PageContol.frame = CGRectMake(135, 425 + DISTANCE, 50, 36);
        self.BackGroundView.frame = CGRectMake(0, 0, 320, 416 + DISTANCE);
        self.TwoView.frame = CGRectMake(320, 0, 320, 416 + DISTANCE);
        self.ThreeView.frame = CGRectMake(640, 0, 320, 416 + DISTANCE);
    }
    
    
    // Do any additional setup after loading the view from its nib.
    
    
    NSString *date  = [NSString stringWithFormat:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=1&statez=1&userid=%@&model=%@",UUIDString,phoneModel];
    NSURL *dateURL = [[NSURL alloc]initWithString:date];
    MyASIHTTPRequest *request = [MyASIHTTPRequest requestWithURL:dateURL];
    request.key = 2;
    [request setDelegate:self];
    [request startAsynchronous];
}




-(void)requestFinished:(ASIHTTPRequest *)request
{
    MyASIHTTPRequest *myhttp = (MyASIHTTPRequest *)request;
    NSError *error;
    id rs = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
    
    switch (myhttp.key) {
        case 1:
            NSLog(@"%@",rs);
            break;
        case 2:
          //  [self removeHUDInfo];
            self.articles = rs;
            [self Calculate:self.articles.count];
            break;
        case 3:

            break;
        default:
            break;
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
   // [self removeHUDInfo];
    
    NSLog(@"出错");

}
//计算需产生的总页数
-(void)Calculate:(int)page
{
    pageSum = (page/9) + (page%9!=0 ? 1:0);
    [self newScrollView:(page%9)];
}

/*
 remain:接收余数（最后一页Button的个数）
 */
-(void)newScrollView:(int)remain
{
    //设置scrollView滑动范围
    [self.ScrollView setContentSize:CGSizeMake(320*pageSum, 416)];
    self.ScrollView.pagingEnabled = YES;
    self.ScrollView.bounces = NO;//去掉翻页中白屏
    [self.ScrollView setDelegate:self];
    self.ScrollView.showsHorizontalScrollIndicator = NO;//不实现水平滚到条
    self.PageContol.numberOfPages = pageSum;//设置PAGE个数
    self.PageContol.currentPage = 0;
    [self.PageContol addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    
    [self newView:remain];
  
}

//创建每页的view
-(void)newView:(int)remain
{
    for (int i = 0; i<pageSum; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0+(i *320), 0, 320, 504)];
        view.backgroundColor = [UIColor clearColor];
        [self.ScrollView addSubview:view];
        [self newBtnView:i View:view Remain:remain];
    }
}
//创建单个button的容器
-(void)newBtnView:(int)page View:(UIView *)view Remain:(int)remain
{
    
    int count = 9;//控制button总数
    if (page == (pageSum - 1)) {
        count = remain;
    }
    
    int wrap = 0;//控制左边距
    int line = 0;//控制换行
    for (int rise = 0; rise<count; rise++) {
        UIView *IntervalView = [[UIView alloc]initWithFrame:CGRectMake(20 + (wrap*105), 20 + (line *108) , 70, 71)];
        [view addSubview:IntervalView];
        wrap ++;
        
        if (wrap == 3) {
            wrap =0;
            line ++;
        }
        
        
        [self newBtn:(rise +(page *9)) View:IntervalView];
    }
}
//创建button
-(void)newBtn:(int)tag View:(UIView *)view
{
    NSDictionary *dic = [self.articles objectAtIndex:tag];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 70, 63);
    
   // btn.imageView.image = [UIImage imageNamed:@"home_view1_1.png"];
    [btn setImage:[UIImage imageNamed:@"home_view1_1.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    [view addSubview:btn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 67, 70, 13)];
    label.font = [UIFont fontWithName:@"ARIAL" size:11];
    label.textAlignment = NSTextAlignmentCenter;
    [label setNumberOfLines:2];
    label.textColor = [UIColor whiteColor];
    label.text = [dic objectForKey:@"title"];
    [view addSubview:label];
    
}

//scrollView回调，设置pagecontil显示
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1{
    CGPoint offset=scrollView1.contentOffset;
    CGRect bounds=scrollView1.frame;
    [self.PageContol setCurrentPage:offset.x/bounds.size.width];
}
-(IBAction)pageTurn:(UIPageControl *)sender
{
    CGSize viewsize = self.ScrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage*viewsize.width, 0, viewsize.width, viewsize.height);
    [self.ScrollView scrollRectToVisible:rect animated:YES];
}



-(IBAction)siteBtn:(id)sender
{
    [self sitePush];
}
/*
stype5中状态 
 1.list     进入列表
 2.weblist  进入列表后进入网页访问
 3.unfinished   进入正在开发中页面
 4.aboutus  进入关于本应用页面
 5.weblink  直接进入网页显示页面，此页面跳转时需提取参数  metakey  获取访问的地址
 */
-(IBAction)button:(UIButton *)sender
{
    
    NSLog(@"%d",sender.tag);
    NSDictionary *dic = [self.articles objectAtIndex:sender.tag];
    
    NSString *Stype = [dic objectForKey:@"stype"];
    NSString *Url = [dic objectForKey:@"zcategoryurl"];
    NSString *Title = [dic objectForKey:@"title"];
    
    /*
    NSString *navBarText = sender.titleLabel.text;
    NSString *webYes = @"yes";//区分是否为直接下级至网页页面，yes则是
    NSString *webNo = @"no";
    //以下排序为每页button排序，从1开始到9结束，第二页从21开始至29结束，第三页从31开始至34结束
    switch (sender.tag) {
        case 0:
            [self sitePush];
            break;
        case 1:
            [self TablePush:navBarText:webNo:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=86&statez=1" tag:sender.tag];//随州介绍
            break;
        case 2:
            [self TablePush:navBarText:webNo:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=95&statez=1" tag:sender.tag];//旅游资源
            break;
        case 3:
            [self TablePush:navBarText:webNo:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=107&statez=1" tag:sender.tag];//日版电子报
            break;
        case 4:
            [self TablePush:navBarText:webNo:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=112&statez=1" tag:sender.tag];//随州新闻
            break;
        case 5:
            [self TablePush:navBarText:webNo:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=114&statez=1" tag:sender.tag];//政务公开
            break;
        case 6:
            [self TablePush:navBarText:webNo:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=127&statez=1" tag:sender.tag];//清廉随州
            break;
        case 7:
            [self TablePush:navBarText:webNo:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=134&statez=1" tag:sender.tag];//专题视频
            break;  
        case 8:
            [self TablePush:navBarText:webYes:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=135&statez=2" tag:sender.tag];//主持人微博
            break;
        case 9:
              [self TablePush:navBarText:webYes:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=136&statez=2" tag:sender.tag];//企业风采-特汽
            break;
        case 21:
              [self TablePush:navBarText:webYes:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=137&statez=2" tag:sender.tag];//企业风采-工业
            break;
        case 22:
            [self TablePush:navBarText:webYes:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=138&statez=2" tag:sender.tag];//节目直播
            break;
        case 23:
            [self siteIntroduction];//关于本应用
            break;
        case 24:
              [self TablePush:navBarText:webYes:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=139&statez=2" tag:sender.tag];//企业风采-农业
            break;
        case 25:
            [self TablePush:navBarText:webNo:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=140&statez=2" tag:sender.tag];//新闻视频
            break;
        case 26:
            [self TablePush:navBarText:webNo:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=141&statez=2" tag:sender.tag];//联通手机业务
            break;
        case 27:
            [self WebPush:navBarText:@"http://mob.10010.com/"];//联通营业厅
            break;
        case 28:
            [self WebPush:navBarText:@"http://www.suizhougjj.cn/"];//公积金帐号
            break;
        case 29:
            [self developPush:navBarText];//社保账户
            break;
        case 31:
            [self developPush:navBarText];//医保帐号
            break;
        case 32:
              [self TablePush:navBarText:webYes:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=142&statez=2" tag:sender.tag];//招聘信息
            break;
        case 33:
            [self TablePush:navBarText:webNo:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=143&statez=1" tag:sender.tag];//楚天都市报
            break;
        case 34:
            [self developPush:navBarText];//评选活动
            break;
        default:
            [self TablePush:navBarText:webNo:@"http://121.199.29.181/demo/joomla/suizhou/index.php?option=com_content&view=category&layout=blog&id=86&statez=1" tag:sender.tag];
            break;
    }
    */
}
/*
 以下为页面跳转方法
 */
//跳转至列表页
-(void)TablePush:(NSString *)navBarText :(NSString *)web :(NSString *)urlString tag:(int)btnTag
{
    NSString *infoID = [NSString stringWithFormat:@"%d-%@",btnTag,navBarText];
    TableViewController *list = [[[TableViewController alloc]initWithNibName:@"TableViewController" bundle:nil infoID:infoID] autorelease];
    list.navText = navBarText;//传递导航条名称
    list.dataURLString = urlString;//传递申请数据地址
    list.webJudge = web;//判定是否下级页面为网页页面
    [self.navigationController pushViewController:list animated:YES];
}
//跳转至设置页
-(void)sitePush
{
    SiteTableViewController *Sitepush = [[SiteTableViewController alloc]init];
    [self.navigationController pushViewController:Sitepush animated:YES];
    [Sitepush release];
}
//跳转至关于页面
-(void)siteIntroduction
{
    SiteIntroductionViewController *sitePush = [[SiteIntroductionViewController alloc]init];
    [self.navigationController pushViewController:sitePush animated:YES];
    [sitePush release];
}
//跳转至显示项目开发页面
-(void)developPush:(NSString *)navBarText
{
    DevelopViewController * devePush = [[DevelopViewController alloc]init];
    devePush.navText = navBarText;
    [self.navigationController pushViewController:devePush animated:YES];
    [devePush release];
}
//跳转至网页显示页面
-(void)WebPush:(NSString *)navBarText :(NSString *)url
{
    //@"http://www.w3school.com.cn/i/movie.mp4"
    WebViewController *web = [[WebViewController alloc]init];
    web.navText = navBarText;
    web.webPushString = url;
    [self.navigationController pushViewController:web animated:YES];
    [web release];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_BackGroundView release];
    [_ScrollView release];
    [_PageContol release];
    [_TwoView release];
    [_ThreeView release];
    [_bgView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNavBar:nil];
    [self setBackGroundView:nil];
    [self setScrollView:nil];
    [self setPageContol:nil];
    [self setTwoView:nil];
    [self setThreeView:nil];
    [super viewDidUnload];
}
@end
