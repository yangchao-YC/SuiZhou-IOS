//
//  ArticleVO.h
//  神韵随州
//
//  Created by 李迪 on 13-11-27.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleVO : NSObject
@property(nonatomic,assign)int articleID;
@property(nonatomic,strong)NSString *infoID;
@property(nonatomic,strong)NSString *mark;
@property(nonatomic,strong)NSString *title;//信息标题
@property(nonatomic,strong)NSString *note;//判断是否为滑动
@property(nonatomic,strong)NSString *introtext;//判断是否为滑动
@property(nonatomic,strong)NSString *modified_time;//时间
@property(nonatomic,strong)NSString *cnparams;//图片地址
@property(nonatomic,strong)NSString *description;//内容简介
@property(nonatomic,strong)NSString *zcategory;//判断列表等级
@property(nonatomic,strong)NSString *zcategoryurl;//下级列表数据地址

@property(nonatomic,strong)NSString *haveimg;
@end
