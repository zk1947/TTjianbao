//
//  JHGemmologistHeaderView.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGemmologistHeaderView.h"
#import "JHUserInfoDetailView.h"
#import "JHGemmologistCertificateCell.h"
#import "UIButton+WebCache.h"
#import "UIView+JHGradient.h"
#import "JHSQManager.h"
#import "JHPersonalViewController.h"
#import "JHUserInfoApiManager.h"
#import "JHZanHUD.h"
#import "NSString+AttributedString.h"
#import "JHGemmologistCommentViewController.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>
#import "JHPhotoBrowserManager.h"
#import "UIView+CornerRadius.h"
#import "NTESAudienceLiveViewController.h"
#import "MJExtension.h"
#import <UIImage+GIF.h>
#import "JHAuthorize.h"
@interface JHGemmologistHeaderView()<UICollectionViewDelegate, UICollectionViewDataSource>
/** 背景图*/
@property (nonatomic, strong) UIImageView *backImageView;
/** 蒙层*/
@property (nonatomic, strong) UIVisualEffectView *effectView;
/** 信息栏*/
@property (nonatomic, strong) UIView *infoView;
/** 关注按钮*/
@property (nonatomic, strong) UIButton *attentionButton;
/** 名字*/
@property (nonatomic, strong) UILabel *namelabel;
/** 宝友号*/
@property (nonatomic, strong) UILabel *numberLabel;
/** 认证鉴定师*/
@property (nonatomic, strong) UIButton *certifyButton;
/** 粉丝*/
@property (nonatomic, strong) JHUserInfoDetailView *fansView;
/** 关注*/
@property (nonatomic, strong) JHUserInfoDetailView *followView;
/** 获赞*/
@property (nonatomic, strong) JHUserInfoDetailView *likeView;
/** 擅长鉴定*/
@property (nonatomic, strong) UILabel *goodAtLabel;
/** 鉴定详情视图*/
@property (nonatomic, strong) UIView *determineView;
/** 鉴定次数*/
@property (nonatomic, strong) UILabel *determineCountLabel;
/** 分割线*/
@property (nonatomic, strong) UIView *leftLineView;
/** 满意度*/
@property (nonatomic, strong) UILabel *pleasedRateLabel;
/** 分割线*/
@property (nonatomic, strong) UIView *rightLineView;
/** 查看用户评价*/
@property (nonatomic, strong) UIButton *seeCommentButton;
/** 鉴定师证书列表*/
@property (nonatomic, strong) UICollectionView *collectionView;
/** 头像按钮*/
@property (nonatomic, strong) UIButton *headImageButton;
/** 直播中*/
//@property (nonatomic, strong) UIButton *livingButton;
@property (strong, nonatomic) UIButton *liveStatus;
@property (strong, nonatomic) UIImageView *playImage;
@property (strong, nonatomic) UIView *lineView;
/** 鉴定师介绍栏*/
@property (nonatomic, strong) UIView *introView;
/** 鉴定师介绍*/
@property (nonatomic, strong) UILabel *introTagLabel;
/** 鉴定师详情*/
@property (nonatomic, strong) UILabel *introDesLabel;

/** 证书数据*/
@property (nonatomic, strong) NSArray *certifyArray;

@end

@implementation JHGemmologistHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = kColorF5F6FA;
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.effectView];
    [self addSubview:self.infoView];
    [self.infoView addSubview:self.attentionButton];
    [self.infoView addSubview:self.namelabel];
    [self.infoView addSubview:self.numberLabel];
    [self.infoView addSubview:self.certifyButton];
    [self.infoView addSubview:self.fansView];
    [self.infoView addSubview:self.followView];
    [self.infoView addSubview:self.likeView];
    [self.infoView addSubview:self.goodAtLabel];
    [self.infoView addSubview:self.determineView];
    [self.determineView addSubview:self.determineCountLabel];
    [self.determineView addSubview:self.leftLineView];
    [self.determineView addSubview:self.pleasedRateLabel];
    [self.determineView addSubview:self.rightLineView];
    [self.determineView addSubview:self.seeCommentButton];
    [self.infoView addSubview:self.collectionView];
    [self.infoView addSubview:self.lineView];
    [self.infoView addSubview:self.introView];
    [self.introView addSubview:self.introTagLabel];
    [self.introView addSubview:self.introDesLabel];
    
    [self addSubview:self.headImageButton];
    [self addSubview:self.liveStatus];
    [self.liveStatus addSubview:self.playImage];
    self.infoView.height = self.introView.bottom;
    self.height = self.infoView.bottom + 10;
}

- (void)reSetSunbviewsUI{
    CGFloat height = [self.model.appraise.goodAt getHeightWithFont:[UIFont fontWithName:kFontNormal size:12] constrainedToSize:CGSizeMake(ScreenW - 30, 40)];
    if (height > [UIFont fontWithName:kFontNormal size:12].lineHeight * 2) {
        height = [UIFont fontWithName:kFontNormal size:12].lineHeight * 2;
    }
    self.goodAtLabel.frame = CGRectMake(15, self.fansView.bottom + 10, kScreenWidth - 30, height);
    self.determineView.frame = CGRectMake(15, self.goodAtLabel.bottom + 10, kScreenWidth - 30, 60);
    if (self.model.appraise.certificationFiles.count > 0) {
        self.collectionView.frame = CGRectMake(0, self.determineView.bottom + 10, kScreenWidth, 155);
    }else{
        self.collectionView.frame = CGRectMake(0, self.determineView.bottom + 10, kScreenWidth, 0);
    }
    
    self.lineView.frame = CGRectMake(0, self.collectionView.bottom, kScreenWidth, 10);
    
    CGFloat desHeight = [self.model.appraise.appraiserIntroduction getHeightWithFont:[UIFont fontWithName:kFontNormal size:12] constrainedToSize:CGSizeMake(ScreenW - 30, 54)];
    if (desHeight > [UIFont fontWithName:kFontNormal size:12].lineHeight * 3) {
        desHeight = [UIFont fontWithName:kFontNormal size:12].lineHeight * 3;
    }
    self.introDesLabel.frame = CGRectMake(15, self.introTagLabel.bottom + 10, kScreenWidth - 30, desHeight);
    if (desHeight > 0) {
        self.introView.frame = CGRectMake(0, self.lineView.bottom, kScreenWidth, 61 + desHeight);
        self.lineView.backgroundColor = kColorF5F6FA;
    }else{
        self.introView.frame = CGRectMake(0, self.lineView.bottom, kScreenWidth, 0);
        self.lineView.backgroundColor = [UIColor whiteColor];
    }
    
    self.infoView.height = self.introView.bottom;
    self.height = self.infoView.bottom + 10;
    
    if (self.changeHeightBlock) {
        self.changeHeightBlock(self.height);
    }
}

#pragma mark - 处理数据
- (void)setModel:(JHAnchorHomeModel *)model{
    _model = model;
    [self.backImageView jh_setAvatorWithUrl:model.appraise.appraiserImg];
    self.attentionButton.selected = model.is_follow;
    [self.headImageButton sd_setImageWithURL:[NSURL URLWithString:model.appraise.appraiserImg] forState:UIControlStateNormal placeholderImage:kDefaultAvatarImage];
    self.namelabel.text = model.appraise.appraiserName;
    self.numberLabel.text = [NSString stringWithFormat:@"宝友号：%@", model.appraise.customerId ? : @""];
    self.fansView.value = model.fans_num;
    self.followView.value = model.follow_user_num;
    self.likeView.value = model.like_num;
    self.goodAtLabel.text = [NSString stringWithFormat:@"擅长鉴定: %@", model.appraise.goodAt];
    self.introDesLabel.text = model.appraise.appraiserIntroduction;
    if (model.appraise.status > 1) {
        self.liveStatus.hidden = NO;
        self.headImageButton.layer.borderWidth = 2;
    }else{
        self.liveStatus.hidden = YES;
        self.headImageButton.layer.borderWidth = 0;
    }
    NSMutableArray *itemsArray = [NSMutableArray array];
    itemsArray[0] = @{@"string":@"鉴定次数 ", @"color":kColor333, @"font":[UIFont fontWithName:kFontMedium size:12]};
    itemsArray[1] = @{@"string":@(model.appraise.appraiseCount).stringValue, @"color":kColor333, @"font":[UIFont fontWithName:kFontMedium size:16]};
    self.determineCountLabel.attributedText = [NSString mergeStrings:itemsArray];
    NSMutableArray *itemsArray2 = [NSMutableArray array];
    itemsArray2[0] = @{@"string":@"满意度 ", @"color":kColor333, @"font":[UIFont fontWithName:kFontMedium size:12]};
    itemsArray2[1] = @{@"string":[NSString stringWithFormat:@"%.2f%%", model.appraise.grade.doubleValue], @"color":kColor333, @"font":[UIFont fontWithName:kFontMedium size:16]};
    self.pleasedRateLabel.attributedText = [NSString mergeStrings:itemsArray2];
    self.certifyArray = model.appraise.certificationFiles;
    [self.collectionView reloadData];
    
    ///关注按钮
    if ([self isUserSelf]) {
        ///是本人  编辑资料
        [self.attentionButton setTitle:@"编辑资料" forState:UIControlStateNormal];
    }
    else {///他人
        if (model.is_follow) {
            [self gradientColorForFollowButton:@[kColorEEE, kColorEEE]];
            [self.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
            [self.attentionButton setTitleColor:kColor999 forState:UIControlStateNormal];
            [self.attentionButton setTitleColor:kColor999 forState:UIControlStateHighlighted];
        }
        else {
            [self gradientColorForFollowButton:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)]];
            [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
            [self.attentionButton setTitleColor:kColor333 forState:UIControlStateNormal];
            [self.attentionButton setTitleColor:kColor333 forState:UIControlStateHighlighted];
        }
    }
    
    [self reSetSunbviewsUI];
}

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY {
    self.backImageView.frame = CGRectMake(0, contentOffsetY, kScreenWidth, kScreenWidth / 375 * 188 - contentOffsetY);
    self.effectView.frame = self.backImageView.bounds;
}
#pragma mark -- 响应事件
- (JHUserInfoDetailView *)createControlWithBlockType:(JHDetailBlockType)blockType {
    JHUserInfoDetailView *control = [JHUserInfoDetailView new];
    control.exclusiveTouch = YES;
    @weakify(self);
    control.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *touch = touches.anyObject;
            CGPoint p = [touch locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                //点击事件
                [self handleClickEvent:blockType];
            }
        }
    };
    return control;
}

/** 关注*/
- (void)followAction:(UIButton *)btn {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    if ([self isUserSelf]) {
        ///作者本人
        [self enterPersonalPage];
        return;
    }
    if (self.model.is_follow) {
        ///已关注 需要取消关注
        [self toCancelFollow];
    }
    else {
        [self toFollow];
    }
}
/** 按钮渐变色*/
- (void)gradientColorForFollowButton:(NSArray <UIColor *>*)colors {
    [self.attentionButton jh_setGradientBackgroundWithColors:colors locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}
///进入个人信息界面
- (void)enterPersonalPage {
    JHPersonalViewController *vc = [[JHPersonalViewController alloc] init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
///关注用户
- (void)toFollow {
    @weakify(self);
    [JHUserInfoApiManager followUserAction:self.model.appraise.customerId fansCount:0 completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            [UITipView showTipStr:@"关注成功"];
            [self updateFansInfo:respObj isFollow:YES];
            [JHAuthorize clickTriggerPushAuthorizetion:JHAuthorizeClickTypeAppraisalFollow];
        }
    }];
}

///取消关注
- (void)toCancelFollow {
    @weakify(self);
    [JHUserInfoApiManager cancelFollowUserAction:self.model.appraise.customerId fansCount:0 completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            [self updateFansInfo:respObj isFollow:NO];
        }
    }];
}

///点击关注按钮后修改关注状态
- (void)updateFansInfo:(id)respObj isFollow:(BOOL)isFollow {
    RequestModel *responseObject = (RequestModel *)respObj;
    self.model.fans_num = responseObject.data[@"fans_num"];
    self.model.is_follow = isFollow;
    self.attentionButton.selected = self.model.is_follow;
    self.fansView.value = self.model.fans_num;
    if (isFollow) {
        [self gradientColorForFollowButton:@[kColorEEE, kColorEEE]];
        [self.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:kColor999 forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:kColor999 forState:UIControlStateHighlighted];
    }
    else {
        [self gradientColorForFollowButton:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)]];
        [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:kColor333 forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:kColor333 forState:UIControlStateHighlighted];
    }
    if (self.followClickBlock) {
        self.followClickBlock(self.model.is_follow);
    }
}

/** 是否是本人*/
- (BOOL)isUserSelf{
    return [JHSQManager isAccount:self.model.appraise.customerId];
}

- (void)handleClickEvent:(JHDetailBlockType)blockType {
    /** 粉丝2   关注1*/
    switch (blockType) {
        case JHDetailBlockTypeFans:{
            [JHRouterManager pushUserFriendWithController:self.viewController type:2 userId:[self.model.appraise.customerId integerValue] name:self.model.appraise.appraiserName];
        }
            break;
        case JHDetailBlockTypeFollow:
        {
            [JHRouterManager pushUserFriendWithController:self.viewController type:1 userId:[self.model.appraise.customerId integerValue] name:self.model.appraise.appraiserName];
        }
            break;
        case JHDetailBlockTypeLike:
        {
            [JHZanHUD showText:[NSString stringWithFormat:@"\"%@\"共获得%@个赞", self.model.appraise.appraiserName, self.model.like_num]];
        }
            break;
        default:
            break;
    }
}

/** 查看用户评价*/
- (void)seeUserCommentAction{
    JHGemmologistCommentViewController *commentVc = [[JHGemmologistCommentViewController alloc] init];
    commentVc.anchorId = self.model.appraise.customerId;
    [self.viewController.navigationController pushViewController:commentVc animated:YES];
    
    [JHGrowingIO trackEventId:JHTrackProfileEvaluateClick];
}
/** 进入直播间*/
- (void)goToLivingRoom {
    NSString *url = [NSString stringWithFormat:@"/channel/detail/authoptional?clientType=commonlink&channelId=%@",self.model.appraise.roomId];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(url) Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        if ([channel.status integerValue]==2)
        {
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.channel = channel;
            vc.coverUrl = channel.coverImg;
            vc.fromString = JHLiveFromanchorIntroduce;
            [self.viewController.navigationController pushViewController:vc animated:YES];
            
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}

/** 返回到直播间*/
- (void)backToLivingRoom{
    [self.viewController.navigationController popViewControllerAnimated:YES];
}


- (void)headImageButtonClickAction{
    if (self.model.appraise.status <= 1) {
        /** 查看大图*/
        if(self.model.appraise.appraiserImg) {
            [JHPhotoBrowserManager showPhotoBrowserThumbImages:@[self.model.appraise.appraiserImg] mediumImages:@[self.model.appraise.appraiserImg]  origImages:@[self.model.appraise.appraiserImg]  sources:@[self.headImageButton.imageView] currentIndex:0 canPreviewOrigImage:NO showStyle:GKPhotoBrowserShowStyleZoom];
        }
    }else{
        //进入直播
        if (self.isFromLivingRoom) {
            [self backToLivingRoom];
        }else{
            [self goToLivingRoom];
        }
    }
}

#pragma mark -collectionview 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.certifyArray.count;  //每个section的Item数
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHGemmologistCertificateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHGemmologistCertificateCell class]) forIndexPath:indexPath];
    cell.dict = self.certifyArray[indexPath.row];
    return cell;
}
#pragma mark --UI绘制

- (UIImageView *)backImageView{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 375 * 188)];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.clipsToBounds = YES;
        _backImageView.image = kDefaultAvatarImage;
    }
    return _backImageView;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.alpha = 0.8;
        _effectView.frame= self.backImageView.bounds;
    }
    return _effectView;
}

- (UIView *)infoView{
    if (_infoView == nil) {
        _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backImageView.bottom - 10, kScreenWidth, 61)];
        _infoView.backgroundColor = [UIColor whiteColor];
        [_infoView yd_setCornerRadius:12 corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    }
    return _infoView;
}

- (UIButton *)headImageButton{
    if (_headImageButton == nil) {
        _headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headImageButton.frame = CGRectMake(15, self.infoView.top - 40, 80, 80);
        _headImageButton.layer.cornerRadius = 40;
        _headImageButton.clipsToBounds = YES;
        _headImageButton.layer.borderColor = RGB(254, 225, 0).CGColor;
        _headImageButton.layer.borderWidth = 0;
        _headImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headImageButton setImage:kDefaultAvatarImage forState:UIControlStateNormal];
        [_headImageButton addTarget:self action:@selector(headImageButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headImageButton;
}

//- (UIButton *)livingButton{
//    if (_livingButton == nil) {
//        _livingButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _livingButton.frame = CGRectMake(self.headImageButton.left + 10, self.headImageButton.bottom - 20, 60, 20);
//        _livingButton.layer.cornerRadius = 2;
//        _livingButton.backgroundColor = RGB(254, 225, 0);
//        _livingButton.layer.borderColor = [UIColor whiteColor].CGColor;
//        _livingButton.layer.borderWidth = 2;
//        _livingButton.clipsToBounds = YES;
//        [_livingButton setTitle:@"直播中" forState:UIControlStateNormal];
//        [_livingButton setTitleColor:kColor333 forState:UIControlStateNormal];
//        _livingButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:10];
//        _livingButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        [_livingButton addTarget:self action:@selector(headImageButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
//        _livingButton.hidden = YES;
//    }
//    return _livingButton;
//}
- (UIButton *)liveStatus{
    if (_liveStatus == nil) {
        _liveStatus = [UIButton buttonWithType:UIButtonTypeCustom];
        _liveStatus.frame = CGRectMake(self.headImageButton.left + 7.5, self.headImageButton.bottom - 17, 65, 17);
        _liveStatus.layer.cornerRadius = 2;
        _liveStatus.backgroundColor = RGB(254, 225, 0);
//        _liveStatus.layer.borderColor = [UIColor whiteColor].CGColor;
//        _liveStatus.layer.borderWidth = 2;
        _liveStatus.clipsToBounds = YES;
        [_liveStatus setTitle:@"   鉴定中" forState:UIControlStateNormal];
        [_liveStatus setTitleColor:kColor333 forState:UIControlStateNormal];
        _liveStatus.titleLabel.font = [UIFont fontWithName:kFontNormal size:11];
        _liveStatus.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_liveStatus addTarget:self action:@selector(headImageButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
        _liveStatus.hidden = YES;
    }
    return _liveStatus;
}
- (UIImageView *)playImage{
    if (_playImage == nil) {
        _playImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, 15, 17)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"playingGif" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage* gifImage = [UIImage sd_imageWithGIFData:data];
        [_playImage setImage:gifImage];
    }
    return _playImage;
}

- (UIButton *)attentionButton{
    if (_attentionButton == nil) {
        _attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionButton.frame = CGRectMake(self.infoView.width - 15 - 146, 10, 146, 30);
        _attentionButton.layer.cornerRadius = 15;
        _attentionButton.clipsToBounds = YES;
        [_attentionButton addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
        _attentionButton.backgroundColor = kColorMain;
        [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
        _attentionButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_attentionButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [self gradientColorForFollowButton:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)]];
    }
    return _attentionButton;
}

- (UILabel *)namelabel{
    if (_namelabel == nil) {
        _namelabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, kScreenWidth - 30, 22)];
        _namelabel.text = @"";
        _namelabel.textColor = kColor333;
        _namelabel.font = [UIFont fontWithName:kFontMedium size:22];
    }
    return _namelabel;
}

- (UILabel *)numberLabel{
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.namelabel.bottom + 10, kScreenWidth - 30, 16)];
        _numberLabel.text = @"";
        _numberLabel.textColor = kColor999;
        _numberLabel.font = [UIFont fontWithName:kFontNormal size:11];
    }
    return _numberLabel;
}

- (UIButton *)certifyButton{
    if (_certifyButton == nil) {
        _certifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _certifyButton.frame = CGRectMake(14, self.numberLabel.bottom + 10, 80, 16); //16
        [_certifyButton setTitle:@"认证鉴定师" forState:UIControlStateNormal];
        [_certifyButton setTitleColor:kColor666 forState:UIControlStateNormal];
        _certifyButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:11];
        [_certifyButton setImage:[UIImage imageNamed:@"appraisal_video_auth"] forState:UIControlStateNormal];
        _certifyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_certifyButton setImageInsetStyle:MRImageInsetStyleLeft spacing:5];
        //        _certifyButton.hidden = YES;
        _certifyButton.clipsToBounds = YES;
    }
    return _certifyButton;
}

- (JHUserInfoDetailView *)fansView{
    if (_fansView == nil) {
        _fansView = [self createControlWithBlockType:JHDetailBlockTypeFans];
        _fansView.frame = CGRectMake(15, self.certifyButton.bottom + 10, 70, 40);
        [_fansView setTitle:@"粉丝" value:@"0"];
    }
    return _fansView;
}

- (JHUserInfoDetailView *)followView{
    if (_followView == nil) {
        _followView = [self createControlWithBlockType:JHDetailBlockTypeFollow];
        _followView.frame = CGRectMake(self.fansView.right + 10, self.certifyButton.bottom + 10, 70, 40);
        [_followView setTitle:@"关注" value:@"0"];
    }
    return _followView;
}

- (JHUserInfoDetailView *)likeView{
    if (_likeView == nil) {
        _likeView = [self createControlWithBlockType:JHDetailBlockTypeLike];
        _likeView.frame = CGRectMake(self.followView.right + 10, self.certifyButton.bottom + 10, 70, 40);
        [_likeView setTitle:@"获赞" value:@"0"];
    }
    return _likeView;
}

- (UILabel *)goodAtLabel{
    if (_goodAtLabel == nil) {
        _goodAtLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.fansView.bottom + 10, kScreenWidth - 30, 0)]; //40
        _goodAtLabel.numberOfLines = 2;
        _goodAtLabel.text = @"";
        _goodAtLabel.textColor = kColor333;
        _goodAtLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _goodAtLabel;
}

- (UIView *)determineView{
    if (_determineView == nil) {
        _determineView = [[UIView alloc] initWithFrame:CGRectMake(15, self.goodAtLabel.bottom + 10, kScreenWidth - 30, 60)];
        _determineView.backgroundColor = RGB(249, 250, 249);
        _determineView.layer.cornerRadius = 8;
        _determineView.clipsToBounds = YES;
    }
    return _determineView;
}

- (UILabel *)determineCountLabel{
    if (_determineCountLabel == nil) {
        _determineCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, (self.determineView.width - 12) / 3, self.determineView.height)];
        _determineCountLabel.text = @"鉴定次数 0";
        _determineCountLabel.textColor = kColor333;
        _determineCountLabel.font = [UIFont fontWithName:kFontMedium size:12];
        _determineCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _determineCountLabel;
}

- (UIView *)leftLineView{
    if (_leftLineView == nil) {
        _leftLineView = [[UIView alloc] initWithFrame:CGRectMake(self.determineCountLabel.right, (self.determineView.height - 21) / 2, 1, 21)];
        _leftLineView.backgroundColor = RGB(204, 204, 204);
    }
    return _leftLineView;
}

- (UILabel *)pleasedRateLabel{
    if (_pleasedRateLabel == nil) {
        _pleasedRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftLineView.right, 0, (self.determineView.width - 12) / 3, self.determineView.height)];
        _pleasedRateLabel.text = @"满意度 0.00";
        _pleasedRateLabel.textColor = kColor333;
        _pleasedRateLabel.font = [UIFont fontWithName:kFontMedium size:12];
        _pleasedRateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pleasedRateLabel;
}

- (UIView *)rightLineView{
    if (_rightLineView == nil) {
        _rightLineView = [[UIView alloc] initWithFrame:CGRectMake(self.pleasedRateLabel.right, (self.determineView.height - 21) / 2, 1, 21)];
        _rightLineView.backgroundColor = RGB(204, 204, 204);
    }
    return _rightLineView;
}

- (UIButton *)seeCommentButton{
    if (_seeCommentButton == nil) {
        _seeCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _seeCommentButton.frame = CGRectMake(self.rightLineView.right, 0, (self.determineView.width - 12) / 3, self.determineView.height);
        [_seeCommentButton setTitle:@"查看用户评价" forState:UIControlStateNormal];
        [_seeCommentButton setTitleColor:kColor333 forState:UIControlStateNormal];
        _seeCommentButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:12];
        [_seeCommentButton setImage:[UIImage imageNamed:@"appraiserImg_right_more_button"] forState:UIControlStateNormal];
        [_seeCommentButton setImageInsetStyle:MRImageInsetStyleRight spacing:5];
        [_seeCommentButton addTarget:self action:@selector(seeUserCommentAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeCommentButton;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;// 设置item的大小
        CGFloat itemW = (ScreenW - 30 - 5) / 2 ;
        layout.itemSize = CGSizeMake(itemW, 155);
        
        // 设置每个分区的 上左下右 的内边距
        layout.sectionInset = UIEdgeInsetsMake(0, 15 ,0, 15);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.determineView.bottom + 10, kScreenWidth, 0) collectionViewLayout:layout];  //185
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[JHGemmologistCertificateCell class] forCellWithReuseIdentifier:NSStringFromClass([JHGemmologistCertificateCell class])];
        _collectionView.clipsToBounds = YES;
    }
    return _collectionView;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.bottom, kScreenWidth, 10)];
        _lineView.backgroundColor = kColorF5F6FA;
    }
    return _lineView;
}

- (UIView *)introView{
    if (_introView == nil) {
        _introView = [[UIView alloc] initWithFrame:CGRectMake(0, self.lineView.bottom, kScreenWidth, 0)];
        _introView.backgroundColor = [UIColor whiteColor];
        _introView.clipsToBounds = YES;
    }
    return _introView;
}

- (UILabel *)introTagLabel{
    if (_introTagLabel == nil) {
        _introTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth - 30, 21)];
        _introTagLabel.text = @"鉴定师介绍";
        _introTagLabel.textColor = kColor333;
        _introTagLabel.font = [UIFont fontWithName:kFontMedium size:15];
    }
    return _introTagLabel;
}

- (UILabel *)introDesLabel{
    if (_introDesLabel == nil) {
        _introDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.introTagLabel.bottom + 10, kScreenWidth - 30, 54)];
        _introDesLabel.numberOfLines = 3;
        _introDesLabel.text = @"";
        _introDesLabel.textColor = kColor666;
        _introDesLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _introDesLabel;
}
@end
