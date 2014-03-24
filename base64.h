//
//  base64.h
//  神韵随州
//
//  Created by 杨超 on 13-10-28.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface base64 : NSObject
+ (NSString*)encodeBase64String:(NSString*)input;
+ (NSString*)decodeBase64String:(NSString*)input;
+ (NSString*)encodeBase64Data:(NSData*)data;
+ (NSString*)decodeBase64Data:(NSData*)data;
@end
