//
//  ScrollImageCell.m
//  神韵随州
//
//  Created by 杨超 on 13-10-18.
//  Copyright (c) 2013年 杨 超. All rights reserved.
//

#import "ScrollImageCell.h"
#import "UIImageView+My.h"
#import "ArticleVO.h"

@implementation ScrollImageCell
{
    NSArray *_data;
}
@synthesize MyscrollView;
@synthesize view;
@synthesize label;
@synthesize PageControl;
@synthesize tapDelegate = _tapDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.MyscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 172)];
        self.MyscrollView.bounces = NO;
        self.MyscrollView.pagingEnabled = YES;
        self.MyscrollView.scrollsToTop = NO;
        self.MyscrollView.delegate = self;
        self.MyscrollView.showsHorizontalScrollIndicator = NO;
        self.MyscrollView.userInteractionEnabled = YES;
        
        UIGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap:)] autorelease];
        [self.MyscrollView addGestureRecognizer:tap];
      
        self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 137, 320, 35)];
        self.PageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(130, 145, 60, 36)];
        [self.PageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        
        //  self.view.backgroundColor = [UIColor lightGrayColor];
        UIColor *col = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.2f];//设置半透明效果
        self.view.backgroundColor = col;
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 250, 15)];
        // self.label.backgroundColor = [UIColor clearColors];
        [self.contentView addSubview:MyscrollView];
        [self.contentView addSubview:view];
        [self.contentView addSubview:self.PageControl];
        [self.view addSubview:label];
        
    }
    return self;
}

- (void)scrollViewTap:(UIGestureRecognizer *)ges
{
    [self.tapDelegate focusTaped:self.PageControl.currentPage];
}

- (void)initData:(NSArray *)data
{
    _data = [data retain];
    for (int i=0; i<_data.count; i++) {
        ArticleVO *dictImage = [_data objectAtIndex:i];//根据行数获取相应的网络数据
        //NSURL *IMGURL = [NSURL URLWithString:[dictImage objectForKey:@"cnparams"]];  //声明一个URL，将图片地址转换
        //  NSData *imgData = [NSData dataWithContentsOfURL:IMGURL];        //获取这个地址的图片（获取的是一个二进制的子节流，转换成图片）
        //    UIImage *img =  [UIImage imageWithData:imgData];
        
        UIImageView *imageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(4 *320, 0, 320, 172)];
        NSString *idSting = dictImage.cnparams;
        // NSLog(@"%@",idSting);
        NSString *imageKey = [NSString stringWithFormat:@"%@",idSting];
        
        [imageView_ setImageByKeyAndURL:imageKey withURL:dictImage.cnparams];//调用自定义方法，异步下载图片并且缓存到本地，setImageByKeyAndURL为每张图片的名字，withURL为图片的地址
        imageView_.frame = CGRectMake(i *320, 0, 320, 172);
        [self.MyscrollView addSubview:imageView_];
    }
    
    int lineCount = _data.count;//array.count;
    CGFloat wigth = lineCount * 320;
    self.MyscrollView.contentSize = CGSizeMake(wigth, 172);
    //UIColor *col = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.3f];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor blackColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;//设置选中颜色，此时设置为无颜色
    
    self.PageControl.numberOfPages = _data.count;
    self.PageControl.currentPage = 0;
    NSString *title = [[_data objectAtIndex:self.PageControl.currentPage] title];
    self.label.text = title;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1{
    CGPoint offset=scrollView1.contentOffset;
    CGRect bounds=scrollView1.frame;
    [self.PageControl setCurrentPage:offset.x/bounds.size.width];
    NSString *title = [[_data objectAtIndex:self.PageControl.currentPage] title];
    self.label.text = title;
}


-(IBAction)pageTurn:(UIPageControl *)sender
{
    CGSize viewsize = self.MyscrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage*viewsize.width, 0, viewsize.width, viewsize.height);
    [self.MyscrollView scrollRectToVisible:rect animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_data release];
    [super dealloc];
}
@end
