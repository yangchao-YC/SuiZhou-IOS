//
//  WebViewController.h
//  神韵随州
//
//  Created by 杨超 on 13-10-17.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *navLabel;
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property(nonatomic,retain)NSString * navText;
@property(nonatomic,retain)NSString * webPushString;
@end
