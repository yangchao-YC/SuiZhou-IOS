//
//  WebScrollViewController.m
//  神韵随州
//
//  Created by 杨超 on 13-10-24.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import "WebScrollViewController.h"
#import "base64.h"
#import "ArticleVO.h"

@interface WebScrollViewController ()

@end

@implementation WebScrollViewController
{
    NSArray *_data;
    NSArray *_webViewsHandle;
    int _selectedIndex;
    int mark;
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
    // Do any additional setup after loading the view from its nib.
    
    //self.navLabel.text = self.navText;
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"headers_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.ScrollView.frame = CGRectMake(0, 44, 320, 372 + DISTANCE);
    self.ScrollView.contentSize = CGSizeMake(320 * _data.count, 372 + DISTANCE);
    
    self.ScrollView.pagingEnabled = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if (IS_IPHONE_5) {
            self.navBar.frame = CGRectMake(0, 20, 320, 64);
            self.navLabel.frame = CGRectMake(53, 31, 204, 21);
            self.backButton.frame=CGRectMake(5, 27, 40, 30);
            self.ScrollView.frame = CGRectMake(0, -22, 320, 392 + DISTANCE);
            self.buttomBar.frame = CGRectMake(0, 436 + DISTANCE, 320, 44);
            self.bottomButton1.frame = CGRectMake(30, 445 + DISTANCE, 25, 25);//刷新按钮
            self.bottomButton4.frame = CGRectMake(258, 445 + DISTANCE, 25, 25);//分享按钮
            self.btnBack.frame = CGRectMake(104, 445 + DISTANCE, 25, 25);//向左箭头
            self.btnNext.frame = CGRectMake(187, 445 + DISTANCE, 25, 25);//向右箭头
        }
        else
        {
            self.ScrollView.frame = CGRectMake(0, 45, 320, 392);
            self.buttomBar.frame = CGRectMake(0, 436 + DISTANCE, 320, 44);
            self.bottomButton1.frame = CGRectMake(30, 445 + DISTANCE, 25, 25);//刷新按钮
            self.bottomButton4.frame = CGRectMake(258, 445 + DISTANCE, 25, 25);//分享按钮
            self.btnBack.frame = CGRectMake(104, 445 + DISTANCE, 25, 25);//向左箭头
            self.btnNext.frame = CGRectMake(187, 445 + DISTANCE, 25, 25);//向右箭头
        }
    }
    else
    {
        
        self.buttomBar.frame = CGRectMake(0, 416 + DISTANCE, 320, 44);
        self.bottomButton1.frame = CGRectMake(30, 425 + DISTANCE, 25, 25);//刷新按钮
        self.bottomButton4.frame = CGRectMake(258, 425 + DISTANCE, 25, 25);//分享按钮
        self.btnBack.frame = CGRectMake(104, 425 + DISTANCE, 25, 25);//向左箭头
        self.btnNext.frame = CGRectMake(187, 425 + DISTANCE, 25, 25);//向右箭头
    }
    
    
    
    NSString *labelString = [NSString stringWithFormat:@"%d/%d",_selectedIndex + 1,_data.count];//获取当前是第几位
     mark = _selectedIndex;//记录当前查看的索引号，用于刷新判定
    NSLog(@"-初--%d-------",mark);
    self.navLabel.text = labelString;//设置标题数字
    
    NSMutableArray *handle = [NSMutableArray array];
    //根据数据设置当前的显示webView个数与显示的内容
    for (int i = 0; i< _data.count; i++) {
        
        UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(i *320, 0, 320, 372 + DISTANCE )]autorelease];
        /*
         NSURL *url = [NSURL URLWithString:self.webPushString];
         [webView loadRequest:[NSURLRequest requestWithURL:url]];
         */
        
        //加载本地模版
  
        
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"];
        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        //获取本条数据
        ArticleVO *article = [_data objectAtIndex:i];
        
        //对数据进行解码操作
        NSString *yy = article.introtext;
        NSString *base = [base64 decodeBase64String:yy];
        //进行数据添加
        html = [html stringByReplacingOccurrencesOfString:@"{title}" withString:article.title];
        html = [html stringByReplacingOccurrencesOfString:@"{time}" withString:article.modified_time];
        html = [html stringByReplacingOccurrencesOfString:@"{Content}" withString:base];
        [webView loadHTMLString:html baseURL:baseURL];
        [self.ScrollView addSubview:webView];
        [handle addObject:webView];
    }
    
    _webViewsHandle = [handle retain];
    
    CGSize viewsize = self.ScrollView.frame.size;
    CGRect rect = CGRectMake(_selectedIndex * viewsize.width, 0, viewsize.width, viewsize.height);
    [self.ScrollView scrollRectToVisible:rect animated:YES];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1{
    CGPoint offset=scrollView1.contentOffset;
    CGRect bounds=scrollView1.frame;
    int currentPageIndex = offset.x/bounds.size.width;
    
    UIWebView *webView = [_webViewsHandle objectAtIndex:currentPageIndex];
    NSString *labelString = [NSString stringWithFormat:@"%d/%d",currentPageIndex + 1,_data.count];//获取当前是第几位
    self.navLabel.text = labelString;//设置标题数字
//    NSDictionary *article = [_data objectAtIndex:currentPageIndex];
//    //加载本地模版
//    
//    NSString *yy = [article objectForKey:@"introtext"];
//    NSString *base = [base64 decodeBase64String:yy];
//    
//    
//    
//    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"];
//    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    //
//    html = [html stringByReplacingOccurrencesOfString:@"{title}" withString:[article objectForKey:@"title"]];
//    html = [html stringByReplacingOccurrencesOfString:@"{time}" withString:[article objectForKey:@"modified_time"]];
//    //此处参照上面替换中间内容
//    html = [html stringByReplacingOccurrencesOfString:@"{Content}" withString:base];
//
//    
//    [webView loadHTMLString:html baseURL:baseURL];
}

- (void)initDataAndIndex:(NSArray *)data_ selectIndex:(int)index_
{
    _data = [data_ retain];
    _selectedIndex = index_;
}
//参数i为判断用户点击的是向左箭头还是向右箭头
//yes为左箭头   no为右
-(void)scroll:(BOOL *)i
{
    CGPoint offset=self.ScrollView.contentOffset;
    CGRect bounds=self.ScrollView.frame;
    int currentPageIndex = offset.x/bounds.size.width;
    if (i) {
        //如果到顶了，timer中止
        if (offset.x != 0) {
            NSString *labelString = [NSString stringWithFormat:@"%d/%d",currentPageIndex ,_data.count];//获取当前是第几位
            mark = currentPageIndex -1;
             
            self.navLabel.text = labelString;//设置标题数字
        }
        offset.x -=320;
        offset.x = MAX(0, offset.x);
        //最后设置scollView's contentOffset
        self.ScrollView.contentOffset = offset;
        
        NSLog(@"-减--%d-------",mark);
        // NSLog(@"%f    三",offset.x);
    }
    else
    {
        
        offset=self.ScrollView.contentOffset;
        bounds=self.ScrollView.frame;
        currentPageIndex = offset.x/bounds.size.width;
        if (offset.x != (self.ScrollView.contentSize.width -320)) {
            offset.x +=320;
            currentPageIndex = offset.x/bounds.size.width;
            NSString *labelString = [NSString stringWithFormat:@"%d/%d",currentPageIndex+1,_data.count];
            
             mark = currentPageIndex;
            
            self.navLabel.text = labelString;
        }
        offset.x = MAX(0, offset.x);
        self.ScrollView.contentOffset = offset;
        NSLog(@"-加--%d-------",mark);
       // NSLog(@"offset    %f",offset.x);

    }
}

//刷新显示，根据记录的mark值判断当前用户的查看的数据索引号，然后使用此数据重新刷新本页面
-(void)scrollRe
{
     NSLog(@"-刷新下--%d-------",mark);
    UIWebView *webView = [_webViewsHandle objectAtIndex:mark];
    
        NSDictionary *article = [_data objectAtIndex:mark];
        //加载本地模版
    
        NSString *yy = [article objectForKey:@"introtext"];
        NSString *base = [base64 decodeBase64String:yy];
    
    
    
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"];
        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        //
        html = [html stringByReplacingOccurrencesOfString:@"{title}" withString:[article objectForKey:@"title"]];
        html = [html stringByReplacingOccurrencesOfString:@"{time}" withString:[article objectForKey:@"modified_time"]];
        //此处参照上面替换中间内容
       html = [html stringByReplacingOccurrencesOfString:@"{Content}" withString:base];
    
        NSLog(@"-开始刷新--%d-------",mark);
      [webView loadHTMLString:html baseURL:baseURL];
}
//发送邮件方法，调用系统邮件，设置标题及内容，用户自己输入收件人进行发送邮件，因为内容为html格式，所以此时设置的是支持html的发送格式
-(void)main
{
    NSDictionary *article = [_data objectAtIndex:mark];
    //加载本地模版
    NSString *title = [article objectForKey:@"title"];
    NSString *yy = [article objectForKey:@"introtext"];
    NSString *base = [base64 decodeBase64String:yy];
     NSLog(@"-开始刷新--%@-------",base);
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController * mailC = [[MFMailComposeViewController alloc]init];
        mailC.mailComposeDelegate = self;
        [mailC setSubject:title];//主题
        [mailC setToRecipients:[NSArray arrayWithObjects:nil]];//收件人

        [mailC setMessageBody:base isHTML:YES];//内容，是否为html格式
        [self presentModalViewController:mailC animated:YES];
        [mailC release];
        
    }
   else
   {
       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"出错了" message:@"您还没有设置邮件账户" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
       [alert show];
       [alert release];
   }
    
}

//发送邮件回调方法，此时为返回界面
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

//放弃使用
- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


//button监听器
-(IBAction)btn:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
            [self scrollRe];
            break;
        case 2:
            [self scroll:YES];
            break;
        case 3:
            [self scroll:NO];
            break;
        case 4:
            [self main];
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_navLabel release];
    [_data release];
    [_webViewsHandle release];
    [_buttomBar release];
    [_bottomButton1 release];
    [_bottomButton4 release];
    [_backButton release];
    [super dealloc];
}
@end
