//
//  ListViewCell.h
//  SuiZhou
//
//  Created by 杨超 on 13-10-11.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *image;
@property (retain, nonatomic) IBOutlet UILabel *TitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *CountLabel;
@property (retain, nonatomic) IBOutlet UILabel *TimeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *arImage;
@property (retain, nonatomic) IBOutlet UIImageView *bgImage;

@end
