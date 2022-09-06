//
//  JHCustomNewCollectionViewCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomNewCollectionViewCell.h"
#import "UIView+JHGradient.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHCustomWorksModel.h"
#import "UIImageView+WebCache.h"
#import "TTjianbao.h"
@interface JHCustomNewCollectionViewCell()
/** 背景图*/
@property (nonatomic, strong) UIImageView *coverImageView;
/** 状态*/
@property (nonatomic, strong) UIButton *statusButton;
/** 名字*/
@property (nonatomic, strong) UILabel *goodsNameLabel;
/** 定制师*/
@property (nonatomic, strong) UILabel *masterNameLabel;
@end
@implementation JHCustomNewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        [self configUI];
    }
    return self;
}

- (void)configUI{

    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.statusButton];
    [self.contentView addSubview:self.goodsNameLabel];
    [self.contentView addSubview:self.masterNameLabel];
}

- (void)setModel:(JHCustomWorksModel *)model{
    _model = model;
    self.goodsNameLabel.text = model.feeName;
    self.masterNameLabel.text = [NSString stringWithFormat:@"定制师: %@", model.anchorName];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:kDefaultCoverImage];
    if ([model.status isEqualToString:@"1"]) {
        self.statusButton.hidden = NO;
        [_statusButton setImage:[UIImage imageNamed:@"custmoize_ing_logo"] forState:UIControlStateNormal];
        [_statusButton setTitle:@"进行中" forState:UIControlStateNormal];
    }else if([model.status isEqualToString:@"2"]){
        self.statusButton.hidden = NO;
        [_statusButton setImage:[UIImage imageNamed:@"customize_completeIcon"] forState:UIControlStateNormal];
        [_statusButton setTitle:@"已完成" forState:UIControlStateNormal];
    }else{
        self.statusButton.hidden = YES;
    }
}
#pragma mark -添加阴影


#pragma mark 绘制UI

- (UIImageView *)coverImageView{
    if (_coverImageView == nil) {
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
        _coverImageView.backgroundColor = [UIColor lightGrayColor];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}

- (UIButton *)statusButton{
    if (_statusButton == nil) {
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusButton.frame = CGRectMake(self.coverImageView.left + 10, self.coverImageView.top + 10, 61, 20);
        [_statusButton setImage:[UIImage imageNamed:@"custmoize_ing_logo"] forState:UIControlStateNormal];
        [_statusButton setTitle:@"进行中" forState:UIControlStateNormal];
        _statusButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _statusButton.backgroundColor = RGBA(0, 0, 0, 0.4);
        _statusButton.layer.cornerRadius = 10;
        _statusButton.clipsToBounds = YES;
        [_statusButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    }
    return _statusButton;
}


- (UILabel *)goodsNameLabel{
    if (_goodsNameLabel == nil) {
        _goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.coverImageView.bottom + 10, self.width - 20, 19)];
        _goodsNameLabel.text = @"";
        _goodsNameLabel.font = [UIFont fontWithName:kFontMedium size:13];
        _goodsNameLabel.textColor = RGB(51, 51, 51);
    }
    return _goodsNameLabel;
}

- (UILabel *)masterNameLabel{
    if (_masterNameLabel == nil) {
        _masterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.goodsNameLabel.bottom + 5, self.width - 20, 19)];
        _masterNameLabel.text = @"";
        _masterNameLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _masterNameLabel.textColor = RGB(102, 102, 102);
    }
    return _masterNameLabel;
}
@end
