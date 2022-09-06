//
//  JHShanGouTypeAlter.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/10/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHShanGouTypeAlter.h"


@interface JHShanGouTypeAlter()
@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) UIButton * closeBtn;
@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UIButton * listBtn;

@end

@implementation JHShanGouTypeAlter

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setItemsAndLayout{
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLbl];
    [self.backView addSubview:self.closeBtn];
    [self.backView addSubview:self.listBtn];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.equalTo(@270);
    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(16);
        make.centerX.equalTo(@0);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(@0).offset(10);
        make.right.equalTo(@0).offset(-10);
    }];

    UIView *lastView = self.titleLbl;
    for (int i = 0; i< self.flashCategories.count; i++) {
        ShanGouInfo *info = self.flashCategories[i];
        UIButton *btn = [self getOhterBtn];
        if ([info.name isEqualToString:@"常规订单"]) {
            btn = [self getFirstBtn];
        }
        [btn setTitle:info.name forState:UIControlStateNormal];
        [self.backView addSubview:btn];
        btn.tag = i;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom).offset(i == 0 ? 24 : 10);
            make.size.mas_equalTo(CGSizeMake(240, 38));
            make.centerX.equalTo(@0);
        }];
        lastView = btn;
    }
    [self.listBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(14);
        make.centerX.equalTo(@0);
        make.bottom.equalTo(@0).offset(-10);
    }];
    
}

- (void)setFlashCategories:(NSArray<ShanGouInfo *> *)flashCategories{
    NSMutableArray<ShanGouInfo *> *temArr = [NSMutableArray arrayWithCapacity:flashCategories.count];
    NSArray<NSString*> *keyArr = @[@"常规订单", @"加工订单", @"福利单"];
    for (int i = 0; i< keyArr.count; i++) {
        NSString* key = keyArr[i];
        __block ShanGouInfo * model = nil;
        [flashCategories enumerateObjectsUsingBlock:^(ShanGouInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.name isEqualToString:key]) {
                model = obj;
            }
        }];
        if (model) {
            [temArr addObject:model];
        }
    }
    _flashCategories = temArr.copy;
    [self setItemsAndLayout];
}


#pragma mark -- <action>

- (void)closeActionWithSender:(UIButton*)sender{
    [self removeFromSuperview];
}

- (void)actionWithSender:(UIButton*)sender{
    ShanGouInfo *info = self.flashCategories[sender.tag];
    if (self.seletedBlock) {
        self.seletedBlock(JHShanGouTypeAlter_CreatProduct, info.name, info.Id);
    }
    [self removeFromSuperview];
}

- (void)listActionWithSender:(UIButton*)sender{
    if (self.seletedBlock) {
        self.seletedBlock(JHShanGouTypeAlter_SeeList, nil, nil);
    }
    [self removeFromSuperview];
}


#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 5;
        _backView = view;
    }
    return _backView;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"fans_alert_close"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = btn;
    }
    return _closeBtn;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHBoldFont(16);
        label.text = @"闪购活动";
        label.textColor = HEXCOLOR(0x333333);
        _titleLbl = label;
    }
    return _titleLbl;
}


- (UIButton *)getFirstBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"常规订单" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = JHFont(15);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 19;
    [btn addTarget:self action:@selector(actionWithSender:) forControlEvents:UIControlEventTouchUpInside];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xFEE100).CGColor, (__bridge id)HEXCOLOR(0xFFC242).CGColor];
    gradientLayer.locations = @[@0, @1];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, 240, 38);
    [btn.layer insertSublayer:gradientLayer atIndex:0];
    return btn;
}

- (UIButton *)getOhterBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"加工订单" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = JHFont(15);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 19;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
    [btn addTarget:self action:@selector(actionWithSender:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


- (UIButton *)listBtn{
    if (!_listBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *att = [[NSAttributedString alloc] initWithString:@"闪购记录"
                                                                  attributes:@{NSFontAttributeName : JHFont(13),
                                                                               NSForegroundColorAttributeName :HEXCOLOR(0x2F66A0),
                                                                               NSUnderlineStyleAttributeName :  @(NSUnderlineStyleSingle)
                                                                  }];
        [btn setAttributedTitle:att forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(listActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _listBtn = btn;
                
    }
    return _listBtn;

}

@end
