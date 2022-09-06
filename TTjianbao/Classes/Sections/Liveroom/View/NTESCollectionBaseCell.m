//
//  NTESCollectionBaseCell.m
//  LiveStream_IM_Demo
//
//  Created by Netease on 17/1/19.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESCollectionBaseCell.h"
#import "UIView+NTES.h"

@interface NTESCollectionBaseCell ()

@property (nonatomic,strong) UIView *right_line;

@property (nonatomic,strong) UIView *bottom_line;

@end

@implementation NTESCollectionBaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.right_line = [[UIView alloc] init];
        self.right_line.backgroundColor = HEXCOLORA(0xffffff, 0.3);
        [self.contentView addSubview:self.right_line];
        
        self.bottom_line = [[UIView alloc] init];
        self.bottom_line.backgroundColor = HEXCOLORA(0xffffff, 0.3);
        [self.contentView addSubview:self.bottom_line];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.right_line.frame = CGRectMake(self.width, 0, 1.0, self.height);
    
    self.bottom_line.frame = CGRectMake(0, self.height, self.width, 1.0);
}

- (void)configCellSeparate:(NSInteger)index
             rowsEveryPage:(NSInteger)rowsEveryPage
            linesEveryPage:(NSInteger)linesEveryPage
{
    self.right_line.hidden = NO;
    self.bottom_line.hidden = NO;
    
    if (index % rowsEveryPage == 0) //最右侧的
    {
        self.right_line.hidden = YES;
    }
    else if (index / rowsEveryPage == linesEveryPage) //最后一行
    {
        self.bottom_line.hidden = YES;
    }
}

- (void)hiddenAllSeparate
{
    self.right_line.hidden = YES;
    self.bottom_line.hidden = YES;
}

@end
