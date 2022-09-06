//
//  JHShopCollectionViewCell.m
//  TTjianbao
//
//  Created by lihui on 2020/3/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHShopCollectionViewCell.h"
#import "JHShopControlView.h"
#import "UserInfoRequestManager.h"

@interface JHShopCollectionViewCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) JHShopControlView *myShopView;
@property (nonatomic, strong) JHShopControlView *shopHomeView;
@property (nonatomic, strong) UIView *centerLine;
@property (nonatomic, strong) UIImageView *rowImageView;

@end


@implementation JHShopCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self initViews];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadShopInfo];
}

- (void)reloadShopInfo {
    User *user = [UserInfoRequestManager sharedInstance].user;
    if (user.blRole_communityShop ||
        user.blRole_communityAndSaleAnchor) {
        self.myShopView.title = @"我的店铺";
        _centerLine.hidden = NO;
        _shopHomeView.hidden = NO;
        _rowImageView.hidden = YES;
        ///布局
        [self.myShopView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView);
            make.top.bottom.equalTo(self.backView);
            make.right.equalTo(self.centerLine.mas_left).offset(-5);
        }];
        [self.shopHomeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backView);
            make.top.bottom.equalTo(self.backView);
            make.left.equalTo(self.centerLine.mas_right).offset(5);
        }];
    }
    else {
        self.myShopView.title = JHLocalizedString(@"myShop_lookEarnings");
        _centerLine.hidden = YES;
        _rowImageView.hidden = NO;
        self.shopHomeView.hidden = YES;
        [self.myShopView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView);
            make.top.bottom.equalTo(self.backView);
            make.right.equalTo(self.backView);
        }];
    }
}

- (void)initViews {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 8.f;
    view.layer.masksToBounds = YES;
    _backView = view;
    ///中间需要添加竖线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0x979797);
    _centerLine = line;
    ///右侧需要添加箭头
    UIImageView *rowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_my_arrow"]];
    rowImageView.contentMode = UIViewContentModeScaleAspectFit;
    _rowImageView = rowImageView;
    
    [self.contentView addSubview:view];
    [view addSubview:self.myShopView];
    [view addSubview:self.shopHomeView];
    [view addSubview:line];
    [view addSubview:rowImageView];
    
    ///布局
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(1, 15));
    }];
    
    [self.myShopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.top.bottom.equalTo(view);
        make.right.equalTo(line.mas_left).offset(-5);
    }];

    [self.shopHomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view);
        make.top.bottom.equalTo(view);
        make.left.equalTo(line.mas_right).offset(5);
    }];

    [rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-15);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
}

- (JHShopControlView *)myShopView {
    if (!_myShopView) {
        _myShopView = [[JHShopControlView alloc] init];
        _myShopView.exclusiveTouch = YES;
        _myShopView.layer.cornerRadius = 8.f;
        _myShopView.layer.masksToBounds = YES;
        _myShopView.icon = @"icon_my_shop_img";
        _myShopView.title = JHLocalizedString(@"myShop_lookEarnings");
        _myShopView.backgroundColor = HEXCOLOR(0xffffff);
        _myShopView.controlAlignment = JHShopControlViewAlignmentLeft;
        @weakify(self);
        _myShopView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            @strongify(self);
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:self];
                if (CGRectContainsPoint(self.bounds, p)) {
                    if (self.myShopBlock) {
                        self.myShopBlock();
                    }
                }
            }
        };
    }
    return _myShopView;
}

///店铺主页
- (JHShopControlView *)shopHomeView {
    if (!_shopHomeView) {
        _shopHomeView = [[JHShopControlView alloc] init];
        _shopHomeView.exclusiveTouch = YES;
        _shopHomeView.layer.cornerRadius = 8.f;
        _shopHomeView.layer.masksToBounds = YES;
        _shopHomeView.backgroundColor = HEXCOLOR(0xffffff);
        _shopHomeView.icon = @"icon_my_shop_home";
        _shopHomeView.title = JHLocalizedString(@"shopHome");
        _shopHomeView.controlAlignment = JHShopControlViewAlignmentRight;
        @weakify(self);
        _shopHomeView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            @strongify(self);
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:self];
                if (CGRectContainsPoint(self.bounds, p)) {
                    if (self.shopHomeBlock) {
                        self.shopHomeBlock();
                    }
                }
            }
        };
    }
    return _shopHomeView;
}

@end
