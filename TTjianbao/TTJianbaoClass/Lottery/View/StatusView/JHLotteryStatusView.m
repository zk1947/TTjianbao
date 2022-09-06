//
//  JHLotteryStatusView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryStatusView.h"

@interface JHLotteryStatusView ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *tipLabel;

@property (nonatomic, weak) UILabel *priceLabel;

@end

@implementation JHLotteryStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSelfSubViews];
    }
    return self;
}

- (void)addSelfSubViews
{
    _titleLabel = [UILabel jh_labelWithBoldFont:16 textColor:UIColor.blackColor addToSuperView:self];
    _titleLabel.numberOfLines = 0;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    
    _tipLabel = [UILabel jh_labelWithBoldFont:16 textColor:RGB(252, 66, 0) addToSuperView:self];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self).offset(-15);
    }];
    
    //_tipLabel.attributedText = [self getAttributedString];
    
    _priceLabel = [UILabel jh_labelWithBoldFont:14 textColor:RGB153153153 addToSuperView:self];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel);
        make.centerY.equalTo(_tipLabel);
    }];
    
    [[UIView jh_viewWithColor:RGB153153153 addToSuperview:self.priceLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(self.priceLabel);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.priceLabel).offset(45);
    }];
}

- (void)setTitle:(NSString *)title price:(NSString *)price origPrice:(NSString *)origPrice
{
    _titleLabel.text = title;
    _tipLabel.attributedText = [self getAttributedStringWithPrice:price];
    _priceLabel.text = [NSString stringWithFormat:@"市场价 ￥%@", origPrice];
}

- (NSMutableAttributedString *)getAttributedStringWithPrice:(NSString *)price
{
    NSString *string = [NSString stringWithFormat:@"￥%@ 抽奖价", price];
    ///宝慧让数字下沉 + 数字后面一定的间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes: @{NSFontAttributeName:JHDINBoldFont(16)}];
    [attributedString addAttributes:@{NSFontAttributeName: JHDINBoldFont(32),NSBaselineOffsetAttributeName:@-2} range:NSMakeRange(1, price.length)];
    [attributedString addAttributes:@{NSFontAttributeName: JHDINBoldFont(5)} range:NSMakeRange(price.length + 1, 1)];
    return attributedString;
}

@end
