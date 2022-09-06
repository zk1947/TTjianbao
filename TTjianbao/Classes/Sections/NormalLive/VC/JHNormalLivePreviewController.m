//
//  JHNormalLivePreviewControllerh
//  TTjianbao
//
//  Created by jiang on 2019/9/2.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "JHNormalLivePreviewController.h"
#import "JHNormalLiveController.h"
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
#import "NTESSessionMsgConverter.h"
#import "NTESDemoService.h"
#import "TTjianbaoUtil.h"
#import "UIView+Toast.h"
#import "NTESLiveUtil.h"
#import "NTESFilterMenuBar.h"
#import "NTESFiterMenuView.h"
#import "ChannelMode.h"
#import "JHMediaCapture.h"
#import "DBManager.h"
#import "JHLivePlaySMallView.h"
#import "UserInfoRequestManager.h"
#import "DBManager.h"
#import "CommAlertView.h"
@interface JHNormalLivePreviewController ()<NTESPreviewInnerViewDelegate,JHNormalLiveControllerDelegate,NIMNetCallManagerDelegate,NTESMenuViewProtocol>

@property (nonatomic, strong) UIButton *startLiveButton;          //开始直播按钮

@property (nonatomic, copy)   NIMChatroom *chatroom;

@property (nonatomic, strong)   ChannelMode *channel;

@property (nonatomic, strong) NIMNetCallMeeting *currentMeeting;

@property (nonatomic, strong) NIMNetCallMeeting *preMeeting;

@property (nonatomic, copy) NSString *meetingname;

@property (nonatomic, strong) NTESLiveAnchorHandler *handler;

@property (nonatomic, strong) JHMediaCapture  *capture;

@property (nonatomic, strong) NTESPreviewInnerView *previewInnerView;
@property (nonatomic, strong) UIView *captureView;

@property (nonatomic, strong) UIView *beautifyToastView;

@property (nonatomic, strong) UIView *requestToastView;

@property (nonatomic ) NIMVideoOrientation orientation;

@property (nonatomic ) BOOL disableClick;

@end

@implementation JHNormalLivePreviewController

- (void)dealloc {
    NSLog(@"dealloc   JHNormalLivePreviewController");
}

- (instancetype)init {
    self= [super init];
    if (self) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        _capture = [[JHMediaCapture alloc] init];
        _orientation = NIMVideoOrientationPortrait;
        [NTESLiveManager sharedInstance].orientation = NIMVideoOrientationPortrait;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.jhNavView.backgroundColor = [UIColor clearColor];
    [self removeNavView];
    [[JHLivePlaySMallView sharedInstance] close];
    [self setUp];
    [self.view addSubview:self.previewInnerView];
    [self requsetChannelInfo];
    [self.previewInnerView switchToWaitingUI];
    self.previewInnerView.type = self.type;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)setUp
{
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    self.view.backgroundColor = HEXCOLOR(0xdfe2e6);
    [self.view addSubview:self.captureView];
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
}

- (void)sendDisconnectedNotify:(NTESMicConnector *)connector
{
    NIMMessage *message = [NTESSessionMsgConverter msgWithDisconnectedMic:connector];
    NIMSession *session = [NIMSession session:self.chatroom.roomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
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

- (void)requsetChannelInfo{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/channel/info/auth")  Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        self.channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        [_previewInnerView setTitleString:self.channel.title];
        //普通直播>开始采集>预览视频
        [self.capture startVideoPreview:self.channel.pushUrl container:self.captureView];
        [self.view bringSubviewToFront:self.previewInnerView];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:IS_STRING(respondObject.message) ? respondObject.message : @"网络连接失败，请检查网络设置" cancleBtnTitle:@"确定"];
       [[UIApplication sharedApplication].keyWindow addSubview:alert];
       @weakify(self);
       alert.cancleHandle  = ^{
         @strongify(self);
           [self onCloseLiving];
       };
    }];
    [SVProgressHUD show];
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

- (void)requestVideoStreamWithCompletion:(void(^)(NSError *error))completion
{
//    if (self.disableClick) {
//        return;
//    }
//    _disableClick = YES;
    
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
                
//                NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
//                meeting.name = self.meetingname;
//                meeting.type = (NIMNetCallMediaType)[NTESLiveManager sharedInstance].type;
//                meeting.actor = YES;
//                wself.preMeeting = meeting;
//                NIMNetCallOption *option = [NTESUserUtil fillNetCallOption:meeting];
//                option.bypassStreamingUrl = chatroom.broadcastUrl;
                //  option.bypassStreamingServerRecording = self.type==0?YES:NO;
                if (completion) {
                    completion(error);
                    DDLogError(@"setMeeting error:%@",error);
                }
            }
            else
            {
                if (completion) {
                    completion(error);
                    DDLogError(@"setMeeting error:%@",error);
                }
            }
        }];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSError * error = [[NSError alloc] init];
        completion(error);
    }];
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
    //点击直播按钮
    if (self.disableClick) {
        return;
    }
    _disableClick = YES;
    NSDictionary * parameters=@{
                                @"title":liveTitle?:@""
                                };
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/channel/title/auth")  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
        
        [self beginLive];
        [SVProgressHUD dismiss];
        
    } failureBlock:^(RequestModel *respondObject) {
        _disableClick = NO;
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [self.previewInnerView switchToWaitingUI];
    }];
    
    [SVProgressHUD show];
    
}
-(void)beginLive{
    
    __weak typeof(self) weakSelf = self;
    [self requestVideoStreamWithCompletion:^(NSError *error) {
        if (!error) {//开始直播
                [weakSelf.capture startLiveStream:^(NSError *error) {
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                            weakSelf.disableClick = NO;
                            [weakSelf.previewInnerView makeToast:@"直播初始化失败"];
                            [weakSelf.previewInnerView switchToWaitingUI];
                        });

                        DDLogError(@"start error:%@",error);
                    }
                    else
                    {
                        //将服务器连麦请求队列清空
                        [[NIMSDK sharedSDK].chatroomManager dropChatroomQueue:weakSelf.chatroom.roomId completion:nil];
                        //发一个全局断开连麦的通知给观众，表示之前的连麦都无效了
                        [weakSelf sendDisconnectedNotify:nil];

                        dispatch_async(dispatch_get_main_queue(), ^{

                            [SVProgressHUD dismiss];
                            [weakSelf enterNormalLiveRoom]; //跳转页面需要主线程
                        });
                    }
                }];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                weakSelf.disableClick = NO;
                [weakSelf.previewInnerView makeToast:@"直播初始化失败"];
                [weakSelf.previewInnerView switchToWaitingUI];
            });
        }
    }];
}

- (void)enterNormalLiveRoom
{
    JHNormalLiveController *vc = [[JHNormalLiveController alloc]initWithChatroom:self.chatroom currentMeeting:self.currentMeeting capture:self.capture delegate:self];
    vc.orientation = self.orientation;
    vc.channel = self.channel;
    vc.type = self.type;
    vc.filterModel = [self.previewInnerView getFilterModel];
    [self.navigationController pushViewController:vc animated:NO];
    [self.previewInnerView switchToEndUI];
}

- (void)onCloseLiving{
    
    if (self.disableClick) {
        return;
    }
    [self.capture stopLiveStream:^(NSError *error) {
        [self.capture destory];
    }];

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
    [_capture.capturer switchCamera:^{
        
    }];
//    [self.capture switchCamera];
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




