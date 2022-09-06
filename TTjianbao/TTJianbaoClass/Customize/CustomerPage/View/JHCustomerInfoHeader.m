//
//  JHCustomerInfoHeader.m
//  TTjianbao
//
//  Created by lihui on 2020/9/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerInfoHeader.h"
#import "JHCustomerSectionHeader.h"
#import "JHCustomerFeeDescTableCell.h"
#import "JHCustomerIntroducationCell.h"
#import "JHCustomerMasterpieceTableViewCell.h"
#import "JHCustomerHonorCerTableViewCell.h"
#import "JHCustomizeStuffCagetoryInfoTableViewCell.h"

#import "JHCustomerBriefController.h"
#import "JHCustomerFeeEditController.h"
#import "JHCustomerMpEditViewController.h"
#import "JHCustomerCerEditViewController.h"

#import "JHCUstomizeUserInfoView.h"
#import "JHLiveRoomModel.h"
#import "JHLiveRoomApiManger.h"
#import "JHGrowingIO.h"
#import "CommAlertView.h"
#import "CommHelp.h"
#import "UIView+CornerRadius.h"
#import "UIImageView+JHWebImage.h"
#import "UIView+JHGradient.h"
#import "JHRootViewController+TransitPage.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHCustomerIntroduceController.h"
#import "JHPostDtailEnterTableCell.h"
#import "JHCustomerAssoicateBlankCell.h"
#import "JHNewShopDetailViewController.h"
#import "JXPagerMainTableView.h"
#import "JHGrowingIO.h"
#import "JHCustomizeStuffDetailController.h"
#import "JHFansListView.h"
#define MAX_ARCHOR_COUNT        8
#define PARAMS_MARGIN           (47.f)
#define HEADER_INFO_HEIGHT      (175.f)
#define HEADER_IMAGE_HEIGHT     (205.f)
#define SHOP_LIVEROOM_HEIGHT    (78.f)
#define MASTER_PIECE_HEIGHT     (205.f)
#define HORNOR_CER_HEIGHT       (132.5f)

@interface JHCustomerInfoHeader () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView           *headerImageView;
///底部展示用户信息的view
@property (nonatomic, strong) UIView                *infoView;
@property (nonatomic, strong) UIView                *iconView;
@property (nonatomic, strong) UIImageView           *iconImageView;
@property (nonatomic, strong) UIView                *iconBorderView;
@property (nonatomic, strong) YYAnimatedImageView   *liveGifView;

@property (nonatomic, strong) UILabel               *nickNameLabel;
@property (nonatomic, strong) UILabel               *jobTitleLabel; /// 宝友号
@property (nonatomic, strong) UIButton              *followButton;
@property (nonatomic, strong) JHCUstomizeUserInfoView  *fansView;
@property (nonatomic, strong) JHCUstomizeUserInfoView  *followView;
@property (nonatomic, strong) JHCUstomizeUserInfoView  *likeView;
@property (nonatomic, strong) JHCUstomizeUserInfoView  *exepView;
@property (nonatomic, strong) JHCUstomizeUserInfoView *fansClubView;
@property (nonatomic, strong) UIVisualEffectView    *effectView;
///展示直播间介绍和主播介绍
@property (nonatomic, strong) JXPagerMainTableView  *infoTableView;
@property (nonatomic, assign) CGRect                 headerImageFrame;
@property (nonatomic, assign) CGFloat                liveRoomHeight;
///是否显示全部主播
@property (nonatomic, assign) BOOL                   isShowAll;
@property (nonatomic, strong) UIButton              *showAllButton;
///认证定制师标识
@property (nonatomic, strong) UIButton              *autherationButton;

@end

@implementation JHCustomerInfoHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorF5F6FA;
        _isShowAll = NO;
        [self setupViews];
    }
    return self;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect           = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.alpha               = 0.8;
        _effectView = effectView;
    }
    return _effectView;
}

- (void)setupViews {
    _headerImageView = [[UIImageView alloc] initWithImage:kDefaultCoverImage];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.clipsToBounds = YES;
    [self addSubview:_headerImageView];
    [_headerImageView addSubview:self.effectView];
    self.effectView.hidden = YES;
    
    _infoView = [[UIView alloc] init];
    _infoView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_infoView];
    
    _iconView = [[UIView alloc] init];
    _iconView.backgroundColor = [UIColor whiteColor];
    [_infoView addSubview:_iconView];
    _iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewClickAction)];
    [_iconView addGestureRecognizer:tap];
    
    
    _iconImageView = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.userInteractionEnabled = YES;
    [_iconView addSubview:_iconImageView];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewClickAction)];
    [_iconImageView addGestureRecognizer:tap1];

    
    _iconBorderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mall_like_circle_img"]];
    _iconBorderView.userInteractionEnabled = YES;
    [_infoView addSubview:_iconBorderView];
    _iconBorderView.hidden = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewClickAction)];
    [_iconBorderView addGestureRecognizer:tap2];


    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_on_live" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    YYImage *image = [YYImage imageWithData:data];
    _liveGifView = [[YYAnimatedImageView alloc] initWithImage:image];
    _liveGifView.contentMode = UIViewContentModeScaleAspectFit;
    [_infoView addSubview:_liveGifView];
    _liveGifView.hidden = YES;

    _nickNameLabel = [[UILabel alloc] init];
    _nickNameLabel.textColor = kColor333;
    _nickNameLabel.font = [UIFont fontWithName:kFontMedium size:22];
    [self addSubview:_nickNameLabel];
    
    _jobTitleLabel = [[UILabel alloc] init];
    _jobTitleLabel.textColor = kColor999;
    _jobTitleLabel.font = [UIFont fontWithName:kFontNormal size:11.f];
    [self addSubview:_jobTitleLabel];
    
    _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _followButton.backgroundColor = kColorMain;
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    _followButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:12];
    [_followButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_followButton addTarget:self action:@selector(followEventAction) forControlEvents:UIControlEventTouchUpInside];
    [self gradientColorForFollowButton:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)]];
    [_infoView addSubview:_followButton];
    
    _autherationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_autherationButton setTitleColor:kColor666 forState:UIControlStateNormal];
    _autherationButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:11];
    [_infoView addSubview:_autherationButton];
    
    _fansView = [[JHCUstomizeUserInfoView alloc] init];
    [_fansView setTitle:@"粉丝" value:@"0"];
    [_infoView addSubview:_fansView];
    
    _followView = [[JHCUstomizeUserInfoView alloc] init];
    [_followView setTitle:@"获赞" value:@"0"];
    [_infoView addSubview:_followView];

    _likeView = [[JHCUstomizeUserInfoView alloc] init];
    [_likeView setTitle:@"评价" value:@"0"];
    [_infoView addSubview:_likeView];

    _exepView = [[JHCUstomizeUserInfoView alloc] init];
    [_exepView setTitle:@"好评度" value:@"0"];
    [_infoView addSubview:_exepView];
    
    _fansClubView = [[JHCUstomizeUserInfoView alloc] init];
    [_fansClubView setTitle:@"粉丝团" value:@"0"];
    [_infoView addSubview:_fansClubView];
    
    @weakify(self);
    _fansClubView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (state == YYGestureRecognizerStateEnded) {
        
            if (self.roomInfo.showButton&&
                _roomInfo.fansClubId &&
                [_roomInfo.fansClubId intValue] != -1){
                JHFansListView  *fansListView = [[JHFansListView alloc]init];
                fansListView.anchorId = self.roomInfo.anchorId;
                [JHKeyWindow addSubview:fansListView];
                [fansListView show];
                [fansListView loadNewData];
            }
        }
    };
    
    [self addSubview:self.infoTableView];
        
    [self makeLayouts];
    
//    _infoTableView.backgroundColor = [UIColor greenColor];

    [self.infoTableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        NSLog(@"change:---- %@", change);
        CGFloat tableHeight = self.infoTableView.contentSize.height;
        CGFloat finalHeight = kHeightOfCommonHeader;
        if (isEmpty(_roomInfo.customizeTitle)) {
            finalHeight = kHeightOfCommonHeader -  26.f;
        }
        if (_roomInfo.fees.count > MAX_ARCHOR_COUNT) {
            finalHeight = finalHeight + 10.f;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kChangeCustomerHeaderHeightNotification object:@{@"tableHeight":@(tableHeight+finalHeight)}];
        [self.infoTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(tableHeight);
        }];
    }
}

- (void)showAllCustomerFees {
    _isShowAll = !_showAllButton.selected;
    [self.infoTableView reloadData];
    _showAllButton.selected = _isShowAll;
    [_showAllButton layoutIfNeeded];
}

- (void)gradientColorForFollowButton:(NSArray <UIColor *>*)colors {
    [_followButton jh_setGradientBackgroundWithColors:colors locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}

- (void)iconViewClickAction {
    if (self.iconActionBlock) {
        self.iconActionBlock();
    }
}

- (void)makeLayouts {
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self);
        make.height.mas_equalTo(HEADER_IMAGE_HEIGHT);
    }];
    
    [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headerImageView);
    }];
        
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(HEADER_IMAGE_HEIGHT-15);
        make.leading.trailing.equalTo(self);
        make.height.mas_equalTo(200.f);
    }];
        
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.infoView).offset(15);
        make.centerY.equalTo(self.infoView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconView).insets(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
    
    ///黄圈的view
    [_iconBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconView).insets(UIEdgeInsetsMake(-2, -2, -2, -2));
    }];

    [_liveGifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconImageView);
        make.bottom.equalTo(self.iconImageView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoView).offset(15);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(15);
        make.right.equalTo(self.infoView).offset(-10);
    }];
    
    [_jobTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel.mas_left);
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(6.f);
        make.height.mas_equalTo(16.f);
        make.right.equalTo(self.infoView).offset(-10);
    }];
    
    [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.infoView).offset(-15);
        make.top.equalTo(self.infoView).offset(10);
        make.size.mas_equalTo(CGSizeMake(146, 30));
    }];
    
    [_autherationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jobTitleLabel.mas_bottom).offset(6.f);
        make.left.equalTo(self.nickNameLabel).offset(-1.f);
        make.width.mas_equalTo(75.f);
        make.height.mas_equalTo(16.f);
    }];
            
    
    [_fansView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoView.mas_left).offset(16);
        make.bottom.equalTo(self.infoView.mas_bottom).offset(-15);
    }];
        
    [_followView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fansView.mas_right).offset(PARAMS_MARGIN);
        make.bottom.equalTo(self.fansView);
    }];
    
    [_likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followView.mas_right).offset(PARAMS_MARGIN);
        make.bottom.equalTo(self.followView);
    }];
    
    [_exepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeView.mas_right).offset(PARAMS_MARGIN);
        make.bottom.equalTo(self.likeView);
    }];
    
    [_fansClubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.exepView.mas_right).offset(PARAMS_MARGIN);
        make.bottom.equalTo(self.exepView);
    }];
    
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.infoView.mas_bottom);
        make.height.mas_equalTo(0);
    }];

    [self layoutIfNeeded];
    [_infoView yd_setCornerRadius:12 corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    
    _iconImageView.layer.cornerRadius =_iconImageView.height/2.f;
    _iconImageView.clipsToBounds = YES;
    _iconView.layer.cornerRadius = 40.f;
    [_iconView setLayerShadow:HEXCOLORA(0x000000,.2f) offset:CGSizeMake(0, 3) radius:5.f];
    
    _followButton.layer.cornerRadius = _followButton.height/2;
    _followButton.layer.masksToBounds = YES;
    _headerImageFrame = _headerImageView.frame;
    [self sendSubviewToBack:_headerImageView];
    [_autherationButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3.];
}


- (void)setRoomInfo:(JHLiveRoomModel *)roomInfo {
    if (!roomInfo) {
        return;
    }
    
    _roomInfo = roomInfo;
    _liveRoomHeight = _roomInfo.roomDesHeight+15;
    [_headerImageView jhSetImageWithURL:[NSURL URLWithString:_roomInfo.avatar] placeholder:kDefaultCoverImage];
    self.effectView.hidden = NO;
    [_iconImageView jhSetImageWithURL:[NSURL URLWithString:_roomInfo.avatar] placeholder:kDefaultAvatarImage];
    _nickNameLabel.text = [_roomInfo.name isNotBlank]?_roomInfo.name:@"暂无昵称";
    if (!isEmpty(_roomInfo.customizeTitle)) {
        _jobTitleLabel.text = _roomInfo.customizeTitle;
        [_jobTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nickNameLabel.mas_bottom).offset(10.f);
            make.height.mas_equalTo(16.f);
        }];
        [_infoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(200.f);
        }];
    } else {
        [_jobTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nickNameLabel.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0.f);
        }];
        [_infoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(200.f - 16.f - 10.f);
        }];
    }
    
    [_autherationButton setImage:[UIImage imageNamed:@"customize_authen_icon"] forState:UIControlStateNormal];
    [_autherationButton setTitle:@"认证定制师" forState:UIControlStateNormal];
    
//    BOOL isUserSelf = [self.roomInfo.anchorId isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId];
    BOOL isUserSelf = self.roomInfo.showButton;
    if (isUserSelf) {
        /// 当前是主播
        [self gradientColorForFollowButton:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)]];
        [_followButton setTitle:@"编辑资料" forState:UIControlStateNormal];
        [_followButton setTitleColor:kColor333 forState:UIControlStateNormal];
        [_followButton setTitleColor:kColor333 forState:UIControlStateHighlighted];
        _followButton.hidden = YES;
    } else {
        _followButton.hidden = NO;
        ///关注按钮
        if (_roomInfo.isFollow) {
            [self gradientColorForFollowButton:@[kColorEEE, kColorEEE]];
            [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
            [_followButton setTitleColor:kColor999 forState:UIControlStateNormal];
            [_followButton setTitleColor:kColor999 forState:UIControlStateHighlighted];
        } else {
            [self gradientColorForFollowButton:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)]];
            [_followButton setTitle:@"关注" forState:UIControlStateNormal];
            [_followButton setTitleColor:kColor333 forState:UIControlStateNormal];
            [_followButton setTitleColor:kColor333 forState:UIControlStateHighlighted];
        }
    }
    
    _fansView.value     = [CommHelp convertNumToWUnitString:_roomInfo.fansNum existDecimal:YES];
    _followView.value   = [CommHelp convertNumToWUnitString:_roomInfo.thumbsUpNum existDecimal:YES];
    _likeView.value     = [CommHelp convertNumToWUnitString:_roomInfo.commentNum existDecimal:YES];
    _exepView.value     = _roomInfo.commentGrade;
   
    
    if (_roomInfo.fansClubId && [_roomInfo.fansClubId intValue] != -1) {
        _fansClubView.value = _roomInfo.fansCount;
    }
    else{
        _fansClubView.value = @"未开通";
    }
    
    //直播状态
    BOOL isLiving = (_roomInfo.channelStatus == 2);
    _liveGifView.hidden    = !isLiving;
    _iconBorderView.hidden = !isLiving;
    _iconImageView.userInteractionEnabled = isLiving;
    
    self.userIcon = _iconImageView.image;
    self.userName = _nickNameLabel.text;
    self.userDesc = NONNULL_STR(_roomInfo.customizeTitle);
    [self.infoTableView reloadData];
}


#pragma mark -
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.infoTableView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BOOL isUserSelf = self.roomInfo.showButton;
    if (isUserSelf) {
        if (section == 0) {
            if (self.roomInfo.shopId > 0 && self.roomInfo.materialChannelId > 0) {
                return 2;
            }
            return 1;
        }
        return 1;
    } else {
        if (section == 0) {
            if (self.roomInfo.shopId > 0 && self.roomInfo.materialChannelId > 0) {
                return 2;
            }
            return 1;
        }
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    BOOL isUserSelf = self.roomInfo.showButton;
    if (isUserSelf) {
        return 6;
    } else {
        if (self.roomInfo.shopId > 0 || self.roomInfo.materialChannelId > 0) {
            return 6;
        }
        return 5;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHCustomerInfoType type = [self getCustomerHeaderTypeWithSection:indexPath.section];
    BOOL isUserSelf = self.roomInfo.showButton;
    switch (type) {
        case JHCustomerInfoTypeShopAndLiveRoom: {///我的店铺 & 关联直播间 入口
            if (isUserSelf) { /// 主播侧
                return SHOP_LIVEROOM_HEIGHT;
            } else {
                if (indexPath.row == 0) {
                    if (self.roomInfo.shopId > 0 || self.roomInfo.materialChannelId > 0) {
                        return SHOP_LIVEROOM_HEIGHT;
                    } else {
                        return 0;
                    }
                }
                if (indexPath.row == 1 && self.roomInfo.materialChannelId > 0) {
                    return SHOP_LIVEROOM_HEIGHT;
                }
                return 0;
            }
        }
            break;
        case JHCustomerInfoTypeCustomerIntroducation:  ///定制师介绍
            {
                return [self.roomInfo.customizeIntro isNotBlank] ?
                _liveRoomHeight :
                (self.roomInfo.showButton ? 15.f : 50.f);
            }
            break;
        case JHCustomerInfoTypeMasterpiece:  { /// 代表作
            if (self.roomInfo.showButton) {
                CGFloat cellHeight = self.roomInfo.opusList.count>0 ?205.f : 20.f;
                return cellHeight;
            } else {
                CGFloat cellHeight = self.roomInfo.opusList.count>0 ?205.f : 0.f;
                return cellHeight;
            }
        }
        case JHCustomerInfoTypeHonorCer: { /// 荣誉证书
            if (self.roomInfo.showButton) {
                CGFloat cellHeight = self.roomInfo.certificateList.count>0 ?132.5f : 20.f;
                return cellHeight;
            } else {
                CGFloat cellHeight = self.roomInfo.certificateList.count>0 ?132.5f : 0.f;
                return cellHeight;
            }
        }
        case JHCustomerInfoTypeStuffCagetory: { /// 可定制材质
            if (self.roomInfo.showButton) {
                CGFloat cellHeight = self.roomInfo.materials.count>0 ?51.f : 20.f;
                return cellHeight;
            } else {
                CGFloat cellHeight = self.roomInfo.materials.count>0 ?51.f : 0.f;
                return cellHeight;
            }
        }
        case JHCustomerInfoTypeCustomizeFeeIntroducation: ///定制费用说明
            {
                ///添加定制服务说明
//                if (!isUserSelf) {
//                    NSArray *feeArray = [self getCustomerFeesData];
//                    if (feeArray.count >0) {
//                        CGFloat cellHeight = ceil(feeArray.count/2.)*50.f + 20;
//                        return cellHeight;
//                        return  35.f;
//                    } else {
//                        return  0.f;
//                    }
//                } else {
                    NSArray *feeArray = [self getCustomerFeesData];
                    CGFloat cellHeight = ceil(feeArray.count/2.)*50.f + 20;
                    return cellHeight;
//                }
            }
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BOOL isUserSelf = self.roomInfo.showButton;
    if (!isUserSelf && section == 0 && (!(self.roomInfo.shopId > 0 || self.roomInfo.materialChannelId > 0))) { /// 用户侧
        UIView *instroView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 45)];
        instroView.backgroundColor = kColorF5F6FA;
        JHCustomerSectionHeader *header = [[JHCustomerSectionHeader alloc] initWithFrame:CGRectMake(0, 10, ScreenW, 35) isShowEdit:self.roomInfo.showButton section:section];
        header.backgroundColor = HEXCOLOR(0xffffff);
        header.sectionTitle = [self sectionTitleBySection:section];
        [header reloadApplayStatus:header.sectionTitle];
        @weakify(self);
        header.actionBlock = ^(NSInteger section) {
            @strongify(self);
            [self handleSectionHeaderEvent:section];
        };
        [instroView addSubview:header];
        return instroView;
    }
    
    JHCustomerInfoType type = [self getCustomerHeaderTypeWithSection:section];
    if (type != JHCustomerInfoTypeShopAndLiveRoom) {
        JHCustomerSectionHeader *header = [[JHCustomerSectionHeader alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 35) isShowEdit:self.roomInfo.showButton section:section];
        header.sectionTitle = [self sectionTitleBySection:section];
        [header reloadApplayStatus:header.sectionTitle];
        @weakify(self);
        header.actionBlock = ^(NSInteger section) {
            @strongify(self);
            [self handleSectionHeaderEvent:section];
        };
        return header;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    JHCustomerInfoType type = [self getCustomerHeaderTypeWithSection:section];
    if (type == JHCustomerInfoTypeHonorCer) {
        if (self.roomInfo.showButton) {
            return 35.f;
        } else {
            if (self.roomInfo.certificateList.count >0) {
                return 35.f;
            } else {
                return 0.f;
            }
        }
    }
    if (type == JHCustomerInfoTypeMasterpiece) {
        if (self.roomInfo.showButton) {
            return 35.f;
        } else {
            if (self.roomInfo.opusList.count >0) {
                return 35.f;
            } else {
                return 0.f;
            }
        }
    }
    
    if (type == JHCustomerInfoTypeStuffCagetory) {
        if (self.roomInfo.showButton) {
            return 35.f;
        } else {
            if (self.roomInfo.materials.count >0) {
                return 35.f;
            } else {
                return 0.f;
            }
        }
    }
    
    
    
    
    
    
//    BOOL isUserSelf = self.roomInfo.showButton;
//    if (!isUserSelf && type == JHCustomerInfoTypeCustomizeFeeIntroducation) {
//        NSArray *feeArray = [self getCustomerFeesData];
//        if (feeArray.count >0) {
//            return  35.f;
//        } else {
//            return  0.f;
//        }
//    }
    
    if (type != JHCustomerInfoTypeShopAndLiveRoom) {
        return  35.f;
    }
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    JHCustomerInfoType type = [self getCustomerHeaderTypeWithSection:section];
    if (type == JHCustomerInfoTypeCustomizeFeeIntroducation &&
        self.roomInfo.fees.count > MAX_ARCHOR_COUNT) {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
        
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = kColorF5F6FA;
        backView.frame = footer.bounds;
        [footer addSubview:backView];

        UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        allButton.backgroundColor = HEXCOLOR(0xffffff);
        allButton.frame = CGRectMake(0, 0, ScreenW, 50);
        [allButton setTitle:@"展开" forState:UIControlStateNormal];
        [allButton setTitle:@"收起" forState:UIControlStateSelected];
        [allButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [allButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateSelected];
        [allButton setImage:[UIImage imageNamed:@"customize_icon_anchor_arrow_down"] forState:UIControlStateNormal];
        [allButton setImage:[UIImage imageNamed:@"customize_icon_anchor_arrow_up"] forState:UIControlStateSelected];
        allButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
        [backView addSubview:allButton];
        [allButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [allButton addTarget:self action:@selector(showAllCustomerFees) forControlEvents:UIControlEventTouchUpInside];
        allButton.selected = _isShowAll;
        _showAllButton = allButton;
        return footer;
    }
    
    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = kColorF5F6FA;
    return grayView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    JHCustomerInfoType type = [self getCustomerHeaderTypeWithSection:section];
    ///定制费用说明
    if (type == JHCustomerInfoTypeCustomizeFeeIntroducation) {
        if (self.roomInfo.fees.count > MAX_ARCHOR_COUNT) {
            return 60.f;
        } else {
//            BOOL isUserSelf = self.roomInfo.showButton;
//            if (isUserSelf) {
                return  20.f;
//            } else {
//                return  10.f;
//            }
        }
    }
    
    if (type == JHCustomerInfoTypeShopAndLiveRoom ||
        type == JHCustomerInfoTypeCustomerIntroducation) {
        return 10.f;
    }
    
    if (type == JHCustomerInfoTypeMasterpiece) {
        if (self.roomInfo.showButton) {
            return 10.f;
        } else {
            if (self.roomInfo.opusList.count >0) {
                return 10.f;
            } else {
                return 0.f;
            }
        }
    }
    
    if (type == JHCustomerInfoTypeHonorCer) {
        if (self.roomInfo.showButton) {
            return 10.f;
        } else {
            if (self.roomInfo.certificateList.count >0) {
                return 10.f;
            } else {
                return 0.f;
            }
        }
    }
    
    if (type == JHCustomerInfoTypeStuffCagetory) {
        if (self.roomInfo.showButton) {
            return 10.f;
        } else {
            if (self.roomInfo.materials.count >0) {
                return 10.f;
            } else {
                return 0.f;
            }
        }
    }
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ///定制师介绍
    JHCustomerInfoType type = [self getCustomerHeaderTypeWithSection:indexPath.section];
    switch (type) {
        case JHCustomerInfoTypeShopAndLiveRoom:  ///直播间和店铺的UI
        {
            if (self.roomInfo.shopId > 0 || self.roomInfo.materialChannelId > 0) {
                ///我的店铺 || 关联直播间
                JHPostDtailEnterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kPostDetailEnterIdentifer];
                JHDetailEnterType type = 0;
                
                if (self.roomInfo.shopId > 0 && self.roomInfo.materialChannelId > 0) {
                    type = indexPath.row ? JHDetailEnterTypeLiveRoom : JHDetailEnterTypeShop;
                } else {
                    if (self.roomInfo.shopId > 0) {
                        type = JHDetailEnterTypeShop;
                    }
                    if (self.roomInfo.materialChannelId > 0) {
                        type = JHDetailEnterTypeLiveRoom;
                    }
                }
                
                if (type == JHDetailEnterTypeShop) {
                    [cell setIcon:self.roomInfo.shopImg
                             name:self.roomInfo.shopName
                             desc:[NSString stringWithFormat:@"共%ld件商品",(long)self.roomInfo.shopCount]
                        liveState:self.roomInfo.channelStatus
                             type:type];
                } else {
                    NSInteger playStatus = self.roomInfo.materialChannelStatus == 2?1:0;
                    [cell setIcon:self.roomInfo.materialChannelImg
                             name:self.roomInfo.materialChannelName
                             desc:[NSString stringWithFormat:@"共%ld热度",(long)self.roomInfo.materialChannelViewCount]
                        liveState:playStatus
                             type:type];
                }
                return cell;
            }
            if (self.roomInfo.showButton) {
                BOOL isLive = (indexPath.row == 1);
                NSString *title = isLive ? @"推荐的原料直播间" : @"我的店铺";
                JHCustomerAssoicateBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:kAssoicateBlankIdentifer];
                [cell configBlankCell:title];
                return  cell;
            }
            return [UITableViewCell new];
        }
            break;
        case JHCustomerInfoTypeCustomerIntroducation: ///定制师介绍
        {
            JHCustomerIntroducationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomerIntroducationCell class])];
            if (!cell) {
                cell = [[JHCustomerIntroducationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomerIntroducationCell class])];
            }
            if (self.roomInfo) {
                cell.roomInfo = self.roomInfo;
            }
            @weakify(self);
            cell.updateBlock = ^(CGFloat allHeight) {
                @strongify(self);
                self.liveRoomHeight = allHeight;
                [self.infoTableView reloadData];
            };
            return cell;
        }
            break;
        case JHCustomerInfoTypeMasterpiece:  ///代表作
        {
            /// 代表作
            JHCustomerMasterpieceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomerMasterpieceTableViewCell class])];
            if (!cell) {
                cell = [[JHCustomerMasterpieceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomerMasterpieceTableViewCell class])];
            }
            if (self.roomInfo) {
                [cell setViewModel:self.roomInfo];
            }
            @weakify(self);
            cell.masterActionBlock = ^(NSInteger index) {
                @strongify(self);
                if (self.mpActionBlock) {
                    self.mpActionBlock(index);
                }
            };
            return cell;
        }
            break;
        case JHCustomerInfoTypeHonorCer:  ///荣誉证书
        {
            /// 荣誉证书
            JHCustomerHonorCerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomerHonorCerTableViewCell class])];
            if (!cell) {
                cell = [[JHCustomerHonorCerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomerHonorCerTableViewCell class])];
            }
            if (self.roomInfo) {
                [cell setViewModel:self.roomInfo];
            }
            @weakify(self);
            cell.honnerCerActionBlock = ^(NSIndexPath * _Nonnull indexpath) {
                @strongify(self);
                if (self.hcActionBlock) {
                    self.hcActionBlock(indexpath.row);
                }
            };
            return cell;
        }
            break;
            
        case JHCustomerInfoTypeStuffCagetory: { /// 定制材质
            JHCustomizeStuffCagetoryInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeStuffCagetoryInfoTableViewCell class])];
            if (!cell) {
                cell = [[JHCustomizeStuffCagetoryInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeStuffCagetoryInfoTableViewCell class])];
            }
            if (self.roomInfo) {
                [cell setViewModel:self.roomInfo];
            }
            return cell;
        }
            break;
        case JHCustomerInfoTypeCustomizeFeeIntroducation:  ///定制费用说明
        {
            ///定制费用说明
            JHCustomerFeeDescTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomerFeeDescTableCell class])];
            if (!cell) {
                cell = [[JHCustomerFeeDescTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomerFeeDescTableCell class])];
            }
            NSArray *feesArray = nil;
            if (self.roomInfo.fees.count > MAX_ARCHOR_COUNT) {
                feesArray = _isShowAll ? self.roomInfo.fees : [self.roomInfo.fees subarrayWithRange:NSMakeRange(0, 8)];
            }
            else {
                feesArray = self.roomInfo.fees;
            }
            cell.feeInfoArray = [self getCustomerFeesData];
            return cell;
        }
            break;
        default:
            return [[UITableViewCell alloc] init];
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHCustomerInfoType type = [self getCustomerHeaderTypeWithSection:indexPath.section];
    if (type == JHCustomerInfoTypeShopAndLiveRoom) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell isMemberOfClass:[JHCustomerAssoicateBlankCell class]]) {
            [UITipView showTipStr:@"暂未关联，请联系平台"];
            return;
        }
        if (indexPath.row == 0 && self.roomInfo.shopId > 0) {
            ///进店铺 --- 走新店铺逻辑
            JHNewShopDetailViewController *vc = [[JHNewShopDetailViewController alloc] init];
            vc.customerId = [NSString stringWithFormat:@"%ld",(long)self.roomInfo.shopId];
            [JHGrowingIO trackEventId:@"dz_teacher_shop_click"];
            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        } else if ((indexPath.row == 0 && self.roomInfo.materialChannelId > 0) || (indexPath.row == 1 && self.roomInfo.materialChannelId > 0)) {
            ///进入直播间的点击事件 /// v3.6.0 定制二期，定制主播直播中不可以跳转，其他都可以跳
            if (self.roomInfo.showButton && self.roomInfo.channelStatus == 2) {
                [JHKeyWindow makeToast:@"正在直播，无法跳转" duration:1.0 position:CSToastPositionCenter];
            } else {
                [JHGrowingIO trackEventId:@"dz_teacher_pro_click"];
                [JHRootController EnterLiveRoom:@(self.roomInfo.materialChannelId).stringValue
                                     fromString:JHLiveFromCustomizeHomePage];
            }
        }
    }
    else if (type == JHCustomerInfoTypeCustomerIntroducation) {
        ///定制师介绍
        JHCustomerIntroduceController *vc = [[JHCustomerIntroduceController alloc] init];
        vc.roomInfo = self.roomInfo;
        vc.updateBlock = self.updateBlock;
        [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - 处理section中的点击事件
- (void)handleSectionHeaderEvent:(NSInteger)selectIndex {
    JHCustomerInfoType type = [self getCustomerHeaderTypeWithSection:selectIndex];
    switch (type) {
        case JHCustomerInfoTypeCustomerIntroducation: {
            ///编辑定制师说明
            [JHRootController toNativeVC:NSStringFromClass([JHCustomerBriefController class])
                               withParam:@{
                                   @"isRecycle":@(NO),
                                   @"channelLocalId":self.roomInfo.channelLocalId,
                                   @"text":self.roomInfo.customizeIntro,
                                   @"callbackMethod":self.updateBlock}
                                    from:JHLiveFromLiveRoom];
        }
            break;
        case JHCustomerInfoTypeMasterpiece: {
            /// 编辑代表作
            [JHRootController toNativeVC:NSStringFromClass([JHCustomerMpEditViewController class])
                               withParam:@{
                                   @"userIcon":self.userIcon,
                                   @"userName":self.userName,
                                   @"userDesc":self.userDesc,
                                   @"ID":self.roomInfo.anchorId,
                                   @"callbackMethod":self.updateBlock
                               } from:JHLiveFromLiveRoom];
            
        }
            break;
        case JHCustomerInfoTypeHonorCer: {
            /// 编辑荣誉证书
            [JHRootController toNativeVC:NSStringFromClass([JHCustomerCerEditViewController class])
                               withParam:@{
                                   @"channelLocalId":self.roomInfo.channelLocalId,
                                   @"text":self.roomInfo.customizeIntro,
                                   @"callbackMethod":self.updateBlock}
                                    from:JHLiveFromLiveRoom];
        }
            break;
        case JHCustomerInfoTypeStuffCagetory : {
            /// 跳转到选择定制材质页面
            [JHRootController toNativeVC:NSStringFromClass([JHCustomizeStuffDetailController class])
                               withParam:@{
                                   @"saveBlock":self.updateBlock}
                                    from:JHLiveFromLiveRoom];
        }
            break;
        case JHCustomerInfoTypeCustomizeFeeIntroducation: {
            if (self.roomInfo.showButton) { ///展示编辑按钮 当前为定制师或者助理本身
                /// 编辑费用
                [JHRootController toNativeVC:NSStringFromClass([JHCustomerFeeEditController class])
                                   withParam:@{
                                       @"channelLocalId":self.roomInfo.channelLocalId,
                                       @"callbackMethod":self.updateBlock}
                                        from:JHLiveFromLiveRoom];

            } else {
                NSLog(@"添加申请定制跳转界面");
                if (self.roomInfo.channelStatus == 2) {
                    [JHRootController EnterLiveRoom:self.roomInfo.channelLocalId fromString:@"dz_teacher_in" isStoneDetail:NO isApplyConnectMic:YES];
                } else {
                    [JHRootController EnterLiveRoom:self.roomInfo.channelLocalId fromString:@"dz_teacher_in" isStoneDetail:NO isApplyConnectMic:NO];
                }
            }
        }
        default:
            break;
    }
}



- (void)followEventAction {
    if (IS_LOGIN) {
        if (self.followBlock) {
            self.followBlock(self.roomInfo.isFollow);
        }
    }
}

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY {
    CGRect frame = self.headerImageFrame;
    frame.origin.y = contentOffsetY;
    if (contentOffsetY < 0) {
        frame.size.height -= contentOffsetY;
    }
//    NSLog(@"contentOffsetY--- %f", contentOffsetY);
    [self.headerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(frame.origin.y);
        make.height.mas_equalTo(frame.size.height);
    }];
}


- (JXPagerMainTableView *)infoTableView {
    if(!_infoTableView) {
        _infoTableView = [[JXPagerMainTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _infoTableView.dataSource = self;
        _infoTableView.delegate = self;
        _infoTableView.tableFooterView = [UIView new];
        _infoTableView.separatorColor = kColorF5F6FA;
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _infoTableView.estimatedRowHeight = 10.f;
        if (@available(iOS 11.0, *)) {
            _infoTableView.estimatedSectionFooterHeight = 0.1f;
            _infoTableView.estimatedSectionHeaderHeight = 0.1f;
            _infoTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            self.viewController.automaticallyAdjustsScrollViewInsets = NO;
        }
    
        [_infoTableView registerClass:[JHCustomerIntroducationCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomerIntroducationCell class])];
        [_infoTableView registerClass:[JHCustomerFeeDescTableCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomerFeeDescTableCell class])];
        [_infoTableView registerClass:[JHCustomerMasterpieceTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomerMasterpieceTableViewCell class])];
        [_infoTableView registerClass:[JHCustomerHonorCerTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomerHonorCerTableViewCell class])];
        [_infoTableView registerClass:[JHPostDtailEnterTableCell class] forCellReuseIdentifier:kPostDetailEnterIdentifer];
        ///空白店铺/关联直播间的cell
        [_infoTableView registerClass:[JHCustomerAssoicateBlankCell class] forCellReuseIdentifier:kAssoicateBlankIdentifer];
        /// 可定制材质
        [_infoTableView registerClass:[JHCustomizeStuffCagetoryInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeStuffCagetoryInfoTableViewCell class])];
        
        if ([_infoTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_infoTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_infoTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_infoTableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _infoTableView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
}

#pragma mark -
#pragma mark - private method

- (NSArray *)getCustomerFeesData {
    NSArray *feesArray = nil;
    if (self.roomInfo.fees.count > MAX_ARCHOR_COUNT) {
        feesArray = _isShowAll ? self.roomInfo.fees : [self.roomInfo.fees subarrayWithRange:NSMakeRange(0, 8)];
    }
    else {
        feesArray = self.roomInfo.fees;
    }
    return feesArray;
}

- (NSString *)sectionTitleBySection:(NSInteger)section {
    JHCustomerInfoType type = [self getCustomerHeaderTypeWithSection:section];
    NSString *sectionTitle = @"";
    switch (type) {
        case JHCustomerInfoTypeCustomerIntroducation:
            sectionTitle = @"定制师介绍";
            break;
        case JHCustomerInfoTypeMasterpiece:
            sectionTitle = @"代表作";
            break;
        case JHCustomerInfoTypeHonorCer:
            sectionTitle = @"荣誉证书";
            break;
        case JHCustomerInfoTypeStuffCagetory:
            sectionTitle = @"可定制材质";
            break;
        case JHCustomerInfoTypeCustomizeFeeIntroducation:
            sectionTitle = @"定制费用说明";
            break;
        default:
            break;
    }
    return sectionTitle;
}

- (JHCustomerInfoType)getCustomerHeaderTypeWithSection:(NSInteger)section {
    BOOL isUserSelf = self.roomInfo.showButton;
    if (isUserSelf) { /// 主播侧
        switch (section) {
            case 0:
                return JHCustomerInfoTypeShopAndLiveRoom;
                break;
            case 1:
                return JHCustomerInfoTypeCustomerIntroducation;
                break;
            case 2: /// 代表作
                return JHCustomerInfoTypeMasterpiece;
                break;
            case 3: /// 荣誉证书
                return JHCustomerInfoTypeHonorCer;
                break;
            case 4: /// 可定制材质
                return JHCustomerInfoTypeStuffCagetory;
                break;
            case 5:/// 定制费用说明
                return JHCustomerInfoTypeCustomizeFeeIntroducation;
                break;
            default:
                return JHCustomerInfoTypeNone;
                break;
        }
    } else {
        if (self.roomInfo.shopId > 0 || self.roomInfo.materialChannelId > 0) {
            switch (section) {
                case 0:
                    return JHCustomerInfoTypeShopAndLiveRoom;
                    break;
                case 1:
                    return JHCustomerInfoTypeCustomerIntroducation;
                    break;
                case 2: ///代表作
                    return JHCustomerInfoTypeMasterpiece;
                    break;
                case 3: ///荣誉证书
                    return JHCustomerInfoTypeHonorCer;
                    break;
                case 4: /// 可定制材质
                    return JHCustomerInfoTypeStuffCagetory;
                    break;
                case 5:///定制费用说明
                    return JHCustomerInfoTypeCustomizeFeeIntroducation;
                    break;
                default:
                    return JHCustomerInfoTypeNone;
                    break;
            }
        } else {
            switch (section) {
                case 0:
                    return JHCustomerInfoTypeCustomerIntroducation;
                    break;
                case 1: /// 代表作
                    return JHCustomerInfoTypeMasterpiece;
                    break;
                case 2: ///荣誉证书
                    return JHCustomerInfoTypeHonorCer;
                    break;
                case 3: /// 可定制材质
                    return JHCustomerInfoTypeStuffCagetory;
                    break;
                case 4: /// 定制费用说明
                    return JHCustomerInfoTypeCustomizeFeeIntroducation;
                    break;
                default:
                    return JHCustomerInfoTypeNone;
                    break;
            }
        }
    }
}

-(void)dealloc {
    [self.infoTableView removeObserver:self forKeyPath:@"contentSize"];
}

@end
