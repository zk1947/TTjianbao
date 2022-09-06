//
//  JHKeyTypeCollectionViewCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHKeyTypeCollectionViewCell.h"
#import "JHRecycleHomeModel.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
@interface JHKeyTypeCollectionViewCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrrowImageView;
@end

@implementation JHKeyTypeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark  - 设置UI
- (void)setupUI{
    [self.contentView addSubview:self.iconImageView];
   
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    UIView *backView = [[UIView alloc]init];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(6);
        make.centerX.equalTo(self.contentView);
    }];
    
    [backView addSubview:self.titleLabel];
    [backView addSubview:self.arrrowImageView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(backView).offset(0);
        make.left.equalTo(backView);
    }];
    
    [self.arrrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.right.equalTo(backView.mas_right).offset(0);
    }];

}
- (void)bindViewModel:(id)dataModel indexRow:(NSInteger)indexRow{
    JHHomeRecycleCategoryListModel *categoryListModel = dataModel;
    self.titleLabel.text = categoryListModel.btnDesc;
    [self.iconImageView jhSetImageWithURL:categoryListModel.baseImage[@"small"] placeholder:kDefaultCoverImage];
}


#pragma mark  - 懒加载

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

- (UIImageView *)arrrowImageView{
    if (!_arrrowImageView) {
        _arrrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"recycle_home_cell_sanjiao"]];
    }
    return _arrrowImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = HEXCOLOR(0x222222);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _titleLabel;
}

@end
