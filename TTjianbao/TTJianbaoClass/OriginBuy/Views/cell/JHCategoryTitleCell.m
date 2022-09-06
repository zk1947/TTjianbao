//
//  JHCategoryTitleCell.m
//  TTjianbao
//
//  Created by apple on 2020/7/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCategoryTitleCell.h"
#import "JHMallCateViewModel.h"
#import <YDCategoryKit/YDCategoryKit.h>

@interface JHCategoryTitleCell()
@property(nonatomic,strong)UILabel *titleLabel;

@end
@implementation JHCategoryTitleCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createViews];
        
    }
    return self;
}
-(void)setTitleWithVm:(JHMallCateViewModel *)vm
{
    if([vm isKindOfClass:[JHMallCateViewModel class]])
    {
        self.titleLabel.text = vm.name;
        self.titleLabel.font = vm.titleFont;
    }
}
- (void)createViews {
    [self titleLabel];
}
-(void)updateTitleLabel:(BOOL)isSelected
{
    if(isSelected)
    {
        self.titleLabel.textColor = [UIColor colorWithHexStr:@"333333"];
        self.titleLabel.backgroundColor = [UIColor colorWithHexStr:@"FFFDED"];
        self.titleLabel.layer.borderColor = [UIColor colorWithHexStr:@"FEE100"].CGColor;
    }else
    {
        self.titleLabel.textColor = [UIColor colorWithHexStr:@"999999"];
        self.titleLabel.backgroundColor = [UIColor colorWithHexStr:@"ffffff"];
        self.titleLabel.layer.borderColor = [UIColor colorWithHexStr:@"ffffff"].CGColor;

    }
}
-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexStr:@"999999"];
        _titleLabel.backgroundColor = [UIColor colorWithHexStr:@"ffffff"];
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.layer.cornerRadius = 4.0;
        _titleLabel.layer.borderWidth = 1.0;
        _titleLabel.layer.borderColor = [UIColor colorWithHexStr:@"ffffff"].CGColor;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        
    }
    return _titleLabel;
}
@end
