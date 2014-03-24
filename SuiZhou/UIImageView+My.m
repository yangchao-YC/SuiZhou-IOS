//
//  UIImageView+My.m
//  TestData
//
//  Created by 李迪 on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImageView+My.h"

@implementation UIImageView (My)
- (void)setImageByKeyAndURL:(NSString *)key withURL:(NSString *)urlString
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSString *imagePath1 = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",key]];//最终路径
        UIImage *img = [UIImage imageWithContentsOfFile:imagePath1];
        if (!img) {
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            img = [UIImage imageWithData:imgData];
            NSData *imageData1 = UIImagePNGRepresentation(img);
            
            [imageData1 writeToFile:imagePath1 atomically:YES];//写入文件
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = nil;
            self.image = img; 
        });
    });
}

@end
