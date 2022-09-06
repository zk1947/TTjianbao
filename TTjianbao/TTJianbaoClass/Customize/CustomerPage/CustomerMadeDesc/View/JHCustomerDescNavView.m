//
//  JHCustomerDescNavView.m
//  TTjianbao
//
//  Created by user on 2020/10/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerDescNavView.h"
#import "JHCustomizeDetailNavMoreView.h"
#import "JHCustomerDescPicCollectionViewCell.h"

@interface JHCustomerDescNavView ()
@property (nonatomic, strong) UIView                          *backView;
@property (nonatomic, strong) UIButton                        *backButton;
@property (nonatomic, strong) UIButton                        *shareButton;
@property (nonatomic,   copy) customerDescNavButtonClickBlock  cdBtnBlock;

@property (nonatomic, strong) JHCustomizeDetailNavMoreView    *moreView;
@end

@implementation JHCustomerDescNavView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _backView                       = [[UIView alloc] init];
    _backView.userInteractionEnabled = YES;
    [self addSubview:_backView];
    CGFloat statusBarHeight         = UI.statusBarHeight;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(statusBarHeight);
        make.left.right.bottom.equalTo(self);
    }];

    /// 返回按钮
    self.backButton                        = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:[UIImage imageNamed:@"navi_icon_back_white_shadow"] forState:UIControlStateNormal];
    [_backView addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.centerY.equalTo(self.backView.mas_centerY).offset(3.f);
        make.width.mas_equalTo(30.f);
        make.height.mas_equalTo(37.f);
    }];

    /// 分享按钮
    self.shareButton                       = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.selected              = NO;
    [self.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton setImage:[UIImage imageNamed:@"customize_desc_more_white"] forState:UIControlStateNormal];
    [_backView addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15.f);
        make.centerY.equalTo(self.backButton.mas_centerY);
        make.width.height.mas_equalTo(40.f);
    }];
    
    @weakify(self);
    self.moreView.shareActionBlock = ^{
        @strongify(self);
        if (self.cdBtnBlock) {
            self.cdBtnBlock(JHCustomerDescNavButtonStyle_Share);
        }
    };
    
    self.moreView.hiddenActionBlock = ^{
        @strongify(self);
        if (self.cdBtnBlock) {
            self.cdBtnBlock(JHCustomerDescNavButtonStyle_Hidden);
        }
    };
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self || ![self pointInside:point withEvent:event]) {
        return nil;
    }
    for (UIView *backView in self.subviews) {
        for (UIButton *btn in backView.subviews) {
            if (hitView == btn) {
                return hitView;
            }
        }
    }
    for (UICollectionView *collectionView in self.superview.subviews) {
        if([collectionView isKindOfClass:[UICollectionView class]]) {
            for (JHCustomerDescPicCollectionViewCell *cell in collectionView.visibleCells) {
                CGPoint subPoint = [self convertPoint:point toView:cell];
                UIButton *btn = (UIButton *)[cell hitTest:subPoint withEvent:event];
                if (btn) {
                    return btn;
                }
            }
        }
    }
    return hitView;
}



/// 点击返回
- (void)backButtonAction:(UIButton *)sender {
    if (self.cdBtnBlock) {
        self.cdBtnBlock(JHCustomerDescNavButtonStyle_Back);
    }
}

- (JHCustomizeDetailNavMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[JHCustomizeDetailNavMoreView alloc] init];
        _moreView.userInteractionEnabled = YES;
    }
    return _moreView;
}


/// 点击更多
- (void)shareButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
//    CGRect frame = CGRectMake(ScreenWidth - 40.f-30.f, self.center.y + 25.f, 46.f, 0);
    CGRect frameInBaseViewTarget = CGRectZero;
    
    CGFloat moreViewY = UI.isExistSafeArea? UI.statusAndNavBarHeight/2+15.f+25.f:UI.statusAndNavBarHeight/2+25.f;
    
    if (self.moreView.hasHiddenButton) {
        frameInBaseViewTarget = CGRectMake(ScreenWidth - 40.f - 30.f, moreViewY, 55.f, 81.f);
    } else {
        frameInBaseViewTarget = CGRectMake(ScreenWidth - 40.f - 30.f, moreViewY, 55.f, 30.f);
    }
    
    if (sender.selected) {
        UIWindow  *keyWindow = [UIApplication sharedApplication].delegate.window;
        [keyWindow addSubview:self.moreView];
        self.moreView.frame = frameInBaseViewTarget;

//        [UIView animateWithDuration:0.3 animations:^{
//            self.moreView.frame = frame;
//            [self.moreView layoutIfNeeded];
//        } completion:^(BOOL finished) {
//            self.moreView.frame = frameInBaseViewTarget;
//            self.moreView.clipsToBounds = NO;
//        }];
    } else {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.moreView.frame = frameInBaseViewTarget;
//            [self.moreView layoutIfNeeded];
//        } completion:^(BOOL finished) {
//            self.moreView.frame = frame;
            [self.moreView removeFromSuperview];
//        }];
    }
}

- (void)setNavImg:(BOOL)isChange {
    if (isChange) {
        /// 黑的
        self.shareButton.hidden = NO;
        [self.backButton setImage:[UIImage imageNamed:@"navi_icon_back_black"] forState:UIControlStateNormal];
        [self.shareButton setImage:[UIImage imageNamed:@"customize_desc_more_black"] forState:UIControlStateNormal];
    } else {
        self.shareButton.hidden = NO;
        [self.backButton setImage:[UIImage imageNamed:@"navi_icon_back_white_shadow"] forState:UIControlStateNormal];
        [self.shareButton setImage:[UIImage imageNamed:@"customize_desc_more_white"] forState:UIControlStateNormal];
    }
}

- (void)changeNavBackBlack:(BOOL)isChange {
    if (!isChange) {
        self.shareButton.hidden = YES;
        [self.backButton setImage:[UIImage imageNamed:@"navi_icon_back_black"] forState:UIControlStateNormal];
    } else {
        self.shareButton.hidden = NO;
        [self.backButton setImage:[UIImage imageNamed:@"navi_icon_back_white_shadow"] forState:UIControlStateNormal];
    }
}

- (void)removeNavSubViews {
    [self.moreView removeFromSuperview];
}

- (void)moreViewRelease {
    self.moreView = nil;
}

- (void)customerDescNavViewBtnAction:(customerDescNavButtonClickBlock)clickBlock {
    self.cdBtnBlock = clickBlock;
}

- (void)setMoreStatus:(BOOL)hasHidden {
    self.moreView.hasHidden = hasHidden;
}


- (void)showHiddenButton:(BOOL)isShow {
    self.moreView.hasHiddenButton = isShow;
}

@end
