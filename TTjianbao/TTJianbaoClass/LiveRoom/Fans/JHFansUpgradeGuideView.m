//
//  JHFansUpgradeGuideView.m
//  TTjianbao
//
//  Created by liuhai on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansUpgradeGuideView.h"
#import "UIView+JHGradient.h"
#import "JHFansEquityCollectionView.h"
#import "JHFansEquityListModel.h"
@interface JHFansUpgradeGuideView ()
@property(nonatomic,strong)JHFansEquityCollectionView * equityView;
@property(nonatomic,strong)UILabel * titleLabel;
@end

@implementation JHFansUpgradeGuideView

+ (instancetype)signAppealpopWindow{
    static JHFansUpgradeGuideView * appealPop = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appealPop  = [[self alloc] init];
    });
    return appealPop;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self creatAppealAlertView];
    }
    return self;
}

- (void)creatAppealAlertView{
    //fansUpgradeHead_bg   fansUpgradeStar
    UIView * view = [[UIView alloc] init];
    view.layer.cornerRadius = 5;
    view.backgroundColor = UIColor.whiteColor;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(314, 363));//323
    }];
    
    UIImageView *whiteView = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"fansUpgradeHead_bg"] addToSuperview:view];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(314, 93));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = JHFont(20);
    self.titleLabel.textColor = kColor333;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.top.equalTo(@45);
    }];
    
    UIImageView *stareView = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"fansUpgradeStar"] addToSuperview:view];
    [stareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(-80);
        make.size.mas_equalTo(CGSizeMake(152, 158));
        make.centerX.mas_equalTo(view.mas_centerX);
    }];
    
    self.equityView = [[JHFansEquityCollectionView alloc] init];
    self.equityView.backgroundColor = UIColor.whiteColor;
    [view addSubview:self.equityView];
    [self.equityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(93);
        make.height.mas_equalTo(200);
    }];
    
    UIButton *_joinFansGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _joinFansGroupBtn.layer.cornerRadius = 20;
    _joinFansGroupBtn.titleLabel.font = JHFont(15);
    [_joinFansGroupBtn setTitle:@"开心收下" forState:UIControlStateNormal];
    [_joinFansGroupBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [_joinFansGroupBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    [_joinFansGroupBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_joinFansGroupBtn];
    [_joinFansGroupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(view.mas_bottom).offset(-20);
        make.left.mas_equalTo(55);
        make.right.mas_equalTo(-55);
        make.height.mas_equalTo(40);
        
    }];
    
}
- (void)resetViewData:(JHFansEquityLVModel *)model{
    self.titleLabel.text = model.msgTitle;
    model.isget = YES;
    [self.equityView resetCollectWithModel:model];
}
- (void)show{
    UIView *alertSuperView = [UIApplication sharedApplication].keyWindow;
    [alertSuperView addSubview:self];
}
-(void)cancleAction{
    
    [self removeFromSuperview];
}


@end
