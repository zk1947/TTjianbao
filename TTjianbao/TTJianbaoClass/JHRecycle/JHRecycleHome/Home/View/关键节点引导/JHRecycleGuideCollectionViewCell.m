//
//  JHRecycleGuideCollectionViewCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleGuideCollectionViewCell.h"
#import "UILabel+edgeInsets.h"
#import "JHGradientView.h"
#import "JHRecycleHomeModel.h"
#import "UILabel+edgeInsets.h"

@interface JHRecycleGuideCollectionViewCell ()
@property (nonatomic, strong) JHGradientView *backView;
@property (nonatomic, strong) UIImageView *goodsImgView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *nextLabel;
@end

@implementation JHRecycleGuideCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
#pragma mark  - 设置UI

- (void)setupUI {
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0,10));
    }];
   
    //商品图
    [self.backView addSubview:self.goodsImgView];
    [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.backView).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    //节点
    [self.backView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(14);
        make.left.equalTo(self.goodsImgView.mas_right).offset(8);
    }];
    //对应文案
    [self.backView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel.mas_bottom).offset(9);
        make.left.equalTo(self.typeLabel);
    }];
    [self.backView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentLabel);
        make.left.equalTo(self.contentLabel.mas_right).offset(4);
    }];
    
    //下一步
    [self.backView addSubview:self.nextLabel];
    [self.nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.right.equalTo(self.backView).offset(-10);
        
    }];

}

- (void)bindViewModel:(id)dataModel params:(NSDictionary *)parmas{
    JHHomeOrderInfoListModel *orderListModel = dataModel;
    [self.goodsImgView jh_setImageWithUrl:orderListModel.productImage.small placeHolder:@"newStore_detail_shopProduct_Placeholder"];
    if (orderListModel.productStatus == 8) {//待确认报价
        self.typeLabel.text = @"待确认交易";
        self.nextLabel.text = @"去确认报价";
    }else if (orderListModel.productStatus == 19){//待发货
        self.typeLabel.text = @"待发货";
        self.nextLabel.text = @"去发货";
    }
    self.contentLabel.text = orderListModel.productDesc;
    self.moneyLabel.text = orderListModel.bidPrice;
    if (orderListModel.bidPrice.length > 0) {
        [self setPrice:self.moneyLabel.text prefixFont:[UIFont fontWithName:kFontNormal size:9] prefixColor:HEXCOLOR(0xF23730) forLabel:self.moneyLabel];
    }

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
- (JHGradientView *)backView{
    if (!_backView) {
        _backView = [[JHGradientView alloc] init];
        [_backView setGradientColor:@[(__bridge id)HEXCOLOR(0xFFFFFF).CGColor,(__bridge id)HEXCOLOR(0xFFFAF1).CGColor] orientation:JHGradientOrientationHorizontal];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 5;
        _backView.layer.borderColor = HEXCOLOR(0xe6e6e6).CGColor;
        _backView.layer.borderWidth = 0.5;
        
    }
    return _backView;
}


- (UIImageView *)goodsImgView {
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
        _goodsImgView.layer.cornerRadius = 4.5;
        _goodsImgView.layer.masksToBounds = YES;
        _goodsImgView.backgroundColor = UIColor.orangeColor;
    }
    return _goodsImgView;
}
- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = HEXCOLOR(0xFF9900);
        _typeLabel.font = [UIFont fontWithName:kFontMedium size:11];
        _typeLabel.edgeInsets = UIEdgeInsetsMake(2, 4, 2, 4);
        _typeLabel.backgroundColor = HEXCOLOR(0xFFF3E1);
        _typeLabel.layer.cornerRadius = 2;
        _typeLabel.layer.masksToBounds = YES;
    }
    return _typeLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXCOLOR(0x222222);
        _contentLabel.font = [UIFont fontWithName:kFontMedium size:12];
    }
    return _contentLabel;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = HEXCOLOR(0xF23730);
        _moneyLabel.font = JHDINBoldFont(16);
    }
    return _moneyLabel;
}
- (UILabel *)nextLabel{
    if (!_nextLabel) {
        _nextLabel = [[UILabel alloc] init];
        _nextLabel.textColor = HEXCOLOR(0x222222);
        _nextLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _nextLabel.backgroundColor = HEXCOLOR(0xFFD70F);
        _nextLabel.layer.cornerRadius = 4;
        _nextLabel.layer.masksToBounds = YES;
        _nextLabel.edgeInsets = UIEdgeInsetsMake(4, 6, 4, 6);
    }
    return _nextLabel;
}

@end
