//
//  NTESMenuCell.m
//  NEUIDemo
//
//  Created by Netease on 17/1/6.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESMenuCell.h"
#import "UIView+NTES.h"

@interface NTESMenuCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSString *selectIcon;
@property (nonatomic, strong) NSString *normalIcon;
@end

@implementation NTESMenuCell

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) //选中状态
    {
        if (_selectIcon)
        {
            self.imageView.image = [UIImage imageNamed:_selectIcon];
        }
        else
        {
            self.backgroundColor = [UIColor lightGrayColor];
        }
    }
    else //正常状态
    {
        if (_selectIcon)
        {
            self.imageView.image = [UIImage imageNamed:_normalIcon];
        }
        else
        {
            self.backgroundColor = [UIColor clearColor];
        }
    }
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.imageView];
        
        [self addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgWidth = 40.0;
    
    if (_selectIcon)
    {
        self.imageView.frame = CGRectMake(0, 0, imgWidth, imgWidth);
        self.label.frame = CGRectMake(0,
                                      self.height - self.label.height,
                                      self.label.width,
                                      self.label.height);
        self.imageView.center = CGPointMake(self.width/2, self.imageView.centerY);
    }
    else
    {
        
        self.imageView.frame = CGRectMake(0, 0, imgWidth, imgWidth);
        self.imageView.center = CGPointMake(self.width/2, self.height/2 - 12.0);
        self.label.frame = CGRectMake(0,
                                      self.imageView.bottom + 12.0,
                                      self.label.width,
                                      self.label.height);
        
    }
    self.label.centerX = self.imageView.centerX;
}

- (void)refreshCell:(NSString *)title icon:(NSString *)icon selectIcon:(NSString *)selectIcon;
{
    if (title)
    {
        self.label.text = title;
        [self.label sizeToFit];
    }
    
    if (icon)
    {
        _normalIcon = icon;
        self.imageView.image = [UIImage imageNamed:icon];
    }
    
    if (selectIcon) {
        _selectIcon = selectIcon;
    }
}

#pragma mark - Getter/Setter
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)label
{
    if (!_label)
    {
        _label = [[UILabel alloc] init];
        [_label setTextColor:[UIColor whiteColor]];
        [_label setTextAlignment:NSTextAlignmentCenter];
        _label.font=[UIFont systemFontOfSize:10.0];
    }
    return _label;
}

@end
