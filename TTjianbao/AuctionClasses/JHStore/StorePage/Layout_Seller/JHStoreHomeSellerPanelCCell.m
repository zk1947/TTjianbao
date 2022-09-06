//
//  JHStoreHomeSellerPanelCCell.m
//  TTjianbao
//
//  Created by wuyd on 2019/12/17.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeSellerPanelCCell.h"
#import "UIImageView+JHWebImage.h"
#import "UITapImageView.h"
#import "YYControl.h"
#import "UIView+CornerRadius.h"
#import "CStoreHomeListModel.h"
#import "JHShopHomeController.h"
#import "JHShopListViewController.h"


@interface JHStoreHomeSellerPanelCCell ()
@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) UITapImageView *avatarIcon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *followLabel;
@property (nonatomic, strong) UIButton *followBtn;

//最后一条数据的查看更多
//@property (nonatomic, strong) YYControl *loadMoreControl; //查看更多
@property (nonatomic, strong) UIButton *loadMoreBtn; //查看更多
@end


@implementation JHStoreHomeSellerPanelCCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configNormalUI];
        [self configLoadMoreUI];
    }
    return self;
}

- (void)configNormalUI {
    if (!_contentControl) {
        _contentControl = [YYControl new];
        _contentControl.backgroundColor = [UIColor whiteColor];
        _contentControl.layer.cornerRadius = 4;
        _contentControl.clipsToBounds = YES;
        _contentControl.exclusiveTouch = YES;
        [self.contentView addSubview:_contentControl];
        @weakify(self);
        _contentControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            @strongify(self);
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:self];
                if (CGRectContainsPoint(self.bounds, p)) {
//                    if (self.didSelectedItemBlock) { //点击事件
//                        self.didSelectedItemBlock(self.sellerData);
//                    }
                    [self enterShopHomeVC];
                }
            }
        };
    }
    
    //头像
    if (!_avatarIcon) {
        _avatarIcon = [UITapImageView new];
        //_avatarIcon.clipsToBounds = YES;
        _avatarIcon.contentMode = UIViewContentModeScaleAspectFill;
        [_contentControl addSubview:_avatarIcon];
        @weakify(self);
        [_avatarIcon addTapBlock:^(id  _Nonnull obj) {
            @strongify(self);
            [self enterShopHomeVC];
        }];
    }
    
    //标题
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontBoldPingFang size:12] textColor:kColor333];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_contentControl addSubview:_titleLabel];
    }
    
    //10人已关注
    if (!_followLabel) {
        _followLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:11] textColor:kColor999];
        _followLabel.textAlignment = NSTextAlignmentCenter;
        [_contentControl addSubview:_followLabel];
    }
    
    //关注
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithTitle:@"关注" titleColor:kColor333];
        _followBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:12];
        _followBtn.backgroundColor = kColorMain;
        [_contentControl addSubview:_followBtn];
        
        @weakify(self);
        [[_followBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            NSLog(@"关注");
            [self followBtnClicked];
        }];
    }
    
    //布局
    _contentControl.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    _avatarIcon.sd_layout
    .centerXEqualToView(_contentControl)
    .topSpaceToView(_contentControl, 12)
    .widthIs(65).heightEqualToWidth();
    _avatarIcon.sd_cornerRadiusFromHeightRatio = @0.5;
    
    _titleLabel.sd_layout
    .topSpaceToView(_avatarIcon, 7)
    .leftSpaceToView(_contentControl, 5)
    .rightSpaceToView(_contentControl, 5)
    .heightIs(18);
    
    _followLabel.sd_layout
    .topSpaceToView(_titleLabel, 12)
    .leftSpaceToView(_contentControl, 5)
    .rightSpaceToView(_contentControl, 5)
    .heightIs(18);
    
    _followBtn.sd_layout
    .topSpaceToView(_titleLabel, 8)
    .leftSpaceToView(_contentControl, 15)
    .rightSpaceToView(_contentControl, 15)
    .heightIs(26);
    _followBtn.sd_cornerRadiusFromHeightRatio = @0.5;
}

- (void)configLoadMoreUI {
    if (!_loadMoreBtn) {
        _loadMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loadMoreBtn.backgroundColor = [UIColor whiteColor];
        _loadMoreBtn.layer.cornerRadius = 4;
        _loadMoreBtn.clipsToBounds = YES;
        _loadMoreBtn.exclusiveTouch = YES;
        [_loadMoreBtn setImage:[UIImage imageNamed:@"store_icon_seller_more"] forState:UIControlStateNormal];
        [self.contentView addSubview:_loadMoreBtn];
        _loadMoreBtn.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        @weakify(self);
        [[_loadMoreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            NSLog(@"点击查看更多");
            [self enterShopListVC];
        }];
    }
    _loadMoreBtn.hidden = YES;
}

- (void)setSellerData:(CStoreHomeSellerData *)sellerData {
    _sellerData = sellerData;
    
    [_avatarIcon jhSetImageWithURL:[NSURL URLWithString:sellerData.head_img]
                                 placeholder:[UIImage imageNamed:@"icon_live_default_avatar"]];
    
    _titleLabel.text = sellerData.name;
    
    _followBtn.hidden = (sellerData.follow_status == 1);
    _followLabel.hidden = !(sellerData.follow_status == 1);
    
    [self __updateFollowText];
}

- (void)__updateFollowText {
    NSInteger fansNum = _sellerData.fans_num_int;
    NSString *fansNumStr = _sellerData.fans_num;
    NSString *followStr = _sellerData.desc.mutableCopy;
    
    if ([followStr hasPrefix:@"%s"]) {
        if (![fansNumStr isPureInt]) {
            followStr = [followStr stringByReplacingOccurrencesOfString:@"%s" withString:fansNumStr];
        } else {
            followStr = [followStr stringByReplacingOccurrencesOfString:@"%s" withString:@(fansNum).stringValue];
        }
    }
    _followLabel.text = followStr;
}

- (void)setIsLastItem:(BOOL)isLastItem {
    if (isLastItem) {
        _contentControl.hidden = YES;
        _loadMoreBtn.hidden = NO;
    } else {
        _contentControl.hidden = NO;
        _loadMoreBtn.hidden = YES;
    }
}


#pragma mark -
#pragma mark - 点击事件

//点击查看更多
- (void)enterShopListVC {
    JHShopListViewController *vc = [JHShopListViewController new];
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}

//点击头像
- (void)enterShopHomeVC {
    JHShopHomeController *vc = [JHShopHomeController new];
    vc.sellerId = _sellerData.seller_id;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}

//点击关注
- (void)followBtnClicked {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    
    [self.followBtn startQueryAnimate];
    
    NSString *urlStr = COMMUNITY_FILE_BASE_STRING(@"/v1/shop/follow_bus");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(_sellerData.seller_id) forKey:@"seller_id"];
    
    @weakify(self);
    [HttpRequestTool postWithURL:urlStr Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [self.followBtn stopQueryAnimate];
        [UITipView showTipStr:respondObject.message];
        
        self.sellerData.follow_status = 1;
        self.sellerData.fans_num_int += 1;
        self.followBtn.hidden = YES;
        self.followLabel.hidden = NO;
        
        [self __updateFollowText];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.followBtn stopQueryAnimate];
        [UITipView showTipStr:respondObject.message];
    }];
}

@end
