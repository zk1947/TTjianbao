//
//  NTESAnchorPreviewController.m
//  TTjianbao
//  Created by Simon Blue on 17/3/21.
//  Copyright © 2017年 Netease. All rights reserved.
//
#import "NTESAnchorPreviewController.h"
#import "NTESLiveAnchorHandler.h"
#import "NTESMediaCapture.h"
#import "UIView+NTES.h"
#import "UIAlertView+NTESBlock.h"
#import "NTESPreviewInnerView.h"
#import "NTESLiveManager.h"
#import "NTESUserUtil.h"
#import "NTESCustomKeyDefine.h"
#import "NSDictionary+NTESJson.h"
#import "NTESAnchorLiveViewController.h"
#import "JHCustomizeAnchorLiveController.h"
#import "NTESSessionMsgConverter.h"
#import "NTESDemoService.h"
#import "JHLivePlaySMallView.h"
#import "UIView+Toast.h"
#import "NTESLiveUtil.h"
#import "NTESFilterMenuBar.h"
#import "NTESFiterMenuView.h"
#import "ChannelMode.h"
#import "DBManager.h"
#import "BaseNavViewController.h"
#import "TTjianbaoBussiness.h"
#import "TTjianbaoUtil.h"
#import "JHRecycleAnchorLiveController.h"

@interface NTESAnchorPreviewController ()<NTESPreviewInnerViewDelegate,JHNormalLiveControllerDelegate,NIMNetCallManagerDelegate,NTESMenuViewProtocol>

@property (nonatomic, strong) UIButton *startLiveButton;          //开始直播按钮

@property (nonatomic, copy)   NIMChatroom *chatroom;

@property (nonatomic, strong)   ChannelMode *channel;

@property (nonatomic, strong) NIMNetCallMeeting *currentMeeting;

@property (nonatomic, strong) NIMNetCallMeeting *preMeeting;

@property (nonatomic, copy) NSString *meetingname;

@property (nonatomic, strong) NTESLiveAnchorHandler *handler;

@property (nonatomic, strong) NTESMediaCapture  *capture;

@property (nonatomic, strong) NTESPreviewInnerView *previewInnerView;
@property (nonatomic, strong) UIView *captureView;

@property (nonatomic, strong) UIView *beautifyToastView;

@property (nonatomic, strong) UIView *requestToastView;

@property (nonatomic ) NIMVideoOrientation orientation;

@property (nonatomic ) BOOL disableClick;

@end

@implementation NTESAnchorPreviewController

- (void)dealloc {
    NSLog(@"dealloc   NTESAnchorPreviewController");
}

- (instancetype)init {
    if (self= [super init]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        _capture = [[NTESMediaCapture alloc] init];
        _orientation = NIMVideoOrientationPortrait;
        [NTESLiveManager sharedInstance].orientation = NIMVideoOrientationPortrait;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof(self) wself = self;
    [self removeNavView];
    [[JHLivePlaySMallView sharedInstance] close];
    [self setUp];
    [self requsetChannelInfo];
    
    [self.previewInnerView switchToWaitingUI];
    if (self.anchorLiveType) {
        self.capture.cameraType = NIMNetCallCameraBack;
    }
    //互动直播>开始采集>预览视频
    [self.capture startPreview: (NIMNetCallMediaType)[NTESLiveManager sharedInstance].type container:self.captureView  handler:^(NSError * error) {
        [wself.view addSubview:wself.previewInnerView];
        
        if (error) {
            DDLogInfo(@"start error by privacy");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"直播失败，请检查网络和权限重新开启" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showAlertWithCompletionHandler:^(NSInteger index) {
                [wself dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
    self.previewInnerView.type = self.anchorLiveType;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //把美颜toastView恢复原始位置
    //    if (self.beautifyToastView) {
    //        self.beautifyToastView.transform = CGAffineTransformIdentity;
    //    }
    //    if (self.requestToastView) {
    //        self.requestToastView.transform = CGAffineTransformIdentity;
    //    }
}

- (void)setUp
{
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    self.view.backgroundColor = HEXCOLOR(0xdfe2e6);
    [self.view addSubview:self.captureView];
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
}

- (UIView *)previewInnerView
{
    if (!_previewInnerView) {
        _previewInnerView = [[NTESPreviewInnerView alloc] initWithChatroom:nil frame:self.view.bounds];
        _previewInnerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _previewInnerView.delegate = self;
    }
    return _previewInnerView;
}

- (UIView *)captureView
{
    if (!_captureView) {
        _captureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _captureView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _captureView.clipsToBounds = YES;
    }
    return _captureView;
}

#pragma mark - private method

- (void)rotateUI:(NIMVideoOrientation)orientation
{
    if (orientation == NIMVideoOrientationPortrait) {
        _orientation = NIMVideoOrientationPortrait;
        [UIView animateWithDuration:0.5 animations:^{
            _previewInnerView.transform = CGAffineTransformIdentity;
            _previewInnerView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
            [_previewInnerView layoutIfNeeded];
        }];
    }
    else
    {
        _orientation = NIMVideoOrientationLandscapeRight;
        [UIView animateWithDuration:0.5 animations:^{
            _previewInnerView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
            _previewInnerView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
            [_previewInnerView layoutIfNeeded];
            
        }];
    }
}

- (UIView *)getBeautifyToastView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for ( UIView *view in [window subviews]) {
        if ([view isKindOfClass:[UIControl class]]) {
            for (UIView *toastView in view.subviews) {
                if ([toastView isKindOfClass:[SVProgressHUD class]]) {
                    return toastView;
                    break;
                }
            }
        }
    }
    return nil;
}

- (void)requsetChannelInfo{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/channel/info/auth")  Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        self.channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        [_previewInnerView setTitleString:self.channel.title];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
    }];
    [SVProgressHUD show];
}

- (void)sendDisconnectedNotify:(NTESMicConnector *)connector
{
    NIMMessage *message = [NTESSessionMsgConverter msgWithDisconnectedMic:connector];
    NIMSession *session = [NIMSession session:self.chatroom.roomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}

- (void)requestVideoStreamWithCompletion:(void(^)(NSError *error))completion
{
    [SVProgressHUD show];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/channel/info/auth")  Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        self.channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        self.meetingname = self.channel.meetingName;
        [JHTracking trackEvent:@"startLive" property:@{@"channel_id":self.channel.channelId,@"channel_name":self.channel.title,@"channel_local_id":self.channel.channelLocalId}];
        //
        _requestToastView  = [self getBeautifyToastView];
        _requestToastView.transform = CGAffineTransformIdentity;
        
        [NTESLiveManager sharedInstance].requestOrientation = self.orientation;
        __weak typeof(self) wself = self;
        
        User* user=[[DBManager getInstance] select_userTable_info];
        NSLog(@"user.mobile==%@",user.mobile);
        
        NIMChatroom *chatroom=[[NIMChatroom alloc]init];
        chatroom.broadcastUrl= self.channel.pushUrl;
        chatroom.roomId= self.channel.roomId;
        chatroom.creator= self.channel.creatorId;
        NSDictionary * liveDic = @{@"pushUrl" :  self.channel.pushUrl,
                                   @"pullUrl":  self.channel.httpPullUrl
                                   ,@"type" :@"2",
                                   @"meetingName": self.meetingname
                                   };
        
        chatroom.ext = [NTESLiveUtil dataTojsonString:liveDic];
        NSInteger orientation = !(wself.orientation ==NIMVideoOrientationLandscapeRight) ? 1 : 2;
        _chatroom = chatroom;
        NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
        request.roomId = chatroom.roomId;
        request.roomNickname = [UserInfoRequestManager sharedInstance].user.name?:@"";
        request.roomAvatar = [UserInfoRequestManager sharedInstance].user.icon?:@"";
        
        NSMutableDictionary *dic = [[UserInfoRequestManager sharedInstance] getEnterChatRoomExtWithChannel:self.channel];
        dic[@"roomRole"] = @(JHRoomRoleAnchor);
        request.roomExt = [dic mj_JSONString];
        
        request.roomNotifyExt = [@{
                                   NTESCMType  : @([NTESLiveManager sharedInstance].type),
                                   NTESCMMeetingName: self.meetingname,
                                   
                                   NTESCMOrientation :@(orientation)
                                   } jsonBody];
        
        [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError *error, NIMChatroom *room, NIMChatroomMember *me) {
            if (!error) {
                //这里拿到的是应用服务器的人数，没有把自己加进去，手动添加。
                chatroom.onlineUserCount++;
                //将room的扩展也加进去
                chatroom.ext =[NTESLiveUtil jsonString:chatroom.ext addJsonString:request.roomNotifyExt];
                
                NSLog(@"chatroom.ext==%@",chatroom.ext);
                [[NTESLiveManager sharedInstance] cacheMyInfo:me roomId:request.roomId];
                [[NTESLiveManager sharedInstance] cacheChatroom:chatroom];
                //创建互动直播参数(meeting),预订互动直播
                NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
                meeting.name = wself.meetingname;
                meeting.type = (NIMNetCallMediaType)[NTESLiveManager sharedInstance].type;
                meeting.actor = YES;
                wself.preMeeting = meeting;
                NIMNetCallOption *option = [NTESUserUtil fillNetCallOption:meeting];
                option.bypassStreamingUrl = chatroom.broadcastUrl;
                //  option.bypassStreamingServerRecording = self.type==0?YES:NO;
                
                [[NIMAVChatSDK sharedSDK].netCallManager reserveMeeting:meeting completion:^(NIMNetCallMeeting * _Nonnull currentMeeting, NSError * _Nonnull error) {
                    
                    [wself.capture setMeeting:currentMeeting];
                    if (completion) {
                        completion(error);
                        DDLogError(@"setMeeting error:%@",error);
                    }
                }];
            }
            else
            {
                if (completion) {
                    DDLogError(@"enterChatroom error:%@",error);
                    completion(error);
                }
            }
        }];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:3 position:CSToastPositionCenter];
        NSError * error = [[NSError alloc] init];
         completion(error);
    }];
}

#pragma mark - NIMNetCallManagerDelegate  「鉴定&定制专用回调」
- (void)onLocalDisplayviewReady:(UIView *)displayView
{
    [self.capture onLocalDisplayviewReady:displayView];
    if (self.previewInnerView) {
        [self.view bringSubviewToFront:self.previewInnerView];
    }
    
    [self.previewInnerView updateBeautifyButton:YES];
    [[NIMAVChatSDK sharedSDK].netCallManager selectBeautifyType:NIMNetCallFilterTypeMeiyan1];
}

#pragma mark - NTESPreviewInnerViewDelegate

- (ChannelMode *)channelModel {
    return self.channel;
}
- (void)onRotate:(NIMVideoOrientation)orientation
{
    [self rotateUI:orientation];
}
- (BOOL)interactionDisabled
{
    return self.disableClick;
}
- (void)onStartLiving:(NSString*)liveTitle;
{
    if (self.disableClick) {
        return;
    }
      _disableClick = YES;
    //点击直播按钮
    NSDictionary * parameters=@{
                                @"title":liveTitle?:@""
                                };
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/channel/title/auth")  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
        
        [self beginLive];
        [SVProgressHUD dismiss];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
          _disableClick = NO;
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
        [self.previewInnerView switchToWaitingUI];
    }];
    
    [SVProgressHUD show];
    
}
-(void)beginLive{
    
    JH_WEAK(self)
    [self requestVideoStreamWithCompletion:^(NSError *error) {
        JH_STRONG(self)
        if (!error) {
            if (!self.capture.isLiveStream) {//开始直播
                [self.capture startLiveStreamHandler:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
                    JH_STRONG(self)
                    if (error) { 
                        [SVProgressHUD dismiss];
                        self.disableClick = NO;
                        [self.previewInnerView makeToast:@"直播初始化失败"];
                        [self.previewInnerView switchToWaitingUI];
                        DDLogError(@"start error:%@",error);
                    }
                    else
                    {
                        //将服务器连麦请求队列清空
                        [[NIMSDK sharedSDK].chatroomManager dropChatroomQueue:self.chatroom.roomId completion:nil];
                        //发一个全局断开连麦的通知给观众，表示之前的连麦都无效了
                        [self sendDisconnectedNotify:nil];
                        self.currentMeeting = meeting;
                        [self enterChatLiveRoom]; //互动直播间
                    }
                }];
            }
            else
            {
                [SVProgressHUD dismiss];
                self.disableClick = NO;
            }
        }
        else
        {
            [SVProgressHUD dismiss];
            self.disableClick = NO;
            [self.previewInnerView makeToast:@"直播初始化失败"];
            [self.previewInnerView switchToWaitingUI];
        }
    }];
}

- (void)enterChatLiveRoom
{// 什么时候会执行到子线程？？
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (self.anchorLiveType == JHAnchorLiveCustomizeType) {
            
            JHCustomizeAnchorLiveController *vc = [[JHCustomizeAnchorLiveController alloc]initWithChatroom:self.chatroom currentMeeting:self.currentMeeting capture:self.capture delegate:self];//
            vc.orientation = self.orientation;
            vc.channel=self.channel;
            vc.anchorLiveType = self.anchorLiveType;
            vc.filterModel = [self.previewInnerView getFilterModel];
            
            BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:NO completion:^{
                [self.previewInnerView switchToEndUI];
            }];

        }
        
      else  if (self.anchorLiveType == JHAnchorLiveRecycleType) {
            
          JHRecycleAnchorLiveController *vc = [[JHRecycleAnchorLiveController alloc]initWithChatroom:self.chatroom currentMeeting:self.currentMeeting capture:self.capture delegate:self];//
            vc.orientation = self.orientation;
            vc.channel=self.channel;
            vc.anchorLiveType = self.anchorLiveType;
            vc.filterModel = [self.previewInnerView getFilterModel];
            
            BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:NO completion:^{
                [self.previewInnerView switchToEndUI];
            }];

        }
        
        else{
            NTESAnchorLiveViewController *vc = [[NTESAnchorLiveViewController alloc]initWithChatroom:self.chatroom currentMeeting:self.currentMeeting capture:self.capture delegate:self];//
            vc.orientation = self.orientation;
            vc.channel=self.channel;
            vc.type = self.anchorLiveType;
            vc.filterModel = [self.previewInnerView getFilterModel];
            
            BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:NO completion:^{
                [self.previewInnerView switchToEndUI];
            }];
        }
    });
}

- (void)onCloseLiving{
    if (self.disableClick) {
        return;
    }
    [self.capture stopVideoCapture];
    if (self.chatroom) {
        [[NIMSDK sharedSDK].chatroomManager exitChatroom:self.chatroom.roomId completion:nil];
    }
    if (self.meetingname) {
        NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
        meeting.name = self.meetingname;
        [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:meeting];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onCameraRotate
{
    [self.capture switchCamera];
}

#pragma mark - JHNormalLiveControllerDelegate

- (void)onCloseLiveView
{
    [self.previewInnerView switchToEndUI];
}

#pragma mark - statusBar

- (BOOL)prefersStatusBarHidden
{
    return NO;
}
@end



