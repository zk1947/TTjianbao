//
//  NTESPreviewInnerView.m
//  TTjianbao
//
//  Created by Simon Blue on 17/3/21.
//  Copyright © 2017年 Netease. All rights reserved.
//
#import "NTESPreviewInnerView.h"
#import "UIView+NTES.h"
#import "NTESGLView.h"
#import "NTESLiveManager.h"
#import "NTESAnchorLiveViewController.h"
#import "NTESLiveCoverView.h"
#import "NTESOrientationSelectView.h"
#import "NTESFilterMenuBar.h"
#import "NTESFiterMenuView.h"
#import "NTESLiveUtil.h"
#import "UIView+Toast.h"
#import "UMengManager.h"
#import "ChannelMode.h"
#import "UserInfoRequestManager.h"
#import "TTjianbaoHeader.h"
#import "JHBaseOperationView.h"
#import "UITextField+PlaceHolderColor.h"
#import "WXApi.h"

#define orientationSelectViewHeight 100

@interface NTESPreviewInnerView ()<NTESLiveCoverViewDelegate,NTESOrientationSelectViewDelegate,NTESMenuViewProtocol, UITextFieldDelegate> {
    
}

@property (nonatomic, strong) UIButton *startLiveButton;          //开始直播按钮

@property (nonatomic, strong) UIButton *closeButton;              //关闭直播按钮

@property (nonatomic, strong) UIButton *orientationButton;        //方向按钮

@property (nonatomic, strong) UIButton *cameraButton;              //切换摄像头按钮

@property (nonatomic, strong) UIButton *beautifyButton;             //美颜按钮

@property (nonatomic, strong) NTESGLView  *preView;                 //预览视图

@property (nonatomic, strong) NTESLiveCoverView    *coverView;     //状态覆盖层

@property (nonatomic, copy)   NSString *roomId;                   //聊天室ID

@property (nonatomic, strong) NTESOrientationSelectView *orientationSelectView; //方向选择view

@property (nonatomic) BOOL showOrientataionView;

@property (nonatomic) BOOL showFilterBar;

@property (nonatomic) NIMVideoOrientation orientation;

@property (nonatomic, strong) NTESFilterMenuBar *filterBar;


@property (nonatomic, strong) UITextField *titleText;

@property (nonatomic, strong) NSMutableArray *shareArray;

@end
@implementation NTESPreviewInnerView

- (instancetype)initWithChatroom:(NSString *)chatroomId
                           frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.roomId = chatroomId;
        self.orientation = NIMVideoOrientationPortrait;
        [self setup];
    }
    return self;
}

-(void)setup
{
    UIControl *backView = [[UIControl alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.2];
    [backView addTarget:self action:@selector(hidenKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backView];
    
    [self addSubview: self.startLiveButton];
    [self addSubview: self.closeButton];
   // [self addSubview: self.orientationButton];
    [self addSubview: self.cameraButton];
  //  [self addSubview: self.beautifyButton];
  //  [self addSubview: self.orientationSelectView];
  //  [self addSubview: self.filterBar];
    

    //添加标题和分享等
    UILabel *label = [UILabel new];
    label.text = @"准备直播";
    label.textColor = HEXCOLOR(0xd6dad9);
    label.font = [UIFont systemFontOfSize:18];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(109.f);
    }];
    
    UILabel *titleDes = [UILabel new];
    titleDes.text = @"直播标题";
    titleDes.textColor = label.textColor;
    titleDes.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleDes];
    [titleDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label).offset(47.f);
        make.leading.equalTo(self).offset(15.f);
    }];
    
    _titleText = [UITextField new];
    _titleText.font = [UIFont systemFontOfSize:20];
    _titleText.textColor = label.textColor;
    _titleText.placeholder = @"请输入本次直播标题";
    [_titleText placeHolderColor:label.textColor];
//    [_titleText setValue:label.textColor forKeyPath:@"_placeholderLabel.textColor"];
    _titleText.delegate = self;
    [self addSubview:_titleText];
    
    [_titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleDes.mas_bottom).offset(13.f);
        make.leading.equalTo(titleDes);
        make.height.equalTo(@40.f);
        make.right.equalTo(self).offset(-15.);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = label.textColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(_titleText);
        make.height.equalTo(@1.f);
        make.top.equalTo(_titleText.mas_bottom);
    }];
    
    UILabel *shareLabel = [UILabel new];
    shareLabel.text = @"分享精彩直播";
    shareLabel.textColor = label.textColor;
    shareLabel.font = titleDes.font;
    [self addSubview:shareLabel];
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(33.f);
        make.leading.equalTo(titleDes);
    }];
    
    NSMutableArray *images = [NSMutableArray array];
    self.shareArray = [NSMutableArray array];
    if ([WXApi isWXAppInstalled]) {
        [self.shareArray addObject:@(UMSocialPlatformType_WechatSession)];
        [self.shareArray addObject:@(UMSocialPlatformType_WechatTimeLine)];
        [images addObject:@"icon_wx_friend"];
        [images addObject:@"icon_wx_circle"];
    }
    
    if ([[UMengManager shareInstance] isInstall:UMSocialPlatformType_Sina]) {
        [images addObject:@"icon_sina_wb"];
        [self.shareArray addObject:@(UMSocialPlatformType_Sina)];

    }
    

    if ([[UMengManager shareInstance] isInstall:UMSocialPlatformType_QQ]) {
        [images addObject:@"icon_QQ_firend"];
        [self.shareArray addObject:@(UMSocialPlatformType_QQ)];

    }


    for (int i = 0; i < images.count; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        btn.tag = [self.shareArray[i] integerValue];
        [btn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(shareLabel.mas_bottom).offset(8);
            make.leading.equalTo(self).offset(i*50+5);
            make.height.equalTo(@30);
            make.width.equalTo(@50);
        }];
    }

    [self addSubview: self.coverView];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.showOrientataionView&&!self.showFilterBar) {
        return;
    }
    
    UITouch *touch = [touches anyObject];

    if (self.showFilterBar) {
        
        CGPoint point = [touch locationInView:_filterBar];

        if (![_filterBar pointInside:point withEvent:nil]) {

            [self.filterBar cancel];
        }
    }
    
    else if (self.showOrientataionView)
    {
        CGPoint point = [touch locationInView:_orientationSelectView];

        if (![_orientationSelectView pointInside:point withEvent:nil]) {
            
            [UIView animateWithDuration:0.5 animations:^{
                if (_orientation == NIMVideoOrientationPortrait) {
                    _orientationSelectView.bottom = self.height + orientationSelectViewHeight;
                }
                
                else
                {
                    _orientationSelectView.bottom = self.width + orientationSelectViewHeight;
                }

            } completion:^(BOOL finished) {
                self.showOrientataionView = NO;
            }];
        }
    }
}

- (void)dismissFilterBar
{
    [UIView animateWithDuration:0.5 animations:^{
        _filterBar.bottom = self.height + _filterBar.height;
    } completion:^(BOOL finished) {
        self.showFilterBar = NO;
    }];

}

- (NTESFilterMenuBar *)filterBar
{
    if (!_filterBar)
    {
        _filterBar = [[NTESFilterMenuBar alloc] init];
        _filterBar.delegate = self;
        _filterBar.selectBlock = ^(NSInteger index) {
            [[NIMAVChatSDK sharedSDK].netCallManager selectBeautifyType:(NIMNetCallFilterType)[NTESLiveUtil changeToLiveType:index]];
        };
        
        _filterBar.contrastChangedBlock = ^(CGFloat value) {
            [[NIMAVChatSDK sharedSDK].netCallManager setContrastFilterIntensity:value];
        };
        
        _filterBar.smoothChangedBlock = ^(CGFloat value) {
            [[NIMAVChatSDK sharedSDK].netCallManager setSmoothFilterIntensity:value];
        };
    }
    return _filterBar;
}


-(void)layoutSubviews
{
    
    if (self.orientation == NIMVideoOrientationPortrait) {
        
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(UI.statusBarHeight+2.);
            make.height.width.equalTo(@(UI.navBarHeight));
            make.leading.equalTo(self);
        }];
        
        [_cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(_closeButton);
            make.trailing.equalTo(self);
        }];
        
        [_startLiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.leading.equalTo(self).offset(59);
            make.height.equalTo(@50);
            make.bottom.equalTo(self).offset(-120);
        }];
    
        _cameraButton.centerX = self.width/2;
        _cameraButton.bottom = self.height - 25;
        
        _orientationButton.centerY = _cameraButton.centerY;
        _orientationButton.right = _cameraButton.left - 25;
        
        _beautifyButton.centerY = _cameraButton.centerY;
        _beautifyButton.left = _cameraButton.right + 25;
        
        _orientationSelectView.width = self.width;
        _orientationSelectView.height = orientationSelectViewHeight;
        _orientationSelectView.left = 0;
        _orientationSelectView.bottom = self.showOrientataionView? self.height: self.height+orientationSelectViewHeight;
        
        _filterBar.width = self.width;
        _filterBar.height = _filterBar.barHeight;
        _filterBar.left  = 0;
        _filterBar.bottom = self.showFilterBar? self.height: self.height+_filterBar.barHeight;

    }
    
    else
    {
        
        _cameraButton.centerX = self.height/2;
        _cameraButton.bottom = self.width - 25;
        
        _orientationButton.centerY = _cameraButton.centerY;
        _orientationButton.right = _cameraButton.left - 25;
        
        _beautifyButton.centerY = _cameraButton.centerY;
        _beautifyButton.left = _cameraButton.right + 25;
        
        _orientationSelectView.width = self.height;
        _orientationSelectView.height = orientationSelectViewHeight;
        _orientationSelectView.left = 0;
        _orientationSelectView.bottom = self.showOrientataionView? self.width: self.width+orientationSelectViewHeight;
        
        _filterBar.width = self.height;
        _filterBar.height = _filterBar.barHeight;
        _filterBar.left  = 0;
        _filterBar.bottom = self.showFilterBar? self.width: self.width+_filterBar.barHeight;

    }
}

- (void)switchToWaitingUI
{
    DDLogInfo(@"switch to waiting UI");
//    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAudience)
//    {
//        [self switchToLinkingUI];
//    }
//    else
    {
        self.startLiveButton.hidden = NO;
        self.cameraButton.hidden = NO;
        [self.startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
    }
}

- (void)switchToLinkingUI
{
    DDLogInfo(@"switch to Linking UI");
    self.startLiveButton.hidden = YES;
    self.closeButton.hidden = NO;
    [self.coverView refreshWithChatroom:self.roomId status:NTESLiveCoverStatusLinking];
    self.coverView.hidden = NO;
    [self.closeButton setImage:[UIImage imageNamed:@"icon_close_n"] forState:UIControlStateNormal];
    [self.closeButton setImage:[UIImage imageNamed:@"icon_close_p"] forState:UIControlStateHighlighted];
}

- (void)switchToEndUI
{
    DDLogInfo(@"switch to End UI");
    [self.coverView refreshWithChatroom:self.roomId status:NTESLiveCoverStatusFinished];
    self.coverView.hidden = NO;
    self.cameraButton.hidden = YES;
    self.beautifyButton.hidden = YES;
    self.orientationButton.hidden = YES;
    self.orientationSelectView.hidden = YES;
    self.closeButton.hidden = YES;
}

- (NTESFiterStatusModel *)getFilterModel
{
    NTESFiterStatusModel *model = [[NTESFiterStatusModel alloc]init];
    
    model.filterIndex = _filterBar.filterIndex;
    model.smoothValue = _filterBar.smoothValue;
    model.constrastValue = _filterBar.constrastValue;
    
    return model;
}

- (void)updateBeautifyButton:(BOOL)isOn
{
    [self.beautifyButton setImage:[UIImage imageNamed:isOn? @"icon_filter_on_n" :@"icon_filter_off_n" ]forState:UIControlStateNormal];
}

- (NSString *)titleString {
    return _titleText.text;
}
-(void)setTitleString:(NSString *)titleString{

   _titleText.text=titleString;
}

#pragma mark - get
- (UIButton *)startLiveButton
{
    if (!_startLiveButton) {
        _startLiveButton = [UIButton buttonWithType:UIButtonTypeCustom];

        _startLiveButton.backgroundColor = kGlobalThemeColor;
        _startLiveButton.layer.cornerRadius = 2;
        _startLiveButton.layer.masksToBounds = YES;
        [_startLiveButton setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        [_startLiveButton addTarget:self action:@selector(startLive:) forControlEvents:UIControlEventTouchUpInside];
//        _startLiveButton.size = CGSizeMake(215, 46);
//        _startLiveButton.center = self.center;
        [_startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
 //       _startLiveButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    }
    return _startLiveButton;
}

- (UIButton *)closeButton
{
    if(!_closeButton)
    {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"icon_close_white"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"icon_close_white"] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
      //  _closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        
    }
    return _closeButton;
}

- (UIButton *)orientationButton
{
    if(!_orientationButton)
    {
        _orientationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orientationButton setImage:[UIImage imageNamed:@"icon_live_orientation_n"] forState:UIControlStateNormal];
        [_orientationButton setImage:[UIImage imageNamed:@"icon_live_orientation_p"] forState:UIControlStateHighlighted];
        [_orientationButton addTarget:self action:@selector(showOrientationSelectView) forControlEvents:UIControlEventTouchUpInside];
        _orientationButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_orientationButton sizeToFit];
    }
    return _orientationButton;
}

- (UIButton *)cameraButton
{
    if(!_cameraButton)
    {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setImage:[UIImage imageNamed:@"icon_camera_white"] forState:UIControlStateNormal];
        //[_cameraButton setImage:[UIImage imageNamed:@"icon_camera_rotate_pressed"] forState:UIControlStateHighlighted];
        [_cameraButton addTarget:self action:@selector(onCameraRotate) forControlEvents:UIControlEventTouchUpInside];
        //_cameraButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        //[_cameraButton sizeToFit];
    }
    return _cameraButton;
}

- (UIButton *)beautifyButton
{
    if(!_beautifyButton)
    {
        _beautifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beautifyButton setImage:[UIImage imageNamed:@"icon_filter_off_n"] forState:UIControlStateNormal];
        [_beautifyButton setImage:[UIImage imageNamed:@"icon_filter_p"] forState:UIControlStateHighlighted];
        [_beautifyButton addTarget:self action:@selector(onBeautifyToggle:) forControlEvents:UIControlEventTouchUpInside];
        _beautifyButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_beautifyButton sizeToFit];
    }
    return _beautifyButton;
}


- (NTESOrientationSelectView *)orientationSelectView
{
    if (!_orientationSelectView) {
        _orientationSelectView = [[NTESOrientationSelectView alloc] initWithFrame:CGRectZero];
        _orientationSelectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _orientationSelectView.backgroundColor = HEXCOLORA(0x000000
, 0.8);
        _orientationSelectView.delegate = self;
    }
    return _orientationSelectView;
}

- (NTESLiveCoverView *)coverView
{
    if (!_coverView) {
        _coverView = [[NTESLiveCoverView alloc] initWithFrame:self.bounds];
        _coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _coverView.hidden = YES;
        _coverView.delegate = self;
    }
    return _coverView;
}


#pragma mark - action
- (void)hidenKeyboard {
    [_titleText resignFirstResponder];
}

- (void)shareAction:(UIButton *)btn {

    JHOperationType operationType = JHOperationTypeNone;
    if (btn.tag == UMSocialPlatformType_WechatSession) {
        operationType = JHOperationTypeWechatSession;
    }
    else if(btn.tag == UMSocialPlatformType_WechatTimeLine) {
        operationType = JHOperationTypeWechatTimeLine;
    }
    NSString *localId = [self.delegate channelModel].channelLocalId;
    
    NSString *url = [NSString stringWithFormat:@"%@channelid=%@&code=%@", [UMengManager shareInstance].shareLiveUrl, localId, [UserInfoRequestManager sharedInstance].user.invitationCode];
    if (self.type == 0) {
//        NSString *title = [NSString stringWithFormat:@"%@-认证鉴定师",[UserInfoRequestManager sharedInstance].user.name];
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&type=1"]];

//        [[UMengManager shareInstance] shareWebPageToPlatformType:btn.tag title:[NSString stringWithFormat:ShareLiveAppraiseTitle,[self.delegate channelModel].anchorName] text:ShareLiveAppraiseText thumbUrl:nil webURL:url type:ShareObjectTypeAnchorAppraisePreview pageFrom:JHPageFromTypeUnKnown object:localId];
        JHShareInfo* info = [JHShareInfo new];
        info.title = [NSString stringWithFormat:ShareLiveAppraiseTitle,[self.delegate channelModel].anchorName];
        info.desc = ShareLiveAppraiseText;
        info.shareType = ShareObjectTypeAnchorAppraisePreview;
        info.pageFrom = JHPageFromTypeUnKnown;
        info.url = url;
        [JHBaseOperationAction toShare:operationType operationShareInfo:info object_flag:localId];//TODO:Umeng share

    }else {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&type=2"]];

//        [[UMengManager shareInstance] shareWebPageToPlatformType:btn.tag title:[NSString stringWithFormat:ShareLiveSaleTitle,[self.delegate channelModel].anchorName] text:ShareLiveSaleText thumbUrl:nil webURL:url type:ShareObjectTypeAnchorSalePreview pageFrom:JHPageFromTypeUnKnown object:self.delegate.channelModel.roomId];
        JHShareInfo* info = [JHShareInfo new];
        info.title = [NSString stringWithFormat:ShareLiveSaleTitle,[self.delegate channelModel].anchorName];
        info.desc = ShareLiveSaleText;
        info.shareType = ShareObjectTypeAnchorSalePreview;
        info.pageFrom = JHPageFromTypeUnKnown;
        info.url = url;
        [JHBaseOperationAction toShare:operationType operationShareInfo:info object_flag:self.delegate.channelModel.roomId];//TODO:Umeng share
    }
}

- (void)startLive:(id)sender
{
    if (_titleText.text.length>=0) {
        [self.startLiveButton setTitle:@"初始化中，请等待..." forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(onStartLiving:)]) {
            [self.delegate onStartLiving:_titleText.text];
        }
    } else {
        [self makeToast:@"请输入直播标题"];
    }
}

- (void)onClose:(id)sender
{
//    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAnchor)
    {
        if ([self.delegate respondsToSelector:@selector(onCloseLiving)]) {
            [self.delegate onCloseLiving];
        }
    }
}

-(void)onCameraRotate
{
    if ([self.delegate respondsToSelector:@selector(onCameraRotate)]) {
        [self.delegate onCameraRotate];
    }
}

-(void)onBeautifyToggle:(id)sender
{
    [self showFilterView];
}

- (void)showFilterView
{
    [UIView animateWithDuration:0.5 animations:^{
        if (self.orientation == NIMVideoOrientationPortrait) {
            _filterBar.bottom = self.height;
        }
        else{
            _filterBar.bottom = self.width;
        }
    } completion:^(BOOL finished) {
        self.showFilterBar = YES;
    }];
}

- (void)showOrientationSelectView
{
    [UIView animateWithDuration:0.5 animations:^{
        if (self.orientation == NIMVideoOrientationPortrait) {
            _orientationSelectView.bottom = self.height;
        }
        else{
            _orientationSelectView.bottom = self.width;
        }
    } completion:^(BOOL finished) {
        self.showOrientataionView = YES;
    }];
}

#pragma mark - NTESOrientationSelectViewDelegate
-(void)onVerticalScreenButtonSelected
{
    if (_orientation == NIMVideoOrientationLandscapeRight) {
        _orientation = NIMVideoOrientationPortrait;
        [self.delegate onRotate:NIMVideoOrientationPortrait];
    }

}

-(void)onHorizontalScreenButtonSelected
{
    if (_orientation == NIMVideoOrientationPortrait) {
        _orientation = NIMVideoOrientationLandscapeRight;
        [self.delegate onRotate:NIMVideoOrientationLandscapeRight];
    }
}

-(BOOL)interactionDisabled
{
    if ([self.delegate respondsToSelector:@selector(interactionDisabled)]) {
        {
            return  [self.delegate interactionDisabled];
        }
    }
    return NO;
}

#pragma mark - NTESMenuViewProtocol

-(void)onFilterViewCancelButtonPressed
{
    [self dismissFilterBar];
}

-(void)onFilterViewConfirmButtonPressed
{
    [self dismissFilterBar];
    if (self.filterBar.filterIndex) {
        [self.beautifyButton setImage:[UIImage imageNamed: @"icon_filter_on_n"  ]forState:UIControlStateNormal];
    }
    else
    {
        [self.beautifyButton setImage:[UIImage imageNamed: @"icon_filter_off_n"  ]forState:UIControlStateNormal];

    }
}


#pragma mark - NTESLiveCoverViewDelegate
- (void)didPressBackButton
{
    [self.viewController dismissViewControllerAnimated:YES completion:^{
//         exit(0); //仅退出直播间，不关闭app
    }];
}
#pragma mark - UITextFeildViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}



@end
