//
//  JHRedPacketListMoneyHeader.m
//  TTjianbao
//
//  Created by apple on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRedPacketListMoneyHeader.h"
#import "TTjianbaoMarcoKeyword.h"

@interface JHRedPacketListMoneyHeader()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *moneyLabel;

@end

@implementation JHRedPacketListMoneyHeader

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"red_packet_header_bg"];
        self.contentMode = UIViewContentModeScaleAspectFill;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _titleLabel = [UILabel jh_labelWithText:@"恭喜发财，大吉大利" font:14 textColor:RGB(252, 222, 179) textAlignment:1 addToSuperView:self];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15.f);
        make.left.equalTo(self).offset(15.f);
        make.right.equalTo(self).offset(-15.f);
        make.height.mas_equalTo(20.f);
    }];
    
    _moneyLabel = [UILabel jh_labelWithFont:47 textColor:RGB(252, 222, 179) addToSuperView:self];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.f);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(55.f);
    }];
    
    UIButton *button = [UIButton jh_buttonWithTitle:@"已存入津贴，下单可直接使用" fontSize:12 textColor:RGB(252, 222, 179) target:self action:@selector(balanceClick) addToSuperView:self];
    button.jh_imageName(@"red_packet_alert_push");
    CGFloat titleW = 156.f;
    CGFloat imageW = 7.f;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, titleW + 2, 0, - titleW - 2);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, - imageW - 2, 0, imageW + 2);
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(27.f);
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(3.f);
    }];
}

- (void)balanceClick{
    
}

- (void)setTitle:(NSString *)title price:(CGFloat)price{
    _titleLabel.text = title;
    _moneyLabel.attributedText = [self getAttributedString:price];
}
- (NSMutableAttributedString *)getAttributedString:(CGFloat)price
{
    NSString *string = [NSString stringWithFormat:@"￥%@",PRICE_FLOAT_TO_STRING(price)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes: @{NSFontAttributeName:JHBoldFont(25)}];

    [attributedString addAttributes:@{NSForegroundColorAttributeName:RGB(252, 222, 179)} range:NSMakeRange(0, 1)];
    
    [attributedString addAttributes:@{NSFontAttributeName: JHDINBoldFont(47), NSForegroundColorAttributeName:RGB(252, 222, 179)} range:NSMakeRange(1, string.length-1)];
    return attributedString;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
