//
//  YDBaseNavigationBar.m
//  TTjianbao
//
//  Created by wuyd on 2019/8/4.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "YDBaseNavigationBar.h"
#import "TTjianbaoHeader.h"

@implementation YDBaseNavigationBar

+ (instancetype)naviBar {
    YDBaseNavigationBar *naviBar = [[YDBaseNavigationBar alloc] init];
    return naviBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, ScreenWidth, UI.statusAndNavBarHeight);
    //背景
    _backgroundView = [[UIImageView alloc] init];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.clipsToBounds = YES;
    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_backgroundView];
    
    //左按钮
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.backgroundColor = [UIColor clearColor];
    [_leftBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self addSubview:_leftBtn];
    
    //右按钮
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.backgroundColor = [UIColor clearColor];
    _rightBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13.0];
    [_rightBtn setTitleColor:kColor222 forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    //[_rightBtn addTarget :self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
    
    //标题
    _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:18.0] textColor:kColor222];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    //副标题
    _subTitleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:10.0] textColor:kColor999];
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_subTitleLabel];
    _subTitleLabel.hidden = YES;
    
    //底部分割线
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = kColorCellLine;
    [self addSubview:_bottomLine];
    _bottomLine.hidden = YES;
    
    //布局
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(UI.statusBarHeight);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self).offset(UI.statusBarHeight);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftBtn.mas_right).offset(10.0);
        make.right.equalTo(_rightBtn.mas_left).offset(-10.0);
        make.top.equalTo(self).offset(UI.statusBarHeight);
        make.height.mas_equalTo(44.0);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.height.mas_equalTo(12);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    if (![subTitle isNotBlank]) {
        return;
    }
    
    _subTitle = subTitle;
    _subTitleLabel.hidden = NO;
    _subTitleLabel.text = subTitle;
    
    //存在副标题，更新布局
    _titleLabel.font = [UIFont fontWithName:kFontMedium size:15.0];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22.0);
    }];
    
    [_subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
    }];
}

- (void)setLeftImage:(UIImage *)leftImage {
    _leftImage = leftImage;
    [_leftBtn setImage:leftImage forState:UIControlStateNormal];
}

- (void)setRightImage:(UIImage *)rightImage {
    _rightImage = rightImage;
    [_rightBtn setImage:rightImage forState:UIControlStateNormal];
}

- (void)setRightTitle:(NSString *)rightTitle {
    _rightTitle = rightTitle;
    [_rightBtn setTitle:rightTitle forState:UIControlStateNormal];
}

- (void)showBackButton {
    _leftBtn.hidden = NO;
    _leftBtn.userInteractionEnabled = YES;
    [self setLeftImage:kNavBackBlackImg];
}

- (void)hideBackButton {
    _leftBtn.hidden = YES;
    _leftBtn.userInteractionEnabled = NO;
    [self setLeftImage:[UIImage imageNamed:@""]];
}

///设置中间自定义view
- (void)setTitleView:(UIView *)titleView {
    _titleView = titleView;
    if (!_titleView) {
        return;
    }
    [self addSubview:_titleView];
    CGFloat titleHeight = _titleView.height;
    CGFloat titleWidth = _titleView.width;
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.width.mas_equalTo(titleWidth);
        make.height.mas_equalTo(titleHeight);
        make.centerY.equalTo(self.leftBtn.mas_centerY);
    }];
}

@end
