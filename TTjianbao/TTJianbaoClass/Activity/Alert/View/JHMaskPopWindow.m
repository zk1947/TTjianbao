//
//  JHMaskPopWindow.m
//  TTjianbao
//
//  Created by lihui on 2020/6/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHMaskPopWindow.h"
#import "UIImageView+JHWebImage.h"
#import "JHAppAlertViewManger.h"
#import "JHGrowingIO.h"
#import "JHMaskingManager.h"
#import "JHStoreNewRedpacketModel.h"


@interface JHMaskPopWindow ()

@property (nonatomic, strong) UIView *bgView;
///弹窗图片
@property (nonatomic, strong) YYAnimatedImageView *popImageView;
///弹出红包详情图片
@property (nonatomic, strong) YYAnimatedImageView *popDetialImageView;

///取消按钮
@property (nonatomic, strong) UIButton *cancelButton;
///小图按钮
@property (nonatomic, strong) UIButton *littleImageButton;

@property (nonatomic, copy) NSString *popImage;
@property (nonatomic, assign) JHPopPlaceStyle placeStyle;
@property (nonatomic, assign) JHPopCancelPosition cancelPosition;
@property (nonatomic, assign) CGSize popImageSize;
@property (nonatomic, assign) CGSize buttonSize;
@property (nonatomic, assign) CGFloat bottomHeight;
///用于临时接受网络图片,之前是局部创建，会有提前释放的问题
@property(nonatomic,strong)YYAnimatedImageView *tempImgView;
@property(nonatomic,strong)NSArray *imgsArr;
@property(nonatomic,assign)JHPopRedpacketStyle popRedpacketStyle;

@property (nonatomic, copy) void(^actionBlock)(BOOL isEnter);

@end

static JHMaskPopWindow *shareWindow = nil;

@implementation JHMaskPopWindow

+ (instancetype)defaultWindow {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareWindow = [[JHMaskPopWindow alloc] init];
    });
    return shareWindow;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _placeStyle = JHPopPlaceStyleCombine;
        _bottomHeight = 10.f;

    }
    return self;
}

+ (void)showPopWindowWithPopImage:(NSString *)popImage
                     popImageSize:(CGSize)popImageSize
                         popStyle:(JHPopPlaceStyle)placeStyle
                   cancelPosition:(JHPopCancelPosition)cancelPosition
                      actionBlock:(void(^)(BOOL isEnter))actionBlock {
    
    [[self defaultWindow] createPopWindowWithPopImage:popImage popImageSize:popImageSize popPlaceStyle:placeStyle cancelPosition:cancelPosition completeBlock:actionBlock];
}

- (void)createPopWindowWithPopImage:(NSString *)popImage
                       popImageSize:(CGSize)popImageSize
                      popPlaceStyle:(JHPopPlaceStyle)popStyle
                     cancelPosition:(JHPopCancelPosition)cancelPosition
                      completeBlock:(void(^)(BOOL isEnter))block {

    _popImage = popImage;
    _placeStyle = popStyle;
    _popImageSize = popImageSize;
    _cancelPosition = cancelPosition;
    _actionBlock = block;
    // 先获取网络图片
    if ([JHMaskPopWindow isUrl:popImage]) {
        /// 是网络图片
        self.imgsArr = [popImage componentsSeparatedByString:@"img1&&&&&img2"];
        __weak JHMaskPopWindow *weakSelf = self;
        [self.tempImgView setImageWithURL:[NSURL URLWithString:self.imgsArr[0]] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            // 获取图片成功后再搭建UI
            __strong JHMaskPopWindow *strongSelf = weakSelf;
            if (error) {
                //错误提示
            }else
            {
                [strongSelf configUIWithImage:image];
            }
        }];
    }
    else {
        [self configUI];
    }
}
- (void)configUI {
    if (_bgView) {
        return;
    }
    // 大背景
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UIView *view = JHRootController.homeTabController.view;
    [view addSubview:bgView];
    bgView.frame = view.bounds;
    
    _bgView = bgView;
    [_bgView addSubview:self.popImageView];
    [_bgView addSubview:self.cancelButton];

    [self setupLayouts];
}
- (void)configUIWithImage:(UIImage *)image
{
    if (_bgView) {
        return;
    }
    // 大背景
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UIView *view = JHRootController.homeTabController.view;
    [view addSubview:bgView];
    bgView.frame = view.bounds;
    
    _bgView = bgView;
    [_bgView addSubview:self.popImageView];
    self.popDetialImageView.hidden = YES;
    [_bgView addSubview:self.popDetialImageView];
    [_bgView addSubview:self.cancelButton];

    [self setupLayoutsWithImage:image];
}
- (void)setupLayouts {
    self.popImageView.frame = CGRectMake(0, 0, self.popImageSize.width, self.popImageSize.height);
    self.popImageView.image = [UIImage imageNamed:_popImage];
    
    if (_placeStyle == JHPopPlaceStyleSeparate) {
        self.popImageView.center = CGPointMake(self.bgView.bounds.size.width/2, self.bgView.bounds.size.height/2 - _buttonSize.height);
    }
    else {
        self.popImageView.center = self.bgView.center;
    }
    
    [self makeCancelBtnLayout];
}
- (void)setupLayoutsWithImage:(UIImage *)image
{
    [self makeFirstRedpacket:image];
    [self makeSecondRedpacketWithHiddsn:YES];
    [self makeCancelBtnLayout];
}
-(void)makeFirstRedpacket:(UIImage *)image
{
    self.popImageView.frame = CGRectMake(0, 0, self.popImageSize.width, self.popImageSize.height);
      self.popImageView.image = image;
      self.popImageView.center = self.bgView.center;
}
-(void)makeSecondRedpacketWithHiddsn:(BOOL)isHidden
{
    self.popImageView.hidden = !isHidden;
    self.popDetialImageView.hidden = isHidden;
    if(IS_STRING(self.imgsArr[1]))
    {
        [self.popDetialImageView setImageURL:[NSURL URLWithString:self.imgsArr[1]]];
    }
}
- (void)makeCancelBtnLayout {
    if (_cancelPosition == JHPopCancelPositionTopRight) {
        if(self.popRedpacketStyle == JHPopRedpacketStyleFirst)
        {
            self.cancelButton.bottom = _popImageView.top - 15;
            self.cancelButton.right = _popImageView.right + 8;
        }else{
            
            self.cancelButton.bottom = self.popDetialImageView.top - 15;
            self.cancelButton.left = self.popDetialImageView.right - 26;
            
        }

        return;
    }
    if (_cancelPosition == JHPopCancelPositionBottomCenter) {
        _cancelButton.centerX = _popImageView.centerX;
        if (self.placeStyle == JHPopPlaceStyleSeparate) {
            self.cancelButton.top = _popImageView.bottom + 50;
        }
        else {
            self.cancelButton.top = _popImageView.bottom + 50;
        }
        return;
    }
}

- (YYAnimatedImageView *)popImageView {
    if (!_popImageView) {
        YYAnimatedImageView *popImage = [[YYAnimatedImageView alloc] init];
        popImage.userInteractionEnabled = YES;
        popImage.contentMode = UIViewContentModeScaleAspectFit;
        JH_WEAK(self);
        [popImage jh_addTapGesture:^{
            JH_STRONG(self);
            [self popButtonAction];
        }];
        _popImageView = popImage;
    }
    return _popImageView;
}
- (YYAnimatedImageView *)popDetialImageView {
    if (!_popDetialImageView) {
        _popDetialImageView = [[YYAnimatedImageView alloc] init];
        _popDetialImageView.userInteractionEnabled = YES;
        _popDetialImageView.contentMode = UIViewContentModeScaleAspectFit;
        _popDetialImageView.frame = CGRectMake(0, 0, 300, 359);
        _popDetialImageView.center = self.bgView.center;
        JH_WEAK(self);
        [_popDetialImageView jh_addTapGesture:^{
            JH_STRONG(self);
            [self pushRedpackLiveRoom];
        }];
    }
    return _popDetialImageView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 40, 40)];
        [cancelBtn setImage:[UIImage imageNamed:@"icon_user_cancel"] forState:UIControlStateNormal];
        [cancelBtn setImage:[UIImage imageNamed:@"icon_user_cancel"] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = cancelBtn;
    }
    return _cancelButton;
}

- (UIButton *)littleImageButton {
    if (!_littleImageButton) {
        UIButton *littleImageButton = [[UIButton alloc] init];
        [littleImageButton setImage:[UIImage imageNamed:@"icon_new_redpage_little"] forState:UIControlStateNormal];
        [littleImageButton setImage:[UIImage imageNamed:@"icon_new_redpage_little"] forState:UIControlStateHighlighted];
        [littleImageButton addTarget:self action:@selector(littleBtnAction) forControlEvents:UIControlEventTouchUpInside];
        littleImageButton.frame = CGRectMake(6, ScreenH - 55.f - UI.tabBarHeight - 51.f, 56, 51);
        littleImageButton.layer.zPosition = 1000;
        _littleImageButton = littleImageButton;
    }
    return _littleImageButton;
}
-(void)popRedpacketAction
{
    if (self.actionBlock)
    {
        self.actionBlock(YES);
    }
}
#pragma mark - 显示红包详情
/**
 1.未登录-登录后判断，是否领取过。
            已领取：不显示红包详情
            未领取：显示红包详情
 2.已登录：已领取：一级红包不显示
        未领取：显示红包详情
 */
-(void)showDetailRedpacket
{
    [self makeSecondRedpacketWithHiddsn:NO];
}
- (void)popButtonAction {
    [JHGrowingIO trackEventId:JHNewuserGiftDialogOperate variables: @{@"is_next":@"1"}];
    [self popRedpacketAction];
}
- (void)updateRedpacketDetail
{
    self.popRedpacketStyle = JHPopRedpacketStyleDetailSecond;
    [self makeCancelBtnLayout];

}
- (void)cancel {
    switch (self.popRedpacketStyle) {
        case JHPopRedpacketStyleFirst:
                [JHGrowingIO trackEventId:JHNewuserGiftDialogOperate variables: @{@"is_next":@"0"}];
                if (self.actionBlock) {
                self.actionBlock(NO);
                }
            break;
        case JHPopRedpacketStyleDetailSecond:
                [JHGrowingIO trackEventId:JHNewuserGiftGetDialogOperate variables: @{@"is_next":@"0"}];
            [JHMaskPopWindow dismiss];
            break;
        default:
        {
            [JHMaskPopWindow dismiss];
        }
            break;
    }

}
-(void)pushRedpackLiveRoom
{
    [JHGrowingIO trackEventId:JHNewuserGiftGetDialogOperate variables: @{@"is_next":@"1"}];
    self.popRedpacketStyle = JHPopRedpacketStyleDetailSecond;
       if(self.redpacketModel.isHasChannel)
        {
            [JHMaskPopWindow dismiss];
            [JHRootController EnterLiveRoom:self.redpacketModel.channelLocalId fromString:@"newcomerRedPacket"];
        }else
        {
            [UITipView showTipStr:@"暂时没有直播间"];
        }
}
- (void)littleBtnAction {
    [JHMaskingManager showPopWindowWithType:JHMaskPopWindowTypeRedbag];
    self.popRedpacketStyle = JHPopRedpacketStyleFirst;
    [self.littleImageButton removeFromSuperview];
    [JHGrowingIO trackEventId:JHClickChannelNewUserClick variables: @{@"receive":@"true"}];
}

+ (void)dismiss {
    [[self defaultWindow] removeWindow];
    [[self defaultWindow] removeLittleBtn];
}

- (void)removeWindow {
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    [JHAppAlertViewManger appAlertshowing:NO];
    [JHAppAlertViewManger publishChangeTimeIntervalStatus];
}
+(void)removeLittleBtn
{
    [[self defaultWindow] removeLittleBtn];
}
- (void)removeLittleBtn {
    if (_littleImageButton) {
        [_littleImageButton removeFromSuperview];
        _littleImageButton = nil;
    }
}
-(void)makeLittleImage:(JHStoreNewRedpacketModel *)model
{
    [self littleImageButton];
    [self.cancelButton removeFromSuperview];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.popImageView.frame = self.littleImageButton.frame;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
        ///只在源头直播显示小图标
        [[JHRootController tabControllerWithIndex:1].view addSubview:self.littleImageButton];
    }];
    [JHAppAlertViewManger appAlertshowing:NO];
//    [JHAppAlertViewManger publishChangeTimeIntervalStatus];

}
- (void)closeToLittle {
    
    [self makeLittleImage:self.redpacketModel];
}

+ (BOOL)isUrl:(NSString *)str {
    BOOL isUrl  = NO;
    if ([str hasPrefix:@"http"]) {
        isUrl = YES;
    }
    return isUrl;
}

- (BOOL)isPop {
    if (_bgView) {
        return YES;
    }
    return NO;
}
-(YYAnimatedImageView *)tempImgView
{
    if(!_tempImgView)
    {
        _tempImgView = [YYAnimatedImageView new];
    }
    return _tempImgView;
}

@end
