//
//  JHRecycleHomeGoodsCollectionViewCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeGoodsCollectionViewCell.h"
#import "JHRecycleHomeGoodsModel.h"
#import "UILabel+JHPriceLabel.h"

@interface JHRecycleHomeGoodsCollectionViewCell ()
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *typeTitleLabel;
//@property (nonatomic, strong) UILabel *moneyTextLabel;
//@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIImageView *statusImageView;
@end

@implementation JHRecycleHomeGoodsCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self setupUI];
    }
    return self;
}

#pragma mark - UI
- (void)setupUI{
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.typeTitleLabel];
    [self.contentView addSubview:self.statusImageView];
//    [self.contentView addSubview:self.moneyTextLabel];
//    [self.contentView addSubview:self.moneyLabel];

    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(self.width, self.width));
    }];
    
    [self.typeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_bottom).offset(6);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView);
    }];
    
//    [self.moneyTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.typeTitleLabel.mas_bottom).offset(4);
//        make.left.equalTo(self.typeTitleLabel.mas_left);
//        make.width.mas_equalTo(33);
//    }];
//
//    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.moneyTextLabel);
//        make.left.equalTo(self.moneyTextLabel.mas_right).offset(3);
//        make.right.equalTo(self.contentView);
//    }];
    
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.goodsImageView);
        make.size.mas_equalTo(CGSizeMake(30.f, 16.f));
    }];
    
//    self.statusImageView.hidden = YES;
}


- (void)bindViewModel:(id)dataModel params:(NSDictionary *)parmas{
    JHRecycleHomeGoodsResultListModel *goodsListModel = dataModel;

    NSString *logoImgUrl = [goodsListModel.productImage.medium stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    [self.goodsImageView jh_setImageWithUrl:logoImgUrl placeHolder:@"newStore_detail_shopProduct_Placeholder"];

    self.typeTitleLabel.text = goodsListModel.productCateName;
    self.statusImageView.hidden = !goodsListModel.recycleSuccessType;

//    if (goodsListModel.recyclePrice.length > 0) {
//        self.moneyTextLabel.text = @"回收价";
//        self.moneyLabel.text = goodsListModel.recyclePrice;
//    }else{
//        self.moneyTextLabel.text = @"";
//        self.moneyLabel.text = @"";
//    }
//    [self.moneyLabel setPrice:self.moneyLabel.text prefixFont:[UIFont fontWithName:kFontNormal size:11] labelFont:JHDINBoldFont(15) textColor:HEXCOLOR(0xF23730)];

}

#pragma mark - Lazy
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [UIImageView new];
        _goodsImageView.backgroundColor = UIColor.orangeColor;
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.clipsToBounds = YES;
    }
    return _goodsImageView;
}

- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [UIImageView new];
        _statusImageView.image = [UIImage imageNamed:@"recycle_status_complete"];
    }
    return _statusImageView;
}

- (UILabel *)typeTitleLabel {
    if (!_typeTitleLabel) {
        _typeTitleLabel = [UILabel new];
        _typeTitleLabel.textColor = HEXCOLOR(0x333333);
        _typeTitleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    }
    return _typeTitleLabel;
}
//- (UILabel *)moneyTextLabel{
//    if (!_moneyTextLabel) {
//        _moneyTextLabel = [UILabel new];
//        _moneyTextLabel.textColor = HEXCOLOR(0x666666);
//        _moneyTextLabel.font = [UIFont fontWithName:kFontNormal size:11];
//    }
//    return _moneyTextLabel;
//}
//- (UILabel *)moneyLabel{
//    if (!_moneyLabel) {
//        _moneyLabel = [UILabel new];
//        _moneyLabel.textColor = HEXCOLOR(0xF23730);
//        _moneyLabel.font = JHDINBoldFont(15);
//    }
//    return _moneyLabel;
//}

@end
