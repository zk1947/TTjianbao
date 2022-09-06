//
//  JHC2CSendPackageView.m
//  TTjianbao
//
//  Created by hao on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSendPackageView.h"

@interface JHC2CSendPackageView ()
@property (nonatomic, strong) UILabel *packageTitleLabel;
@property (nonatomic, strong) UILabel *packageLabel;//包装文字内容
@property (nonatomic, strong) UIImageView *packageImg;//包装图片
@end

@implementation JHC2CSendPackageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self initSubviews];

    }
    return self;
}

#pragma mark - UI
- (void)initSubviews{
    //标题
    [self addSubview:self.packageTitleLabel];
    [self.packageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
    //包装说明
    [self addSubview:self.packageLabel];
    [self.packageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.packageTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
    //包装图
    [self addSubview:self.packageImg];
    [self.packageImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.packageLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-10);
        make.height.mas_offset((kScreenWidth-44)*9/16);//16:9
    }];
}

#pragma mark - LoadData
- (void)setPackageModel:(JHC2CPackageDescriptionModel *)packageModel{
    _packageModel = packageModel;
    //包装说明
    self.packageLabel.text = packageModel.content;
    //包装图
    [self.packageImg jh_setImageWithUrl:packageModel.imageUrl placeHolder:@"newStore_default_placehold"];
}

#pragma mark - Action

#pragma mark - Delegate

#pragma mark - Lazy
- (UILabel *)packageTitleLabel{
    if (!_packageTitleLabel) {
        _packageTitleLabel = [[UILabel alloc] init];
        _packageTitleLabel.textColor = HEXCOLOR(0x333333);
        _packageTitleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _packageTitleLabel.text = @"快递包装及视频录制建议";
    }
    return _packageTitleLabel;
}
- (UILabel *)packageLabel{
    if (!_packageLabel) {
        _packageLabel = [[UILabel alloc] init];
        _packageLabel.textColor = HEXCOLOR(0x666666);
        _packageLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _packageLabel.numberOfLines = 0;
    }
    return _packageLabel;
}
- (UIImageView *)packageImg{
    if (!_packageImg) {
        _packageImg = [[UIImageView alloc] init];
        _packageImg.layer.cornerRadius = 5;
        _packageImg.layer.masksToBounds = YES;
        _packageImg.image = JHImageNamed(@"newStore_default_placehold");
    }
    return _packageImg;
}

@end
