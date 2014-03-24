//
//  UIViewController+HUD.h
//  YHBY_ios
//
//  Created by mac on 13-4-10.
//  Copyright (c) 2013年 zhou min. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (HUD)
@property(nonatomic,retain) MBProgressHUD *HUD;
- (void)showHUDInfo:(NSString *)info;
- (void)removeHUDInfo;
@end
