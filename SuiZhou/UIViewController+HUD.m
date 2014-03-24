//
//  UIViewController+HUD.m
//  YHBY_ios
//
//  Created by mac on 13-4-10.
//  Copyright (c) 2013年 zhou min. All rights reserved.
//

#import "UIViewController+HUD.h"
#import <objc/runtime.h>

static void *MyObjectMyCustomPorpertyKey = (void *)@"MyObjectMyCustomPorpertyKey";

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD
{
    return objc_getAssociatedObject(self, MyObjectMyCustomPorpertyKey);
}

- (void)setHUD:(MBProgressHUD *)hud
{
    objc_setAssociatedObject(self, MyObjectMyCustomPorpertyKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHUDInfo:(NSString *)info
{
    if (!self.HUD) {
        self.HUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
        [self.view addSubview:self.HUD];
    }

    [self.HUD setLabelText:info];
    if (!self.HUD.isHidden) {
        [self.HUD show:YES];
    }
}

- (void)removeHUDInfo
{
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
}

@end
