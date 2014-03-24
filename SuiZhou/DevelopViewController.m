//
//  DevelopViewController.m
//  神韵随州
//
//  Created by 杨超 on 13-10-17.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import "DevelopViewController.h"

@interface DevelopViewController ()

@end

@implementation DevelopViewController
@synthesize navBar = _navBar;
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
    self.navLabel.text = self.navText;
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"headers_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navBar.frame = CGRectMake(0, 20, 320, 44);
        self.navLabel.frame = CGRectMake(53, 31, 204, 21);
        self.backButton.frame=CGRectMake(5, 27, 40, 30);
    }
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
    [_navLabel release];
    [_navBar release];
    [_backButton release];
    [super dealloc];
}
@end
