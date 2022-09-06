//
//  JHRecycleHomeHotGoodsCollectionViewCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeHotGoodsCollectionViewCell.h"
#import "JHRecycleHomeModel.h"
#import "UILabel+JHPriceLabel.h"

@interface JHRecycleHomeHotGoodsCollectionViewCell ()
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyTextLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIImageView *statusImageView;

@end

@implementation JHRecycleHomeHotGoodsCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark  - 设置UI
- (void)setupUI{
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.statusImageView];
//    [self.contentView addSubview:self.moneyTextLabel];
//    [self.contentView addSubview:self.moneyLabel];

    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.equalTo(self.contentView);
        //make.size.mas_equalTo(CGSizeMake(106, 106));
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView.width);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_bottom).offset(5);
        make.left.equalTo(self.contentView).offset(2);
        make.right.equalTo(self.contentView);
    }];
    
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.goodsImageView);
        make.size.mas_equalTo(CGSizeMake(30.f, 16.f));
    }];
    
//    [self.moneyTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
//        make.left.equalTo(self.titleLabel.mas_left);
//        make.width.mas_equalTo(50);
//    }];
//
//    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.moneyTextLabel);
//        make.left.equalTo(self.moneyTextLabel.mas_right).offset(3);
//        make.right.equalTo(self.contentView);
//    }];
    
}

- (void)bindViewModel:(id)dataModel params:(NSDictionary *)parmas{
    JHHomeHotRecycleProductsListModel *goodsListModel = dataModel;
    
    [self.goodsImageView jh_setImageWithUrl:goodsListModel.productImage.small placeHolder:@"newStore_detail_shopProduct_Placeholder"];
    self.titleLabel.text = goodsListModel.productCateName;
    
    if (goodsListModel.recycleHighPrice.length > 0) {
        self.moneyTextLabel.text = @"最高回收价";
        self.moneyLabel.text = goodsListModel.recycleHighPrice;
    }else{
        self.moneyTextLabel.text = @"";
        self.moneyLabel.text = @"";
    }
    [self.moneyLabel setPrice:self.moneyLabel.text prefixFont:[UIFont fontWithName:kFontNormal size:9] labelFont:JHDINBoldFont(14) textColor:HEXCOLOR(0xF23730)];

    self.statusImageView.hidden = !goodsListModel.recycleSuccessType;
}

- (void)setPrice:(NSString *)price prefixFont:(UIFont *)font prefixColor:(UIColor *)color forLabel:(UILabel *)label {
    if ([price isNotBlank]) {
        NSString *prefixString = [price substringToIndex:1];
        if ([prefixString isEqualToString:@"¥"]) {
            price = [price substringFromIndex:1];
        }
        NSString *string = [@"¥" stringByAppendingString:price];
        NSRange range = [string rangeOfString:@"¥"];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        [attrString addAttribute:NSFontAttributeName value:font range:range];
        [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
        
        label.attributedText = attrString;
        
    } else {
        label.text = @"";
    }
}


#pragma mark  - 懒加载

- (UIImageView *)goodsImageView{
    if (!_goodsImageView) {
        _goodsImageView = [UIImageView new];
        _goodsImageView.backgroundColor = UIColor.orangeColor;
        _goodsImageView.layer.cornerRadius = 5;
        _goodsImageView.layer.masksToBounds = YES;
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _goodsImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
    }
    return _titleLabel;
}
- (UILabel *)moneyTextLabel{
    if (!_moneyTextLabel) {
        _moneyTextLabel = [UILabel new];
        _moneyTextLabel.textColor = HEXCOLOR(0x666666);
        _moneyTextLabel.font = [UIFont fontWithName:kFontNormal size:10];
    }
    return _moneyTextLabel;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.textColor = HEXCOLOR(0xF23730);
        _moneyLabel.font = JHDINBoldFont(14);
    }
    return _moneyLabel;
}
- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [UIImageView new];
        _statusImageView.image = [UIImage imageNamed:@"recycle_status_complete"];
    }
    return _statusImageView;
}
@end
