//
//  ViewController.h
//  SuiZhou
//
//  Created by 杨超 on 13-10-10.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface ViewController : UIViewController<ASIHTTPRequestDelegate>
{
    NSTimer *timer;
}

@end
