//
//  JHUserAuthInfoCommitCell.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUserAuthInfoCommitCell.h"

@interface JHUserAuthInfoCommitCell ()
@property (nonatomic, strong) UIButton *button;

@end

@implementation JHUserAuthInfoCommitCell

- (void)setAuthState:(JHUserAuthState)authState {
    _authState = authState;
    if (authState == JHUserAuthStateUnPassed) {
        _button.jh_title(@"重新提交");
    }
    else {
        _button.jh_title(@"提交");
    }
}

- (void)addSelfSubViews {
    
    self.contentView.backgroundColor = APP_BACKGROUND_COLOR;
    
    UIButton *button = [UIButton jh_buttonWithBackgroundimage:@"my_center_userauth_commit" target:self action:@selector(commitClick) addToSuperView:self.contentView];
    _button = button;
    button.jh_fontNum(18).jh_title(@"提交").jh_titleColor(RGB515151);
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(279, 44));
    }];
    
    UILabel *tipLabel = [UILabel jh_labelWithText:@"天天鉴宝不会通过任何渠道泄漏您的个人信息请放心上传" font:12 textColor:RGB153153153 textAlignment:1 addToSuperView:self.contentView];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)commitClick {
    if(_commitBlock) {
        _commitBlock();
    }
}

+ (CGFloat)cellHeight {
    return 93.f;
}

@end
