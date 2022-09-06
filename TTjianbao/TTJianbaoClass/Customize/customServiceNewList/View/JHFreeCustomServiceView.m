//
//  JHFreeCustomServiceView.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHFreeCustomServiceView.h"
#import "UIView+JHGradient.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHCustomOrderView.h"
#import "JHCustomizeChooseListViewController.h"
#import "JHGrowingIO.h"
@interface JHFreeCustomServiceView()
/** 定制服务标签*/
@property (nonatomic, strong) UILabel *titleLabel;
/** 原料私人定制*/
@property (nonatomic, strong) UIButton *customButton;
/** 在线连麦沟通创意*/
@property (nonatomic, strong) UIButton *onlineButton;
/** 大师工艺*/
@property (nonatomic, strong) UIButton *masterButton;
/** 定制水印*/
@property (nonatomic, strong) UIImageView *customImageView;
/** 定制按钮*/
@property (nonatomic, strong) UIButton *customFreeButton;

@end
@implementation JHFreeCustomServiceView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        [self configUI];
    }
    return self;
}

- (void)configUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.customImageView];
    [self addSubview:self.customButton];
    [self addSubview:self.onlineButton];
    [self addSubview:self.masterButton];
    [self addSubview:self.customFreeButton];
}

#pragma mark --事件处理
/** 免费申请定制*/
- (void)freeCustomButtonClickAction{
    [JHGrowingIO trackEventId:JHTrackCustomizelive_sqdz_click];
    JHCustomizeChooseListViewController *Vc = [[JHCustomizeChooseListViewController alloc] init];
    Vc.from = @"dz_click";
    [self.viewController.navigationController pushViewController:Vc animated:YES];
}

#pragma mark --UI绘制
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, self.width - 20, 25)];
        _titleLabel.text = @"天天鉴宝 首创文玩定制服务";
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:18];
        _titleLabel.textColor = RGB515151;
    }
    return _titleLabel;
}

- (UIImageView *)customImageView{
    if (_customImageView == nil) {
        _customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 10 - 122, 5, 122, 61)];
        _customImageView.image = [UIImage imageNamed:@"customize_watermark_icon"];
    }
    return _customImageView;
}

- (UIButton *)customButton{
    if (_customButton == nil) {
        _customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _customButton.frame = CGRectMake(10, self.titleLabel.bottom + 10, 95, 17);
        [_customButton setImage:[UIImage imageNamed:@"custmoize_person_logo"] forState:UIControlStateNormal];
        [_customButton setTitle:@"原料私人订制" forState:UIControlStateNormal];
        _customButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_customButton setTitleColor:RGB153153153 forState:UIControlStateNormal];
        [_customButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
        _customButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _customButton;
}

- (UIButton *)onlineButton{
    if (_onlineButton == nil) {
        _onlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _onlineButton.frame = CGRectMake(self.customButton.right, self.customButton.top, 117, 17);
        [_onlineButton setImage:[UIImage imageNamed:@"custmoize_online_logo"] forState:UIControlStateNormal];
        [_onlineButton setTitle:@"在线连麦沟通创意" forState:UIControlStateNormal];
        _onlineButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_onlineButton setTitleColor:RGB153153153 forState:UIControlStateNormal];
        [_onlineButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
        _onlineButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _onlineButton;
}

- (UIButton *)masterButton{
    if (_masterButton == nil) {
        _masterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _masterButton.frame = CGRectMake(self.onlineButton.right, self.customButton.top, 69, 17);
        [_masterButton setImage:[UIImage imageNamed:@"custmoize_master_logo"] forState:UIControlStateNormal];
        [_masterButton setTitle:@"大师工艺" forState:UIControlStateNormal];
        _masterButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_masterButton setTitleColor:RGB153153153 forState:UIControlStateNormal];
        [_masterButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
        _masterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _masterButton;
}

- (UIButton *)customFreeButton{
    if (_customFreeButton == nil) {
        _customFreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _customFreeButton.frame = CGRectMake(10, self.customButton.bottom + 15, self.width - 10 * 2, 44);
        [_customFreeButton setTitle:@"申请定制" forState:UIControlStateNormal];
        _customFreeButton.titleLabel.font = [UIFont fontWithName:kFontBoldDIN size:16];
        [_customFreeButton setTitleColor:RGB515151 forState:UIControlStateNormal];
        [_customFreeButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xfed73a), HEXCOLOR(0xfecb33)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        _customFreeButton.layer.cornerRadius = 5;
        _customFreeButton.clipsToBounds = YES;
        [_customFreeButton addTarget:self action:@selector(freeCustomButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _customFreeButton;
}
@end
