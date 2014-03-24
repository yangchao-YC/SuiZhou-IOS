//
//  HomeViewController.h
//  SuiZhou
//
//  Created by 杨超 on 13-10-10.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UIScrollViewDelegate>
{
    NSArray * urlString;
}
@property (retain, nonatomic) IBOutlet UINavigationBar *NavBar;
@property (retain, nonatomic) IBOutlet UIView *BackGroundView;
@property (retain, nonatomic) IBOutlet UIView *TwoView;
@property (retain, nonatomic) IBOutlet UIView *ThreeView;
@property (retain, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *PageContol;
@property (retain, nonatomic) IBOutlet UIView *HomeBgView;

@end
