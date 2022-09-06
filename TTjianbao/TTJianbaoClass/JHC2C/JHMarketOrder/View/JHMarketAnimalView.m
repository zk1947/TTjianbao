//
//  JHMarketAnimalView.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketAnimalView.h"
#import "JHMarketOrderViewModel.h"

@interface JHMarketAnimalView()
/** 区域*/
@property (nonatomic, strong) UIView *areaView;
/** 动态区间*/
@property (nonatomic, strong) UIView *animalView;
/** 动态图*/
@property (nonatomic, strong) UIImageView *animalImageView;
@end

@implementation JHMarketAnimalView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)highLightButtonClick {
    if (self.exposeButton.selected) {
        return;
    }
    [SVProgressHUD show];
    [JHMarketOrderViewModel highlightPublishList:[NSMutableDictionary dictionary] Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [SVProgressHUD dismiss];
        if (!error) {
            JHTOAST(@"已擦亮");
            [NSNotificationCenter.defaultCenter postNotificationName:@"JHMarketAnimalView_refersh" object:nil];
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

- (void)configUI {
    [self addSubview:self.areaView];
    [self.areaView addSubview:self.animalView];
    [self.animalView addSubview:self.animalImageView];
    [self.animalView addSubview:self.scoreLabel];
    [self.animalView addSubview:self.exposeLabel];
    [self.areaView addSubview:self.exposeButton];
    
    [self.areaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
    }];
    
    [self.animalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.areaView).offset(13);
        make.centerX.mas_equalTo(self.areaView);
        make.width.mas_equalTo(192);
        make.height.mas_equalTo(127);
    }];
    
    [self.animalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.animalView);
    }];
    
    [self.exposeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.animalView).offset(-10);
        make.centerX.mas_equalTo(self.animalView);
        make.height.mas_equalTo(17);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.exposeLabel.mas_top);
        make.centerX.mas_equalTo(self.animalView);
        make.height.mas_equalTo(51);
    }];
    
    [self.exposeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.animalView.mas_bottom);
        make.centerX.mas_equalTo(self.areaView);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(30);
    }];
}

- (UIView *)areaView {
    if (_areaView == nil) {
        _areaView = [[UIView alloc] init];
        _areaView.backgroundColor = HEXCOLOR(0xffffff);
        _areaView.layer.cornerRadius = 8;
        _areaView.clipsToBounds = YES;
    }
    return _areaView;
}

- (UIView *)animalView {
    if (_animalView == nil) {
        _animalView = [[UIView alloc] init];
    }
    return _animalView;
}

- (UIImageView *)animalImageView {
    if (_animalImageView == nil) {
        _animalImageView = [[UIImageView alloc] init];
        _animalImageView.image = [UIImage imageNamed:@"c2c_publish_score_animal"];
    }
    return _animalImageView;
}

- (UILabel *)scoreLabel {
    if (_scoreLabel == nil) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = HEXCOLOR(0x333333);
        _scoreLabel.font = [UIFont fontWithName:kFontBoldDIN size:44];
        _scoreLabel.text = @"0";
    }
    return _scoreLabel;
}

- (UILabel *)exposeLabel {
    if (_exposeLabel == nil) {
        _exposeLabel = [[UILabel alloc] init];
        _exposeLabel.textColor = HEXCOLOR(0x333333);
        _exposeLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _exposeLabel.text = @"今日曝光";
    }
    return _exposeLabel;
}

- (UIButton *)exposeButton {
    if (_exposeButton == nil) {
        _exposeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exposeButton setTitle:@"今日未擦亮" forState:UIControlStateNormal];
        [_exposeButton setTitle:@"今日已擦亮" forState:UIControlStateSelected];
        _exposeButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [_exposeButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_exposeButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffd70f)] forState:UIControlStateNormal];
        [_exposeButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffed92)] forState:UIControlStateSelected];
        _exposeButton.layer.cornerRadius = 15;
        _exposeButton.clipsToBounds = YES;
        [_exposeButton addTarget:self action:@selector(highLightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exposeButton;
}



@end
