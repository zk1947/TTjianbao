//
//  JHRedPacketDetailHeader.m
//  TTjianbao
//
//  Created by apple on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRedPacketDetailHeader.h"
#import "TTjianbaoMarcoKeyword.h"

@interface JHRedPacketDetailHeader ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *moneyLabel;

@property (nonatomic, strong) UIImageView *avatorView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIView *bgViewTop;

@end

@implementation JHRedPacketDetailHeader

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
        make.top.equalTo(self).offset(UI.statusAndNavBarHeight + 15.f);
        make.left.equalTo(self).offset(15.f);
        make.right.equalTo(self).offset(-15.f);
        make.height.mas_equalTo(20.f);
    }];
    
    _moneyLabel = [UILabel jh_labelWithFont:47 textColor:RGB(252, 222, 179) addToSuperView:self];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15.f);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(50.f);
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
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(5.f);
    }];

    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [whiteView jh_cornerRadius:8.f rectCorner:UIRectCornerTopLeft|UIRectCornerTopRight bounds:CGRectMake(0, 0, ScreenW, 97.f)];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(97.f);
    }];
    
   
    _avatorView = [UIImageView jh_imageViewAddToSuperview:self];
    [_avatorView jh_cornerRadius:25];
    [_avatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(whiteView.mas_top);
        make.height.width.mas_equalTo(50.f);
    }];
    
    _nameLabel = [UILabel jh_labelWithFont:14 textColor:RGB(51, 51, 51) addToSuperView:whiteView];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatorView);
        make.top.equalTo(self.avatorView.mas_bottom).offset(10.f);
    }];
    
    _descLabel = [UILabel jh_labelWithFont:12 textColor:RGB(102, 102, 102) addToSuperView:whiteView];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).offset(15.f);
        make.bottom.equalTo(whiteView).offset(-15);
    }];
    
    UIView *lineView = [UIView jh_viewWithColor:RGB(238, 238, 238) addToSuperview:self];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).offset(15.f);
        make.right.equalTo(whiteView).offset(-15.f);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(whiteView);
    }];
}

- (void)balanceClick{
    if(_balanceClickBlock)
    {
        _balanceClickBlock();
    }
}

- (void)setWishes:(NSString *)wishes price:(CGFloat)price avavtorUrl:(NSString *)avavtorUrl name:(NSString *)name descStr:(NSString *)descStr
{
    _titleLabel.text = wishes;
    _moneyLabel.attributedText = [self getAttributedString:price];
    [_avatorView jh_setAvatorWithUrl:avavtorUrl];
    _nameLabel.text = name;
    _descLabel.text = descStr;
}
- (NSMutableAttributedString *)getAttributedString:(CGFloat)price
{
    NSString *string = [NSString stringWithFormat:@"￥%@",PRICE_FLOAT_TO_STRING(price)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes: @{NSFontAttributeName:JHBoldFont(25)}];

    [attributedString addAttributes:@{NSForegroundColorAttributeName:RGB(252, 222, 179)} range:NSMakeRange(0, 1)];
    
    [attributedString addAttributes:@{NSFontAttributeName: JHDINBoldFont(47), NSForegroundColorAttributeName:RGB(252, 222, 179)} range:NSMakeRange(1, string.length-1)];
    return attributedString;
}

+ (CGFloat)viewHeight
{
    return 260.f + UI.statusAndNavBarHeight;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
