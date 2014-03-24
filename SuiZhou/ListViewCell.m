//
//  ListViewCell.m
//  SuiZhou
//
//  Created by 杨超 on 13-10-11.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import "ListViewCell.h"

@implementation ListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_image release];
    [_TitleLabel release];
    [_CountLabel release];
    [_arImage release];
    [_bgImage release];
    [_TimeLabel release];
    [super dealloc];
}
@end
