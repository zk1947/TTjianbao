//
//  JHC2CProductDetailBottomFunctionView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailBottomFunctionView.h"
#import "JHC2CProductDetailBottomFunctionView.h"

#import "JHC2CProductDetailBusiness.h"
@interface JHC2CProductDetailBottomFunctionView()

@property(nonatomic) JHC2CProductDetailBottomFunctionView_Type type;

@end

@implementation JHC2CProductDetailBottomFunctionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.saveBtn];
    [self addSubview:self.chatBtn];
    [self addSubview:self.largeMainBtn];
    [self addSubview:self.smallLeftBtn];
    [self addSubview:self.smallRightBtn];

    
}
- (void)setHasCollecte:(BOOL)hasCollecte{
    [self.saveBtn setSelected:hasCollecte];
}

- (void)layoutItems{
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 40));
        make.left.equalTo(@0).offset(4);
        make.top.equalTo(@0).offset(9);
    }];
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 40));
        make.left.equalTo(self.saveBtn.mas_right).offset(4);
        make.top.equalTo(@0).offset(9);
    }];

    [self.largeMainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.right.equalTo(@0).offset(-12);
        make.top.equalTo(@0).offset(9);
        make.left.equalTo(self.chatBtn.mas_right).offset(10);
    }];

    [self.smallLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(self.chatBtn.mas_right).offset(10);
        make.top.equalTo(@0).offset(9);
        make.right.equalTo(self.smallRightBtn.mas_left).offset(-8);
    }];
    [self.smallRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.right.equalTo(@0).offset(-12);
        make.top.equalTo(@0).offset(9);
        make.width.equalTo(self.smallLeftBtn);
    }];

}

- (void)refershStatusWithType:(JHC2CProductDetailBottomFunctionView_Type)type{
    self.type = type;
    self.largeMainBtn.enabled = YES;
    self.smallRightBtn.backgroundColor = HEXCOLOR(0xFFD70F);
    [self.smallRightBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
    [self.smallRightBtn setTitle:@"立即出价" forState:UIControlStateNormal];
    [self.largeMainBtn setTitle:@"立即购买" forState:UIControlStateNormal];

    switch (type) {
        case JHC2CProductDetailBottomFunctionView_Type_YiKouJia:
        {
            [self.smallRightBtn setTitle:@"立即购买" forState:UIControlStateNormal];
            self.largeMainBtn.hidden = NO;
            self.smallRightBtn.hidden = YES;
            self.smallLeftBtn.hidden = YES;
        }
            break;
        case JHC2CProductDetailBottomFunctionView_Type_PaiMaiZhong:
        {
            self.largeMainBtn.hidden = YES;
            self.smallRightBtn.hidden = NO;
            self.smallLeftBtn.hidden = NO;
        }
            break;
        case JHC2CProductDetailBottomFunctionView_Type_LingXian:
        {
            self.largeMainBtn.hidden = YES;
            self.smallRightBtn.hidden = NO;
            self.smallLeftBtn.hidden = NO;
            self.smallRightBtn.backgroundColor = HEXCOLOR(0xFF6A00);
            [self.smallRightBtn setTitle:@"您已领先" forState:UIControlStateNormal];
            [self.smallRightBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        }
            break;
        case JHC2CProductDetailBottomFunctionView_Type_ZhongPai:
        {
            self.largeMainBtn.hidden = NO;
            self.smallRightBtn.hidden = YES;
            self.smallLeftBtn.hidden = YES;
            [self.largeMainBtn setTitle:@"立即付款" forState:UIControlStateNormal];
        }
            break;
        case JHC2CProductDetailBottomFunctionView_Type_Finish:
        {
            [self.largeMainBtn setTitle:@"已结束" forState:UIControlStateNormal];

            self.largeMainBtn.hidden = NO;
            self.smallRightBtn.hidden = YES;
            self.smallLeftBtn.hidden = YES;
            self.largeMainBtn.enabled = NO;

        }
            break;
        case JHC2CProductDetailBottomFunctionView_Type_XiaJia:
        {
            [self.largeMainBtn setTitle:@"已下架" forState:UIControlStateNormal];

            self.largeMainBtn.hidden = NO;
            self.smallRightBtn.hidden = YES;
            self.smallLeftBtn.hidden = YES;
            self.largeMainBtn.enabled = NO;
        }
            break;
        case JHC2CProductDetailBottomFunctionView_Type_YiShouChu:
        {
            [self.largeMainBtn setTitle:@"已售出" forState:UIControlStateNormal];
            self.largeMainBtn.hidden = NO;
            self.smallRightBtn.hidden = YES;
            self.smallLeftBtn.hidden = YES;
            self.largeMainBtn.enabled = NO;
        }
            break;

        default:
            break;
    }
    
}


#pragma mark -- <set and get>
- (JHVButton *)saveBtn{
    if (!_saveBtn) {
        JHVButton *btn = [[JHVButton alloc] initWithImageTop:0 textBottom:0];
        btn.vImageView.image = [UIImage imageNamed:@"c2c_pd_xingxing"];
        btn.unseleImage = [UIImage imageNamed:@"c2c_pd_xingxing"];
        btn.seleImage =  [UIImage imageNamed:@"c2c_pd_xingxing_sel"];
        btn.vTextLbl.font = JHFont(12);
        btn.vTextLbl.text = @"收藏";
        btn.normalText = @"收藏";
        btn.seleteText = @"已收藏";
        btn.vTextLbl.textColor = HEXCOLOR(0x222222);
//        [btn addTarget:self action:@selector(closeActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn = btn;
    }
    return _saveBtn;
}


- (JHVButton *)chatBtn{
    if (!_chatBtn) {
        JHVButton *btn = [[JHVButton alloc] initWithImageTop:0 textBottom:0];
        btn.vImageView.image = [UIImage imageNamed:@"c2c_pd_chaticon"];
        btn.vTextLbl.font = JHFont(12);
        btn.vTextLbl.text = @"聊一聊";
        btn.vTextLbl.textColor = HEXCOLOR(0x222222);
//        [btn addTarget:self action:@selector(closeActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _chatBtn = btn;
    }
    return _chatBtn;
}

- (UIButton *)largeMainBtn{
    if (!_largeMainBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"立即购买" forState:UIControlStateNormal];
        btn.titleLabel.font = JHMediumFont(16);
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        btn.backgroundColor = HEXCOLOR(0xFFD70F);
        [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFD70F)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xD8D8D8)] forState:UIControlStateDisabled];
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        btn.hidden = YES;
//        [btn addTarget:self action:@selector(closeActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _largeMainBtn = btn;
    }
    return _largeMainBtn;
}
- (UIButton *)smallLeftBtn{
    if (!_smallLeftBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"设置代理出价" forState:UIControlStateNormal];
        btn.titleLabel.font = JHMediumFont(16);
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        btn.backgroundColor = UIColor.whiteColor;
        btn.layer.cornerRadius = 4;
        btn.layer.borderColor = HEXCOLOR(0xCCCCCC).CGColor;
        btn.layer.borderWidth = 0.5;
//        [btn addTarget:self action:@selector(closeActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _smallLeftBtn = btn;
    }
    return _smallLeftBtn;
}
- (UIButton *)smallRightBtn{
    if (!_smallRightBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"立即出价" forState:UIControlStateNormal];
        btn.titleLabel.font = JHMediumFont(16);
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        btn.backgroundColor = HEXCOLOR(0xFFD70F);
        btn.layer.cornerRadius = 4;
//        [btn addTarget:self action:@selector(closeActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _smallRightBtn = btn;
    }
    return _smallRightBtn;
}

@end
