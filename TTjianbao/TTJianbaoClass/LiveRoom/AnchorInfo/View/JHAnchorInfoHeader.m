//
//  JHAnchorInfoHeader.m
//  TTjianbao
//
//  Created by lihui on 2020/7/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAnchorInfoHeader.h"
#import "TTjianbao.h"
#import "JHShopEnterView.h"
#import "UIView+CornerRadius.h"
#import "UIImageView+JHWebImage.h"
#import "UserInfoRequestManager.h"
#import "JHUserInfoModel.h"
#import "JHUserInfoDetailView.h"
#import "JHRootViewController+TransitPage.h"
#import "UIView+JHGradient.h"
#import "JHSQManager.h"
#import "JHLiveRoomInfoTableCell.h"
#import "JHAnchorInfoTableCell.h"
#import "JHAnchorInfoSectionHeader.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHAnchorEditInfoController.h"
#import "JHLiveRoomModel.h"
#import "JHAddInfoTableCell.h"
#import "JHLiveRoomApiManger.h"
#import "CommAlertView.h"
#import "CommHelp.h"
#import "JHFansListView.h"
#define paramsSpace 10
#define headerImageHeight 205

#define kAddCellHeight 120.f
#import "JHWebViewController.h"
#import "JHAuthAlertView.h"
#import "JHUserAuthVerificationView.h"

#define paramsSpace         10.f
#define headerImageHeight   205.f
#define commonHeight        210.f
#define kAddCellHeight      120.f

#define MAX_ARCHOR_COUNT  1

@interface JHAnchorInfoHeader () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UIImageView *headerImageView;
///底部展示用户信息的view
@property (nonatomic,strong) UIView *infoView;
@property (nonatomic,strong) UIView *iconView;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *nickNameLabel;
@property (nonatomic,strong) UIButton *followButton;
@property (nonatomic, strong) JHUserInfoDetailView *fansView;
@property (nonatomic, strong) JHUserInfoDetailView *followView;
@property (nonatomic, strong) JHUserInfoDetailView *likeView;
@property (nonatomic, strong) JHUserInfoDetailView *exepView;
@property (nonatomic, strong) JHUserInfoDetailView *fansClubView;
@property (nonatomic, strong) UIVisualEffectView *effectView;

///展示直播间介绍和主播介绍
@property (nonatomic, strong) UITableView *infoTableView;

@property (nonatomic, assign) CGRect headerImageFrame;
@property (nonatomic, assign) CGRect headerHeight;
@property (nonatomic, assign) CGFloat liveRoomHeight;
///是否显示全部主播
@property (nonatomic, assign) BOOL isShowAll;

@property (nonatomic, copy) NSMutableArray <JHAnchorInfo *>*anchorInfos;
@property (nonatomic, strong) UIButton *showAllButton;

@end

@implementation JHAnchorInfoHeader

- (NSMutableArray<JHAnchorInfo *> *)anchorInfos {
    if (!_anchorInfos) {
        _anchorInfos = [NSMutableArray array];
    }
    return _anchorInfos;
}

- (void)makeAuthorValueLayouts {
    NSString * title = [_roomInfo.name isNotBlank] ? _roomInfo.name : @"暂无昵称";
    NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:title];
    UIFont *font = [UIFont fontWithName:kFontMedium size:22];
    titleAttr.font = font;
    titleAttr.color = kColor333;
    if (_roomInfo.authType > 0) {
        ///已认证
        NSString *authString = (_roomInfo.authType == JHUserAuthTypePersonal) ? @"icon_auth_personal" : @"icon_auth_company";
        UIImage *image = [UIImage imageNamed:authString];
        if (image) {
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.image = image;
            attach.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
            NSMutableAttributedString *icon = [[NSMutableAttributedString alloc] initWithAttributedString:[NSMutableAttributedString attributedStringWithAttachment:attach]];
            [icon addAttribute:NSLinkAttributeName value:@"checkbox://" range:NSMakeRange(0, icon.length)];
            [titleAttr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            [titleAttr appendAttributedString:icon];
        }
    }
    
    _nickNameLabel.attributedText = titleAttr;
    [self.infoView layoutIfNeeded];
}

- (void)__enterAuthentationPage {
    if (_roomInfo.authType > 0 && [_roomInfo.anchorId integerValue] > 0) {
        if (_roomInfo.authType == JHUserAuthTypePersonal) {
            ///个人认证 弹出弹窗
            [JHAuthAlertView showText:@"该商家已通过个人认证\n身份信息已在天天鉴宝备案"];
        }
        else {
            
            [JHUserAuthVerificationView showWithCompleteBlock:^{
                ///企业认证
                NSString *url = H5_BASE_STRING(@"/jianhuo/app/enterpriseCertification/enterpriseCertification.html?id=");
                url = [NSString stringWithFormat:@"%@%@",url,self.roomInfo.anchorId];
                
                JHWebViewController *vc = [[JHWebViewController alloc] init];
                vc.urlString = url;
                vc.titleString = @"企业认证";
                [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
            }]; 
        }
    }
}


- (void)setRoomInfo:(JHLiveRoomModel *)roomInfo {
    if (!roomInfo) {
        return;
    }
    
    _roomInfo = roomInfo;
    _liveRoomHeight = _roomInfo.roomDesHeight;
    [_headerImageView jhSetImageWithURL:[NSURL URLWithString:_roomInfo.avatar] placeholder:kDefaultCoverImage];
    self.effectView.hidden = NO;
    [_iconImageView jhSetImageWithURL:[NSURL URLWithString:_roomInfo.avatar] placeholder:kDefaultAvatarImage];
    
    [self makeAuthorValueLayouts];
    
    ///关注按钮
    if (_roomInfo.isFollow) {
        [self gradientColorForFollowButton:@[kColorEEE, kColorEEE]];
        [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
        [_followButton setTitleColor:kColor999 forState:UIControlStateNormal];
        [_followButton setTitleColor:kColor999 forState:UIControlStateHighlighted];
    }
    else {
        [self gradientColorForFollowButton:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)]];
        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
        [_followButton setTitleColor:kColor333 forState:UIControlStateNormal];
        [_followButton setTitleColor:kColor333 forState:UIControlStateHighlighted];
    }

    _fansView.value = [CommHelp convertNumToWUnitString:_roomInfo.fansNum existDecimal:YES];
    _followView.value = [CommHelp convertNumToWUnitString:_roomInfo.thumbsUpNum existDecimal:YES];
    _likeView.value = [CommHelp convertNumToWUnitString:_roomInfo.commentNum existDecimal:YES];
    _exepView.value = _roomInfo.commentGrade;

    if (_roomInfo.fansClubId && [_roomInfo.fansClubId intValue]!=-1) {
        _fansClubView.value = _roomInfo.fansCount;
    }
    else{
        _fansClubView.value = @"未开通";
    }
    
    _anchorInfos = _roomInfo.anchorList.mutableCopy;
    [self.infoTableView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorF5F6FA;
        _isShowAll = NO;
        _liveRoomHeight = roomDesHeight;
        [self setupViews];
    }
    return self;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.alpha = 0.8;
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
    
    _iconImageView = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_iconView addSubview:_iconImageView];

    _nickNameLabel = [[UILabel alloc] init];
    _nickNameLabel.textColor = kColor333;
    _nickNameLabel.numberOfLines = 0;
    _nickNameLabel.font = [UIFont fontWithName:kFontMedium size:22];
    _nickNameLabel.userInteractionEnabled = YES;
    [self addSubview:_nickNameLabel];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__enterAuthentationPage)];
    [_nickNameLabel addGestureRecognizer:tapGR];
    
    _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _followButton.backgroundColor = kColorMain;
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    _followButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:12];
    [_followButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_followButton addTarget:self action:@selector(followEventAction) forControlEvents:UIControlEventTouchUpInside];
    [self gradientColorForFollowButton:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)]];
    [_infoView addSubview:_followButton];
    
    _fansView = [[JHUserInfoDetailView alloc] init];
    [_fansView setTitle:@"粉丝" value:@"0"];
    [_infoView addSubview:_fansView];
    
    _followView = [[JHUserInfoDetailView alloc] init];
    [_followView setTitle:@"获赞" value:@"0"];
    [_infoView addSubview:_followView];

    _likeView = [[JHUserInfoDetailView alloc] init];
    [_likeView setTitle:@"评价" value:@"0"];
    [_infoView addSubview:_likeView];

    _exepView = [[JHUserInfoDetailView alloc] init];
    [_exepView setTitle:@"好评度" value:@"0"];
    [_infoView addSubview:_exepView];
    
    _fansClubView = [[JHUserInfoDetailView alloc] init];
    [_fansClubView setTitle:@"粉丝团" value:@"0"];
    [_infoView addSubview:_fansClubView];
    
    @weakify(self);
    _fansClubView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (state == YYGestureRecognizerStateEnded) {
        
            if (self.roomInfo.showButton&&
                _roomInfo.fansClubId &&
                [_roomInfo.fansClubId intValue]!=-1) {
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
    
    [self.infoTableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat tableHeight = self.infoTableView.contentSize.height;
        CGFloat infoViewHeight = self.infoView.height;
        [[NSNotificationCenter defaultCenter] postNotificationName:kChangeAnchorHeaderHeightNotification object:@{@"tableHeight":@(tableHeight+infoViewHeight+commonHeight)}];
        
        [self.infoTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(tableHeight);
        }];
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate / UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    ///直播间
    if (indexPath.section == JHArchorSectionTypeLiveRoom) {
        JHLiveRoomInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kLiveRoomIdentifer];
        cell.roomInfo = self.roomInfo;
        cell.editBlock = ^{
            @strongify(self);
            [self enterEditPage:JHArchorSectionTypeLiveRoom Anchor:nil];
        };
        
        cell.updateBlock = ^(CGFloat allHeight) {
            @strongify(self);
            self.liveRoomHeight = allHeight;
            [self.infoTableView reloadData];
        };
        return cell;
    }
    ///添加主播介绍
    if (indexPath.section == JHArchorSectionTypeAddInfo) {
        if (self.roomInfo.showButton && self.anchorInfos.count < 5) {
            ///添加主播介绍的cell
            JHAddInfoTableCell * cell = [tableView dequeueReusableCellWithIdentifier:kAddInfoIdentifer];
            cell.editBlock = ^{/// 进入编辑主播的页面
                @strongify(self);
                [self enterEditPage:JHArchorSectionTypeArchor Anchor:nil];
            };
            return cell;
        }
        return [[UITableViewCell alloc] init];
    }
    ///主播介绍
    JHAnchorInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kAnchorInfoIdentifer];
    cell.isAnchor = self.roomInfo.showButton;
    cell.anchorInfo = self.anchorInfos[indexPath.row];
    cell.eventBlock = ^(NSInteger selectIndex, JHAnchorInfo * _Nonnull anchor, JHAnchorEventType eventType) {
        [self handleClickEvent:anchor EventType:eventType];
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == JHArchorSectionTypeArchor) {
        if (_isShowAll || self.anchorInfos.count <= MAX_ARCHOR_COUNT) {
            return self.anchorInfos.count;
        }
        else {
            return MAX_ARCHOR_COUNT;
        }
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ///直播间
    if (indexPath.section == JHArchorSectionTypeLiveRoom) {
        NSString *str = self.roomInfo.roomDes;
        if (self.roomInfo.showButton) { ///是主播或者助理
            if ([str isNotBlank]) {
                return _liveRoomHeight;
            }
            return kAddCellHeight;
        }
        return _liveRoomHeight;
    }
    ///添加主播介绍
    if (self.roomInfo.showButton && indexPath.section == JHArchorSectionTypeAddInfo) {
        if (self.anchorInfos.count < 5) {
            ///小于5 需要展示添加按钮
            return kAddCellHeight;
        }
        return 1.f;
    }
    ///添加主播
    if (indexPath.section == JHArchorSectionTypeArchor &&
        self.roomInfo.anchorList.count > 0) {
//        JHAnchorInfo *info = self.roomInfo.anchorList[indexPath.row];
//        return info.cellHeight;
        return UITableViewAutomaticDimension;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == JHArchorSectionTypeArchor) { ///主播头部不需要添加header
        return [UIView new];
    }
    
    JHAnchorInfoSectionHeader *header = [[JHAnchorInfoSectionHeader alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 35)];
    NSString * sectionTitle = section ? @"主播介绍" : @"直播间介绍";
    NSString * icon = section ? @"icon_anchor_intro" : @"icon_anchor_living";
    header.type = section;
    [header setTitle:sectionTitle HeaderIcon:icon];
    header.roomInfo = self.roomInfo;
    @weakify(self);
    header.editBlock = ^(JHArchorSectionType type) {
        @strongify(self);
        [self enterEditPage:type Anchor:nil];
    };
    header.deleteBlock = ^(JHArchorSectionType type) {
        [self showAlertView:@"您确定要删除该直播间介绍吗？" completeBlock:^(BOOL isSure) {
            if (isSure) {
                [self deleteLiveRoomInfo];
            }
        }];
    };
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  section != JHArchorSectionTypeArchor ? 35 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == JHArchorSectionTypeArchor) {
        if (self.anchorInfos.count == 0 && !self.roomInfo.showButton) {
            UIView *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenW-30, 50)];
            label.text = @"暂无主播介绍";
            label.font = [UIFont fontWithName:kFontNormal size:13];
            label.textColor = kColor666;
            [header addSubview:label];
            return header;
        }
        if (self.anchorInfos.count > MAX_ARCHOR_COUNT) {
            UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
            UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
            allButton.frame = footer.bounds;
            [allButton setTitle:@"全部主播" forState:UIControlStateNormal];
            [allButton setTitle:@"收起全部" forState:UIControlStateSelected];
            [allButton setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
            [allButton setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateSelected];
            [allButton setImage:[UIImage imageNamed:@"icon_anchor_arrow_down"] forState:UIControlStateNormal];
            [allButton setImage:[UIImage imageNamed:@"icon_anchor_arrow_up"] forState:UIControlStateSelected];
            allButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
            [footer addSubview:allButton];
            [allButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
            [allButton addTarget:self action:@selector(showAllAnchor) forControlEvents:UIControlEventTouchUpInside];
            allButton.selected = _isShowAll;
            _showAllButton = allButton;
            return footer;
        }
        return [UIView new];
    }
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
   if (section == JHArchorSectionTypeArchor) {
       if (self.anchorInfos.count == 0 && !self.roomInfo.showButton) {
           return 50;
       }
       if (self.anchorInfos.count > MAX_ARCHOR_COUNT) {
           return 50;
       }
       return CGFLOAT_MIN;
   }

    return CGFLOAT_MIN;
}

#pragma mark -
#pragma mark -  action method

- (void)handleClickEvent:(JHAnchorInfo *)anchor
               EventType:(JHAnchorEventType)eventType {
    if (!anchor) {
        return;
    }
    switch (eventType) {
        case JHAnchorEventTypeSetPlay:
            {
                ///设置主播开播状态
                [self modifyLiveState:anchor];
            }
            break;
        case JHAnchorEventTypeEdit:
            {
                [self enterEditPage:JHArchorSectionTypeArchor Anchor:anchor];
            }
            break;
        case JHAnchorEventTypeDelete:
            {
                [self showAlertView:@"您确定要删除该主播吗？" completeBlock:^(BOOL isSure) {
                    if (isSure) {
                        [self deleteAnchorInfo:anchor];
                    }
                }];
            }
            break;
        default:
            break;
    }
}

- (void)showAlertView:(NSString *)alertStr completeBlock:(void(^)(BOOL isSure))block {
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:alertStr cancleBtnTitle:JHLocalizedString(@"sure") sureBtnTitle:JHLocalizedString(@"cancel")];
    [JHKeyWindow addSubview:alert];
    alert.handle = ^{
        if (block) {
            block(NO);
        }
    };
    alert.cancleHandle = ^{
        if (block) {
            block(YES);
        }
    };
}

- (void)modifyLiveState:(JHAnchorInfo *)anchor {
    [self beginLoading];
    @weakify(self);
    [JHLiveRoomApiManger modifyLivingState:anchor.broadId liveState:@(!anchor.liveState).stringValue completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        [self endLoading];
        @strongify(self);
        if (!hasError) {
            [UITipView showTipStr:@"设置成功"];
            if (self.updateBlock) {
                self.updateBlock();
            }
        }
    }];
}

#pragma mark - 进入编辑信息界面
- (void)enterEditPage:(JHArchorSectionType)type Anchor:(JHAnchorInfo * _Nullable)anchor {
    JHAnchorRoomInfo *info = [[JHAnchorRoomInfo alloc] init];
    info.pageType = type;
    info.channelLocalId = self.roomInfo.channelLocalId;
    info.roomDes = self.roomInfo.roomDes;
    if (anchor) {
        info.avatar = anchor.avatar;
        info.broadId = anchor.broadId;
        info.nick = anchor.nick;
        info.des = anchor.des;
        info.liveState = anchor.liveState;
    }

    JHAnchorEditInfoController *vc = [[JHAnchorEditInfoController alloc] init];
    vc.anchorRoomInfo = info;
    vc.doneBlock = self.updateBlock;
    [JHRootController.homeTabController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 删除直播间信息
- (void)deleteLiveRoomInfo {
    [self beginLoading];
    @weakify(self);
    [JHLiveRoomApiManger deleteLiveRoomInfo:self.roomInfo.channelLocalId completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        [self endLoading];
        @strongify(self);
        if (!hasError) {
            [UITipView showTipStr:@"删除成功"];
            self.roomInfo.roomDes = @"";
            [self.infoTableView reloadSection:JHArchorSectionTypeLiveRoom withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

///删除主播信息
- (void)deleteAnchorInfo:(JHAnchorInfo *)anchor {
    [JHLiveRoomApiManger deleteAnchorInfo:anchor.broadId completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        if (!hasError) {
            [UITipView showTipStr:@"删除成功"];
            [self.anchorInfos removeObject:anchor];
            self.roomInfo.anchorList = self.anchorInfos.copy;
//            [self.infoTableView reloadSection:JHAnchorInfoCellTypeAnchor withRowAnimation:UITableViewRowAnimationNone];
            [self.infoTableView reloadData];
        }
    }];
}

- (void)showAllAnchor {
    _isShowAll = !_showAllButton.selected;
    [self.infoTableView reloadData];
    _showAllButton.selected = _isShowAll;
    [_showAllButton layoutIfNeeded];
}

- (void)gradientColorForFollowButton:(NSArray <UIColor *>*)colors {
    [_followButton jh_setGradientBackgroundWithColors:colors locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}

- (void)makeLayouts {
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(205);
    }];
    
    [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headerImageView);
    }];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.infoView).offset(15);
        make.centerY.equalTo(self.infoView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconView).insets(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
    
    [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.infoView).offset(-15);
        make.top.equalTo(self.infoView).offset(10);
        make.size.mas_equalTo(CGSizeMake(146, 30));
    }];
        
    [_fansView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoView).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 38));
        make.bottom.equalTo(self.infoView).offset(-15);
    }];
        
    [_followView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fansView.mas_right).offset(paramsSpace);
        make.size.mas_equalTo(CGSizeMake(70, 38));
        make.bottom.equalTo(self.fansView);
    }];
    
    [_likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followView.mas_right).offset(paramsSpace);
        make.size.mas_equalTo(CGSizeMake(70, 38.));
        make.bottom.equalTo(self.followView);
    }];

    [_exepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeView.mas_right).offset(paramsSpace);
        make.size.mas_equalTo(CGSizeMake(70, 38.));
        make.bottom.equalTo(self.likeView);
    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(15);
        make.bottom.equalTo(self.fansView.mas_top).offset(-12);
        make.left.equalTo(self.infoView).offset(15);
        make.right.equalTo(self.infoView).offset(-10);
    }];
    
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerImageHeight-15);
        make.leading.trailing.equalTo(self);
//        make.height.mas_equalTo(154.f);
        make.bottom.equalTo(self.fansView).offset(15);
    }];
    
    [_fansClubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.exepView.mas_right).offset(paramsSpace);
        make.size.mas_equalTo(CGSizeMake(70, 40));
        make.bottom.equalTo(self.exepView);
    }];
    
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(10);
        make.left.right.equalTo(self);
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
}

- (void)followEventAction {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    if (self.followBlock) {
        self.followBlock(self.roomInfo.isFollow);
    }
}

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY {
    CGRect frame = self.headerImageFrame;
    frame.origin.y = contentOffsetY;
    if (contentOffsetY < 0) {
        frame.size.height -= contentOffsetY;
    }
    NSLog(@"contentOffsetY--- %f", contentOffsetY);

    [self.headerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(frame.origin.y);
        make.height.mas_equalTo(frame.size.height);
    }];
}

- (UITableView *)infoTableView {
    if(!_infoTableView) {
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _infoTableView.dataSource = self;
        _infoTableView.delegate = self;
        _infoTableView.tableFooterView = [UIView new];
        _infoTableView.separatorColor = kColorF5F6FA;
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _infoTableView.estimatedRowHeight = 100;
    
        [_infoTableView registerClass:[JHLiveRoomInfoTableCell class] forCellReuseIdentifier:kLiveRoomIdentifer];

        [_infoTableView registerClass:[JHAnchorInfoTableCell class] forCellReuseIdentifier:kAnchorInfoIdentifer];
        
        [_infoTableView registerClass:[JHAddInfoTableCell class] forCellReuseIdentifier:kAddInfoIdentifer];
        
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

-(void)dealloc
{
    [self.infoTableView removeObserver:self forKeyPath:@"contentSize"];
}

@end
