//
//  ScrollImageCell.h
//  神韵随州
//
//  Created by 杨超 on 13-10-18.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScrollImageCellTapDelegate;

@interface ScrollImageCell : UITableViewCell<UIScrollViewDelegate>
@property(nonatomic,retain)UIScrollView *MyscrollView;
@property(nonatomic,retain)UIView *view;
@property(nonatomic,retain)UILabel *label;
@property(nonatomic,retain)UIPageControl *PageControl;

@property(nonatomic,assign)id<ScrollImageCellTapDelegate> tapDelegate;

- (void)initData:(NSArray *)data;
@end

@protocol ScrollImageCellTapDelegate <NSObject>

- (void)focusTaped:(int)articleIndex_;

@end
