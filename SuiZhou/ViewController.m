//
//  ViewController.m
//  SuiZhou
//
//  Created by 杨超 on 13-10-10.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
	// Do any additional setup after loading the view, typically from a nib.
    if (IS_IPHONE_5) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"start5.png"]] ;
    }
    else
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"start.png"]] ;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timePush) userInfo:nil repeats:YES];
}
-(void)timePush
{
    [timer invalidate];
    HomeViewController *home = [[HomeViewController alloc]init];
    [self.navigationController pushViewController:home animated:YES];
    [home release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
