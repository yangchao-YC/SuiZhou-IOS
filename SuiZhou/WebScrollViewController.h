//
//  WebScrollViewController.h
//  神韵随州
//
//  Created by 杨超 on 13-10-24.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface WebScrollViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property(nonatomic,retain) IBOutlet UIScrollView *ScrollView;
@property(nonatomic,retain) IBOutlet UIButton *btnBack;
@property(nonatomic,retain) IBOutlet UIButton *btnNext;
@property (retain, nonatomic) IBOutlet UILabel *navLabel;
@property(nonatomic,retain) IBOutlet UINavigationBar *navBar;
@property (retain, nonatomic) IBOutlet UIImageView *buttomBar;
@property (retain, nonatomic) IBOutlet UIButton *bottomButton1;
@property (retain, nonatomic) IBOutlet UIButton *bottomButton4;

@property(nonatomic,retain)NSString * navText;

@property (retain, nonatomic) IBOutlet UIButton *backButton;
- (void)initDataAndIndex:(NSArray *)data_ selectIndex:(int)index_;
@end
