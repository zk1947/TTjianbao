//
//  JHPublishReportRecommendCell.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPublishReportRecommendCell.h"
#import "JHSwitch.h"

@interface JHPublishReportRecommendCell ()

@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, weak) JHSwitch *switchView;

@end

@implementation JHPublishReportRecommendCell

- (void)addSelfSubViews {
    UILabel *label = [UILabel jh_labelWithText:@"是否推荐" font:16 textColor:RGB(34,34,34) textAlignment:0 addToSuperView:self.contentView];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    JHSwitch *switchView = [[JHSwitch alloc] initWithSize:(CGSizeMake(42, 24))];
    switchView.on = NO;
    [switchView addTarget:self action:@selector(switchMthod:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:switchView];
    [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
    _switchView = switchView;
    
    _lineView = [UIView jh_viewWithColor:RGB(228, 228, 228) addToSuperview:self.contentView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    _lineView.hidden = YES;
}

- (void)setLineHidden:(BOOL)lineHidden {
    _lineHidden = lineHidden;
    _lineView.hidden = _lineHidden;
}

- (void)setIsRecommend:(BOOL)isRecommend {
    _isRecommend = isRecommend;
    _switchView.on = _isRecommend;
}
- (void)switchMthod:(JHSwitch *)sender {
    if(_switchBlock) {
        _switchBlock(sender.isOn);
    }
}

@end
