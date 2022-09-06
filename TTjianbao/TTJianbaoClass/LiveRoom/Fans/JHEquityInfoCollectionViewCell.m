//
//  JHEquityInfoCollectionViewCell.m
//  TTjianbao
//
//  Created by liuhai on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHEquityInfoCollectionViewCell.h"
#import "JHFansEquityListModel.h"
@interface JHEquityInfoCollectionViewCell()
@property (nonatomic, strong) UIImageView           *imgView;
@property (nonatomic, strong) UILabel               *imageLabel;/// 专场价标签
@property (nonatomic, strong) UILabel               *titleLabel;
@end

@implementation JHEquityInfoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {

    if (!_imgView) {
        _imgView                         = [UIImageView new];
        _imgView.layer.cornerRadius = 30;
        _imgView.clipsToBounds           = YES;
        _imgView.contentMode             = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.top.mas_equalTo(8);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
    }
    
    if (!_imageLabel) {
        _imageLabel                     = [[UILabel alloc] init];
        _imageLabel.textAlignment       = NSTextAlignmentCenter;
        _imageLabel.textColor           = HEXCOLOR(0x7E1C0D);
        _imageLabel.numberOfLines       = 1;
        _imageLabel.font                = [UIFont fontWithName:kFontNormal size:11.f];
        [self.imgView addSubview:_imageLabel];
        [_imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.imgView.mas_centerY);
            make.centerX.mas_equalTo(self.imgView.mas_centerX);
            make.width.mas_equalTo(40);
        }];
    }

    if (!_titleLabel) {
        _titleLabel                     = [[UILabel alloc] init];
        _titleLabel.textColor           = kColor666;
        _titleLabel.numberOfLines       = 0;
        _titleLabel.font                = [UIFont fontWithName:kFontNormal size:12.f];
        _titleLabel.textAlignment       = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(11);
            make.right.mas_equalTo(-11);
            make.top.mas_equalTo(self.imgView.mas_bottom).offset(6);
        }];
    }
    
}
- (void)resetCollectCell:(JHFansEquityInfoModel *)model andBgImage:(BOOL)isget{
    //0代金券，1专属商品，2进场特效，3专属粉丝牌  fansEquity_bg_0 fansEquity_bg_10
    if (isget) {
        _imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fansEquity_bg_%@",model.rewardType]];
        _imageLabel.textColor           = HEXCOLOR(0x7E1C0D);
    }else{
        _imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fansEquity_bg_1%@",model.rewardType]];
        _imageLabel.textColor           = UIColor.whiteColor;
    }
    
    [_imageLabel setText:model.rewardImgName];
    _titleLabel.text = model.rewardName;
}
@end
