//
//  JHLiveRoomPKBottomView.m
//  TTjianbao
//
//  Created by apple on 2020/8/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomPKBottomView.h"
#import "JHUIFactory.h"
#import "UIView+JHGradient.h"
#import "JHLiveRoomPKModel.h"

@interface JHLiveRoomPKBottomView ()
@property(nonatomic,strong)UILabel *rankLabel;
@property(nonatomic,strong)UIImageView * headerImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *desLabel;
@property(nonatomic,strong)UILabel *rightLabel;
@property(nonatomic,strong)UIButton *shopBtn;

@end

@implementation JHLiveRoomPKBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowOpacity = 0.06;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -2);
        self.layer.shadowRadius = 4;
        [self crearUI];
    }
    return self;
}
-(void)crearUI{
    self.rankLabel = [[UILabel alloc] init];
    [self addSubview:self.rankLabel];
    self.rankLabel.textColor = HEXCOLOR(0x999999);
    self.rankLabel.font = JHDINBoldFont(13);
    self.rankLabel.textAlignment = NSTextAlignmentCenter;
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(39);
    }];
    
    self.headerImage = [[UIImageView alloc] init];
    self.headerImage.layer.cornerRadius = 25;
    self.headerImage.clipsToBounds = YES;
    [self addSubview:self.headerImage];
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(self.rankLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = HEXCOLOR(0x333333);
    self.titleLabel.font = JHFont(15);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(self.headerImage.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenW-240, 21));
    }];
    
    self.desLabel = [[UILabel alloc] init];
    [self addSubview:self.desLabel];
    self.desLabel.textColor = HEXCOLOR(0x666666);
    self.desLabel.font = JHFont(12);
    self.desLabel.textAlignment = NSTextAlignmentLeft;
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.headerImage.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenW-240, 17));
    }];
    
    self.rightLabel = [[UILabel alloc] init];
    [self addSubview:self.rightLabel];
    self.rightLabel.textColor = HEXCOLOR(0xFF4200);
    self.rightLabel.font = JHFont(13);
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    
    self.shopBtn = [JHUIFactory createThemeBtnWithTitle:@"购物助力" cornerRadius:19 target:self action:@selector(pressGoShopBtnEnter)];
    self.shopBtn.titleLabel.font = JHFont(13);
    [self addSubview:self.shopBtn];
    [self.shopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.top.equalTo(self).offset(16);
        make.size.mas_equalTo(CGSizeMake(82, 38));
    }];
    [self.shopBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(27);
        make.right.mas_equalTo(self.shopBtn.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(60, 18));
    }];
}
-(void)resetViewwithModel:(JHLiveRoomPKInfoModel *)model andType:(NSInteger)type{
    if ([model.ranking isEqualToString:@"未上榜"]) {
        [self.rankLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
        }];
    }
    self.rankLabel.text = model.ranking;
    
    [self.headerImage jhSetImageWithURL:[NSURL URLWithString:model.img ? : @""] placeholder:kDefaultAvatarImage];
    self.titleLabel.text = model.name;
    self.desLabel.text = model.rankTip;
    if (model.rankTip.length == 0) {
        self.desLabel.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(25);
        }];
    }
    self.rightLabel.text = model.score;
    if (type == 2) {
        self.shopBtn.hidden = YES;
        [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-18);
        }];
    }
}
-(void)pressGoShopBtnEnter{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressGoShopBtnEnter)]) {
        [self.delegate pressGoShopBtnEnter];
    }
}
@end
