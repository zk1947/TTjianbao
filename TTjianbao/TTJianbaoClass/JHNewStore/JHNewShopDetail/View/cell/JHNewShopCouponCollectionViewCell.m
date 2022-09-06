//
//  JHNewShopCouponCollectionViewCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopCouponCollectionViewCell.h"
#import "TTjianbaoHeader.h"
#import "JHStoreHelp.h"

@interface JHNewShopCouponCollectionViewCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *money2Label;
@property (nonatomic, strong) UILabel *receiveLabel;
@end

@implementation JHNewShopCouponCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_offset(0);
    }];
    
    [self.backView addSubview:self.backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_offset(0);
    }];

    [self.backView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(5);
        make.left.mas_offset(0);
        make.width.mas_offset(88);
    }];

    [self.backView addSubview:self.money2Label];
    [self.money2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-5);
        make.left.mas_offset(0);
        make.width.mas_offset(88);
    }];

    [self.backView addSubview:self.receiveLabel];
    [self.receiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(88);
        make.size.mas_equalTo(CGSizeMake(22, 42));
    }];

}
- (UIView *)backView{
    if (!_backView) {
        _backView = [UIView new];
    }
    return _backView;
}
- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [UIImageView new];
        _backImageView.image = JHImageNamed(@"newStore_coupon_yellow_icon");

    }
    return _backImageView;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.textColor = [CommHelp toUIColorByStr:@"#7E1C0D"];
        _moneyLabel.text = @"¥12345678";
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.font = [UIFont fontWithName:kFontBoldDIN size:16];
    }
    return _moneyLabel;
}
- (UILabel *)money2Label{
    if (!_money2Label) {
        _money2Label = [UILabel new];
        _money2Label.textColor = [CommHelp toUIColorByStr:@"#7E1C0D"];
        _money2Label.text = @"满90000.00元可用";
        _money2Label.textAlignment = NSTextAlignmentCenter;
        _money2Label.font = [UIFont fontWithName:kFontNormal size:9];
    }
    return _money2Label;
}
- (UILabel *)receiveLabel{
    if (!_receiveLabel) {
        _receiveLabel = [UILabel new];
        _receiveLabel.textColor = [CommHelp toUIColorByStr:@"#7E1C0D"];
        _receiveLabel.text = @"领\n取";
        _receiveLabel.textAlignment = NSTextAlignmentCenter;
        _receiveLabel.numberOfLines = 0;
        _receiveLabel.font = [UIFont fontWithName:kFontNormal size:10];
    }
    return _receiveLabel;
}

- (void)setCouponListModel:(JHNewShopDetailCouponListModel *)couponListModel{
    _couponListModel = couponListModel;
    
    if ([couponListModel.ruleType isEqualToString:@"FR"]) {//满减
        self.moneyLabel.text = couponListModel.price;
        [self setPrice:couponListModel.price prefixFont:[UIFont fontWithName:kFontNormal size:9] prefixColor:[CommHelp toUIColorByStr:@"#7E1C0D"] forLabel:self.moneyLabel];
        self.money2Label.text = [NSString stringWithFormat:@"满%@元可用",couponListModel.ruleFrCondition];

    }else if ([couponListModel.ruleType isEqualToString:@"OD"]) {//折扣
        self.moneyLabel.text = [NSString stringWithFormat:@"%@折",couponListModel.price];
        self.moneyLabel.attributedText = [self getAcolorfulStringWithText1:couponListModel.price Font1:[UIFont fontWithName:kFontBoldDIN size:16] Text2:@"折" Font2:[UIFont fontWithName:kFontNormal size:9] AllText:self.moneyLabel.text];
        self.money2Label.text = [NSString stringWithFormat:@"满%@元可用",couponListModel.ruleFrCondition];

    }else if ([couponListModel.ruleType isEqualToString:@"EFR"]) {//每满减
        self.moneyLabel.text = couponListModel.price;
        [self setPrice:couponListModel.price prefixFont:[UIFont fontWithName:kFontNormal size:9] prefixColor:[CommHelp toUIColorByStr:@"#7E1C0D"] forLabel:self.moneyLabel];
        self.money2Label.text = [NSString stringWithFormat:@"每满%@元可用",couponListModel.ruleFrCondition];
    }
    
    [self updateCellStatus:couponListModel.isReceive];
    //判断刷新当前商品订单 是否 解除
    [[RACObserve(couponListModel, isReceive) skip:1] subscribeNext:^(id  _Nullable x) {
        [self updateCellStatus:couponListModel.isReceive];
    }];
}

- (void)updateCellStatus:(NSString *)isReceive{
    if ([isReceive boolValue]) {
        _backImageView.image = JHImageNamed(@"newStore_coupon_gray_icon");
        self.userInteractionEnabled = NO;
        _receiveLabel.font = [UIFont fontWithName:kFontNormal size:9];
        _receiveLabel.text = @"去\n使\n用";
        

    }else{
        _backImageView.image = JHImageNamed(@"newStore_coupon_yellow_icon");
        self.userInteractionEnabled = YES;
        _receiveLabel.font = [UIFont fontWithName:kFontNormal size:10];
        _receiveLabel.text = @"领\n取";

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

- (NSMutableAttributedString *)getAcolorfulStringWithText1:(NSString *)text1 Font1:(UIFont *)font1 Text2:(NSString *)text2  Font2:(UIFont *)font2 AllText:(NSString *)allText{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allText];
    [str beginEditing];
    if (text1) {
        NSRange range1 = [allText rangeOfString:text1];
        if (font1) {
            [str addAttribute:NSFontAttributeName value:font1 range:range1];
        }
    }
    if (text2) {
        NSRange range2 = [allText rangeOfString:text2];
        if (font2) {
            [str addAttribute:NSFontAttributeName value:font2 range:range2];
            
        }
    }
    
    [str endEditing];
    
    return str;
}
@end
