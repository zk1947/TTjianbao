//
//  JHMarketFloatingWindowView.m
//  TTjianbao
//
//  Created by zk on 2021/6/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketFloatingWindowView.h"

@interface JHMarketFloatingWindowView ()

@property (nonatomic, strong) UIButton * button1;

@property (nonatomic, strong) UIButton *button2;

@property (nonatomic, strong) UIButton *button3;

@property (nonatomic, strong) UILabel *pointLable1;

@property (nonatomic, strong) UILabel *pointLable2;

@property (nonatomic, strong) UILabel *pointLable3;

@property (nonatomic, assign) int floatType;//样式 1-全展示 2-隐藏收藏 3-隐藏竞拍 4-隐藏收藏和竞拍1

@property (nonatomic, assign) int likeNum;//收藏数量

@property (nonatomic, assign) int auctionNum;//竞拍状态 1-出价 2-出局 3-领先 4-中拍

@end

@implementation JHMarketFloatingWindowView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setCollectNum:(int)collectNum auctionStatus:(int)auctionStatus{
    //更新样式布局
    int status = 4;
    if (collectNum > 0 && auctionStatus > 0) {//1-全展示
        status = 1;
    }else if (collectNum == 0 && auctionStatus > 0){//2-隐藏收藏
        status = 2;
    }else if (collectNum > 0 && auctionStatus == 0){//3-隐藏竞拍
        status = 3;
    }else if (collectNum == 0 && auctionStatus == 0){//4-隐藏收藏和竞拍
        status = 4;
    }
    self.floatType = status;
    [self layoutMySubView];
    //更新收藏数
    self.likeNum = collectNum;
    //更新竞拍状态
    self.auctionNum = auctionStatus;
}

- (void)setLikeNum:(int)likeNum{
    _likeNum = likeNum;
    NSString *txtStr = [NSString stringWithFormat:@"%d",_likeNum];
    CGFloat labW = 14;
    if (likeNum > 99) {
        labW = 28;
        txtStr = @"99+";
    }
    if (likeNum > 9 && likeNum <= 99) {
        labW = 20;
    }
    _pointLable1.text = txtStr;
    [_pointLable1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(labW);
    }];
}

- (void)setAuctionNum:(int)auctionNum{
    _auctionNum = auctionNum;
    switch (_auctionNum) {
        case 1:self.pointLable2.text = @"出价";
            break;
        case 2:self.pointLable2.text = @"出局";
            break;
        case 3:self.pointLable2.text = @"领先";
            break;
        case 4:self.pointLable2.text = @"成交";
            break;
        default:self.pointLable2.text = @"";
            break;
    }
}

- (void)layoutMySubView{
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self addSubview:self.button3];
    [self.button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(58);
    }];
    
    [self addSubview:self.pointLable3];
    [self.pointLable3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-42);
        make.right.mas_equalTo(-2);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(14);
    }];
    
    if (self.floatType == 4) {//4-隐藏收藏和竞拍
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(58);
        }];
        return;
    }
    
    if (self.floatType == 3) {//3-隐藏竞拍
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(58*2);
        }];
        
        [self addSubview:self.button1];
        [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.button3.mas_top).offset(-5);
            make.right.mas_equalTo(-4);
            make.width.height.mas_equalTo(50);
        }];
        
        [self addSubview:self.pointLable1];
        [self.pointLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.button1.mas_top).offset(16);
            make.centerX.mas_equalTo(15);
            make.height.mas_equalTo(14);
        }];
        return;
    }
    
    if (self.floatType == 2) {//2-隐藏收藏
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(58*2);
        }];
        
        [self addSubview:self.button2];
        [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.button3.mas_top).offset(-5);
            make.right.mas_equalTo(-4);
            make.width.height.mas_equalTo(50);
        }];
        
        [self addSubview:self.pointLable2];
        [self.pointLable2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.button2.mas_top).offset(10);
            make.right.mas_equalTo(-2);
            make.width.mas_equalTo(32);
            make.height.mas_equalTo(14);
        }];
        return;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(58*3);
    }];
    
    [self addSubview:self.button2];
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.button3.mas_top).offset(-5);
        make.right.mas_equalTo(-4);
        make.width.height.mas_equalTo(50);
    }];
    
    [self addSubview:self.pointLable2];
    [self.pointLable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.button2.mas_top).offset(10);
        make.right.mas_equalTo(-2);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(14);
    }];
    
    [self addSubview:self.button1];
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.button2.mas_top).offset(-5);
        make.right.mas_equalTo(-4);
        make.width.height.mas_equalTo(50);
    }];
    
    [self addSubview:self.pointLable1];
    [self.pointLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.button1.mas_top).offset(16);
        make.centerX.mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
}

- (void)buttonAction:(UIButton *)button{
    if (_marketFloatBlock) {
        _marketFloatBlock(button.tag-2021);
    }
}

-  (void)hiddenAddButton{
    self.button3.hidden = YES;
    self.pointLable3.hidden = YES;
}

- (UIButton *)button1{
    if (!_button1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 2021;
        [button setBackgroundImage:JHImageNamed(@"c2c_pd_shoucang") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _button1 = button;
    }
    return _button1;
}

- (UIButton *)button2{
    if (!_button2) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 2022;
        [button setBackgroundImage:JHImageNamed(@"c2c_pd_paimai") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _button2 = button;
    }
    return _button2;
}

- (UIButton *)button3{
    if (!_button3) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 2023;
        [button setBackgroundImage:JHImageNamed(@"c2c_market_float3_icon") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _button3 = button;
    }
    return _button3;
}

- (UILabel *)pointLable1{
    if (!_pointLable1) {
        UILabel *lab = [UILabel new];
        lab.backgroundColor = HEXCOLOR(0xF03D37);
        lab.textColor = kColorFFF;
        lab.font = JHFont(10);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.layer.cornerRadius  = 7;
        lab.layer.masksToBounds = YES;
        _pointLable1 = lab;
    }
    return _pointLable1;
}

- (UILabel *)pointLable2{
    if (!_pointLable2) {
        UILabel *lable = [[UILabel alloc]init];
        lable.textColor = kColorFFF;
        lable.font = JHFont(10);
        lable.textAlignment = NSTextAlignmentCenter;
        lable.backgroundColor = HEXCOLOR(0xF23730);
        lable.layer.cornerRadius = 7;
        lable.layer.masksToBounds = YES;
        _pointLable2 = lable;
    }
    return _pointLable2;
}

- (UILabel *)pointLable3{
    if (!_pointLable3) {
        UILabel *lable = [[UILabel alloc]init];
        lable.text = @"卖宝贝";
        lable.textColor = kColorFFF;
        lable.font = JHFont(10);
        lable.textAlignment = NSTextAlignmentCenter;
        lable.backgroundColor = HEXCOLOR(0xF23730);
        lable.layer.cornerRadius = 7;
        lable.layer.masksToBounds = YES;
        _pointLable3 = lable;
    }
    return _pointLable3;
}

@end
