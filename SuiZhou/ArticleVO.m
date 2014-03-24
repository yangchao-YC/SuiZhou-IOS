//
//  ArticleVO.m
//  神韵随州
//
//  Created by 李迪 on 13-11-27.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import "ArticleVO.h"

@implementation ArticleVO

@synthesize articleID;
@synthesize infoID;
@synthesize mark;
@synthesize title;//信息标题
@synthesize note;//判断是否为滑动
@synthesize introtext;//判断是否为滑动
@synthesize modified_time;//时间
@synthesize cnparams;//图片地址
@synthesize description;//内容简介
@synthesize zcategory;//判断列表等级
@synthesize zcategoryurl;//下级列表数据地址

@synthesize haveimg;
@end
