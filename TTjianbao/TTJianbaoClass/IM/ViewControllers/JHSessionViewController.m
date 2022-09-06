//
//  JHSessionViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSessionViewController.h"
#import "IQKeyboardManager.h"
#import "JHSessionManager.h"
#import "JHChatTextCell.h"
#import "JHChatImageCell.h"
#import "JHChatVideoCell.h"
#import "JHChatAudioCell.h"
#import "JHChatGoodsCell.h"
#import "JHChatOrderCell.h"
#import "JHChatInputView.h"
#import "JHChatDateCell.h"
#import "JHChatRevokeCell.h"
#import "JHChatCouponCell.h"
#import "JHChatCustomTipCell.h"
#import "JHRecycleImagePickerViewController.h"
#import "JHBrowserViewController.h"
#import "JHChatMediaManager.h"
#import "JHChatTransferServiceViewController.h"
#import "JHWebViewController.h"
#import "JHChatMenu.h"
#import "JHSessionTableView.h"
#import "CommAlertView.h"
#import "JHRefreshGifHeader.h"
#import "JHChatWarningView.h"
#import "JHChatOrderView.h"
#import "JHChatNewMessageView.h"
#import "JHChatTipCell.h"
#import "JHUserInfoViewController.h"
#import "JHChatOrderViewController.h"
#import "JHC2CProductDetailController.h"
#import "JHChatBusiness.h"
#import "PHPhotoLibrary+Save.h"
#import "MBProgressHUD.h"
#import "JHIMQuickView.h"
#import "JHChatCouponViewController.h"
#import "JHMallCouponViewController.h"
#import "JHChatEvaluationViewController.h"
#import "JHStoreDetailViewController.h"

@interface JHSessionViewController ()<
JHChatCellDelegate,
UITableViewDelegate,
UITableViewDataSource,
JHChatInputViewDelegate,
JHSessionManagerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, strong) JHSessionManager *sessionManager;

@property (nonatomic, strong) JHSessionTableView *tableView;
@property (nonatomic, strong) JHChatInputView *chatInputView;
@property (nonatomic, strong) JHChatWarningView *warningView;
@property (nonatomic, strong) JHChatOrderView *orderView;
@property (nonatomic, strong) JHChatNewMessageView *chatNewMessageView;
@property (nonatomic, assign) BOOL currentIsInBottom;
@property (nonatomic, assign) NSInteger neMessageCount;
@property (nonatomic, strong) JHMessage *currentPlayMessage;
@property (nonatomic, strong) UIButton *naviRightButton;
/// 快速回复视图
@property (nonatomic, strong) JHIMQuickView *quickView;
@end

@implementation JHSessionViewController


#pragma mark - Life Cycle Functions

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self registerCells];
    [self registerNotification];
    
    [self layoutViews];
    
//    [self doForceScrollToBottom];
    [self showProgressHUD];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.jhNavView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:false];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:true];
    [self.sessionManager.chatManager clearUnreadCount];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}
- (void)dealloc {
    NSLog(@"IM释放 - ViewController-%@释放", [self class]);
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - 发送消息
- (void)sendImageMessage : (UIImage *)image thumImage : (UIImage *)thumImage {
    [self.sessionManager.chatManager sendMessageWithImage:image thumImage:thumImage account:self.receiveAccount];
}
- (void)sendVideoMessage : (NSString *)localUrl thumImage : (UIImage *)thumImage {
    [self.sessionManager.chatManager sendMessageWithVideo:localUrl thumImage:thumImage account:self.receiveAccount];
}
#pragma mark - 点击 - 消息 - 跳转
- (void)pushVCWithParams : (NSDictionary *)params {
    Class vcName = NSClassFromString(params[@"vc"]);
    
    UIViewController *vc = [[vcName alloc] init];
    if (vc == nil) return;
    [vc mj_setKeyValues: params[@"params"]];
    
    if ([params[@"method"] isEqualToString:@"push"]) {
        [self.navigationController pushViewController:vc animated:true];
    }else {
        [self presentViewController:vc animated:true completion:nil];
    }
    
}
#pragma mark - 点击用户信息
- (void)didClickUserInfo {
    @weakify(self)
    [JHChatUserManager getUserInfoWithID:self.receiveAccount handler:^(JHChatUserInfo * _Nonnull userInfo) {
        @strongify(self)
        [self pushUserInfoView:userInfo.customerId];
    }];
    
}
- (void)pushUserInfoView : (NSString *)userId {
    JHUserInfoViewController *vc = [[JHUserInfoViewController alloc] init];
    vc.userId = userId;
    [self.navigationController pushViewController:vc animated:true];
}
#pragma mark - 点击多媒体栏
- (void)didClickMediaWihtModel : (JHChatMediaModel *)model {
    switch (model.type) {
        case JHChatMediaTypeCamera:
            [self showCamera];
            break;
        case JHChatMediaTypeAlbum:
            [self showAlbum];
            break;
        case JHChatMediaTypeOrder:
            [self showOrderListView];
            break;
        case JHChatMediaTypeService:
            [self showService];
            break;
        case JHChatMediaTypeBlack:
            [self changeBlack:model];
            break;
        case JHChatMediaTypeCoupon:
            [self pushCoupon];
            break;
        case JHChatMediaTypeComplaint:
            [self pushComplaint];
            break;
        default:
            break;
    }
}
#pragma mark - 点击-跳转客服
- (void)showService {
    [[JHQYChatManage shareInstance] showChatWithViewcontroller:self];
}
#pragma mark - 点击-打开链接
- (void)openUrl : (NSString *)url {
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = url;
    [self.navigationController pushViewController:vc animated:true];
}
#pragma mark - 点击-重发信息
- (void)reEditMessage : (NSString *)text {
    [self.chatInputView setEditText:text];
}
#pragma mark - 点击-拉黑
- (void)changeBlack : (JHChatMediaModel *)model {
    @weakify(self)
    if (model.isSelected) {
        [self.sessionManager.chatManager.userManager removeFromBlack:self.receiveAccount handler:^(BOOL isSuccess) {
            @strongify(self)
            model.isSelected = false;
            [self requestBlack:false];
        }];
    }else {
        [self showAlertWithDesc:@"拉黑后，对方将不能给你留言、私信，并且不能购买你的商品" sureTitle:@"确认" handle:^{
            [self.sessionManager.chatManager.userManager addToBlack:self.receiveAccount handler:^(BOOL isSuccess) {
                @strongify(self)
                model.isSelected = true;
                [self requestBlack:true];
            }];
        } cancelHandle:nil];
    }
}

#pragma mark - 点击-显示提示框
- (void)showAlertWithDesc : (NSString *)desc
                sureTitle : (NSString *)sureTitle
                   handle : (JHFinishBlock)handle
             cancelHandle : (JHFinishBlock) cancelHandle {
    
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"提示" andDesc:desc cancleBtnTitle:@"取消" sureBtnTitle:sureTitle];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    alert.handle = handle;
    alert.cancleHandle = cancelHandle;
}
#pragma mark - 点击-显示警告框
- (void)showWarningView {
    [self.view addSubview: self.warningView];
    [self.warningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavView.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.warningView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.quickView.mas_top);
    }];
}

#pragma mark - 点击-订单列表
- (void)showOrderListView {
    @weakify(self)
    [self.sessionManager canSendMessage:^(BOOL isCan) {
        if (!isCan) return;
        @strongify(self)
        [self showOrderList];
    }];
}
- (void)showOrderList {
    
    JHChatOrderViewController *vc = [[JHChatOrderViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.account = self.sessionManager.myAccount;
    vc.receiveAccount = self.receiveAccount;
    [self presentViewController:vc animated:true completion:nil];
    
    @weakify(self)
    [vc.sendOrderMessage subscribeNext:^(JHChatOrderInfoModel * _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        [self.sessionManager sendMessageWithOrder:x];
    }];
    
    [vc.gotoDetailPage subscribeNext:^(JHChatOrderInfoModel * _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        JHMessage *msg = [[JHMessage alloc] initWithOrder:x];
        [self.sessionManager didClickMessage:msg];
    }];
    
}
#pragma mark - 点击-优惠券列表
- (void)pushCoupon {
    if (self.sessionManager.couponDataSource.count == 0) {
        JHTOAST(@"暂无优惠券");
        return;
    }
    @weakify(self)
    [self.sessionManager canSendMessage:^(BOOL isCan) {
        if (!isCan) return;
        @strongify(self)
        [self showCouponList];
    }];
}
- (void)showCouponList {
    JHChatCouponViewController *vc = [[JHChatCouponViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.dataSource = [[NSArray alloc] initWithArray:self.sessionManager.couponDataSource copyItems:true];
    [self presentViewController:vc animated:true completion:nil];
    
    @weakify(self)
    [vc.sendSubject subscribeNext:^(NSArray<JHChatCouponInfoModel *> * _Nullable x) {
        @strongify(self)
        if (x.count == 0)return;
        [self.sessionManager sendCouponMessage:x];
    }];
}
#pragma mark - 点击-举报
- (void)pushComplaint {
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.titleString = @"举报";
    NSString *url = H5_BASE_HTTP_STRING(@"/jianhuo/app/cTwoc/report.html?");
    url = [url stringByAppendingFormat:@"sessionId=%@",
           self.userId];
    if (self.goodsInfo.productId.length > 0) {//如果productId不存在不传
        url = [url stringByAppendingFormat:@"&productId=%@",
               self.goodsInfo.productId];
    }
    webVC.urlString = url;
    [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
}
#pragma mark - 点击-语音消息
- (void)didClickAudioMessage :(JHMessage *)message {
    message.isSelected = !message.isSelected;
    if (message.isSelected) {
        if (self.currentPlayMessage) {
            self.currentPlayMessage.isSelected = false;
        }
        self.currentPlayMessage = message;
        [self.sessionManager.chatManager startPlayAudio:message.mediaUrl];
    }else {
        [self.sessionManager.chatManager stopPlayAudio];
    }
}
#pragma mark - 点击-图片视频消息
- (void)didClickImageOrVideoMessage :(JHMessage *)message {
    NSArray *arr = [self.sessionManager getAllBrowserMessage];
    NSMutableArray *list = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    NSInteger currentIndex = 0;
    for (JHMessage *msg in arr) {
        JHBrowserModel *model = [[JHBrowserModel alloc] init];
        model.thumbImageUrl = msg.thumUrl;
        model.mediaUrl = msg.mediaUrl;
        model.imageUrl = msg.imageUrl;
        model.image = msg.image;
        [list appendObject:model];
        if (msg == message) {
            currentIndex = index;
        }
        index += 1;
    }
    [JHBrowserViewController showBrowser:list currentIndex:currentIndex from:self];
}
#pragma mark - 点击-商品消息
- (void)didClickGoodsMessage :(JHMessage *)message {
    [self.sessionManager didClickMessage:message];
}
#pragma mark - 点击-订单消息
- (void)didClickOrderMessage :(JHMessage *)message {
    [self.sessionManager didClickMessage:message];
}
#pragma mark - 点击-优惠券消息
- (void)didClickCouponMessage :(JHMessage *)message{
    JHMallCouponViewController *vc = [[JHMallCouponViewController alloc] init];
    vc.currentIndex = 0;
    [self.navigationController pushViewController:vc animated:true];
}
#pragma mark - 点击-评价
- (void)didClickEvaluation {
   
    @weakify(self)
    [self.sessionManager canSendMessage:^(BOOL isCan) {
        if (!isCan) return;
        @strongify(self)
        [self evaluationEvent];
    }];
//    [self evaluationEvent];
}
- (void)evaluationEvent {
    @weakify(self)
    [self.sessionManager canEvaluation:^(BOOL canEvaluation) {
        @strongify(self)
        if (canEvaluation == false) return;
        
        JHChatEvaluationViewController *vc = [[JHChatEvaluationViewController alloc] init];
        
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:true completion:nil];
    
        [vc.submitSubject subscribeNext:^(JHChatEvaluationModel * _Nullable x) {
            [self.sessionManager evaluationWithModel:x];
        }];
    }];
}
- (void)didClickBusinessEvaluation {
    @weakify(self)
    [self.sessionManager canSendMessage:^(BOOL isCan) {
        if (!isCan) return;
        @strongify(self)
        [self.sessionManager businessSendEvaluation];
    }];
}
#pragma mark - 点击-快捷回复
- (void)didClickQuick : (JHIMQuickModel *)model {
    [self.sessionManager insertTipMessageWithText:model.defaultReply];
}
#pragma mark - 快捷回复-点击回调
- (void)quickViewHandler : (JHIMQuickModel *)model {
    if (model.defaultTermsId == -1) {
        if ([JHChatUserManager sharedManager].userIsBusiness) {
            [self didClickBusinessEvaluation];
        }else {
            [self didClickEvaluation];
        }
    }else if (model.defaultTermsId == -2) {
        [self didClickBusinessEvaluation];
    }else {
        [self didClickQuick:model];
    }
}
#pragma mark - 收到-事件消息-回调
- (void)receivedEvent : (JHChatCustomTipInfo *)info {
    if (info.type == JHChatCustomTipTypeEvaluate) {
        [self didClickEvaluation];
    }
}
#pragma mark - 显示订单浮框
- (void)showOrderView {
    [self.view addSubview:self.orderView];
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(self.quickView.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(304, 86));
    }];
}
#pragma mark - 显示未读消息数提示框
- (void)showUnreadView : (NSInteger)count {
    NSArray *cells = [self.tableView visibleCells];
    if (count <= cells.count) return;
    self.chatNewMessageView.hidden = false;
    [self.chatNewMessageView setupDataWithNum: count];
}
#pragma mark - toast
- (void)showToast : (NSString *)msg {
    [self.view makeToast:msg duration:1 position: CSToastPositionCenter];
}
- (void)requestBlack : (BOOL)isBlack {
    [[JHChatUserManager sharedManager] getUserInfoWithID:self.receiveAccount handler:^(JHChatUserInfo * _Nonnull userInfo) {
        [JHChatBusiness blackWithBlackAccount: userInfo.customerId isBlack:isBlack successBlock:^(RequestModel * _Nullable respondObject) {
            
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            
        }];
    }];
}

#pragma mark - JHChatInputViewDelegate
- (void)sendTextMessage:(JHMessage *)message {
    [self.sessionManager.chatManager sendMessage:message account:self.receiveAccount];
}
- (void)startRecordAudio {
    [self.sessionManager.chatManager startRecordAudio];
    [JHChatRecordView showWithType:JHChatRecordViewTypeRecording];
}
- (void)stopRecordAudio {
    [self.sessionManager.chatManager stopRecordAudio];
    [JHChatRecordView hide];
}
- (void)cancelledRecordAudio {
    [self.sessionManager.chatManager cancelRecordAudio];
    [JHChatRecordView hide];
}
- (void)changeRecordCancel : (BOOL)isCancel {
    if (isCancel) {
        [JHChatRecordView showWithType:JHChatRecordViewTypeCancel];
    }else {
        [JHChatRecordView showWithType:JHChatRecordViewTypeRecording];
    }
}
- (void)audioDidStartPlay {
    NSLog(@"IM-Chat-开始播放音频");
}
- (void)audioDidPlayCompleted {
    NSLog(@"IM-Chat-播放音频完成");
    if (self.currentPlayMessage) {
        self.currentPlayMessage.isSelected = false;
    }
}

#pragma mark - JHSessionManagerDelegate
- (void)reloadAllDatas {
    [self.tableView reloadData];
}
- (void)reloadMoreDatasWithScrollIndex : (NSInteger)index {
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
    NSInteger count = [self.tableView numberOfRowsInSection:0];
    if (index >= count) return;
    
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionTop animated:false];
}
-(void)doForceScrollToBottom{
    dispatch_async(dispatch_get_main_queue(), ^{
        usleep(5000);
        [self scrollToBottom : false];
    });
}
- (void)scrollToBottom : (BOOL)animated {
    if (self.sessionManager.chatManager.messageList.count <= 0) return;
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.sessionManager.chatManager.messageList.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}
- (void)scrollToIndex : (NSInteger)index {
    if (index >= self.sessionManager.chatManager.messageList.count) return;
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:false];
}
- (void)insertManagerWithIndex : (NSInteger) index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    [self scrollToBottom : false];
}

- (void)reloadCell : (NSUInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Cell Delegate
- (void)didClickResend : (JHChatCell *)cell message : (JHMessage *)message {
    [self.sessionManager resendMessage:message];
}
- (void)didLongPress : (JHChatCell *)cell message : (JHMessage *)message {
    NSArray *items = [self.sessionManager getItemModelsWithMessage:message];
    if (items.count <= 0) return;
    @weakify(self)
    [JHChatMenu showMenuInView:cell.messageContent items:items handler:^(JHChatMenuItemModel * _Nonnull model) {
        @strongify(self)
        switch (model.type) {
            case JHChatMenuItemTypeCopy:
                [[UIPasteboard generalPasteboard] setString:message.message.text];
                break;
            case JHChatMenuItemTypeDelete:
            {
                NSUInteger indexs = [self.sessionManager.chatManager.messageList indexOfObject:message];
                [self.sessionManager.chatManager delegateMessage:message];
                
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexs inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            }
                break;
            case JHChatMenuItemTypeRevoke:
                [self.sessionManager.chatManager revokeMessage:message];
                break;
            default:
                break;
        }
    }];
}
- (void)didClickHead : (JHChatCell *)cell userId : (NSString *)userId {
    [self pushUserInfoView:userId];
}
#pragma mark - 消息  点击 事件
- (void)didClickCell : (JHChatCell *)cell message : (JHMessage *)message {
    switch (message.messageType) {
        case JHMessageTypeAudio:
            [self didClickAudioMessage : message];
            break;
        case JHMessageTypeImage:
        case JHMessageTypeVideo:
            [self didClickImageOrVideoMessage:message];
            break;
        case JHMessageTypeGoods:
            [self didClickGoodsMessage:message];
            break;
        case JHMessageTypeOrder:
            [self didClickOrderMessage:message];
            break;
        case JHMessageTypeCoupon:
            [self didClickCouponMessage : message];
            break;
        default:
            break;
    }
}
#pragma mark - Tableview Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
    if (bottomOffset <= height){
        //在最底部
        self.currentIsInBottom = true;
    }
    else{
        self.currentIsInBottom = false;
    }
}


#pragma mark - 绑定 - data
- (void)setupData {
    
    @weakify(self)
    [JHChatUserManager getUserInfoWithID:self.receiveAccount handler:^(JHChatUserInfo * _Nonnull userInfo) {
        @strongify(self)
        self.jhTitleLabel.text = userInfo.nickName;
    }];
    
    if (self.orderInfo) {
        self.orderView.orderInfo = self.orderInfo;
        [self showOrderView];
    }
    
    [self hideProgressHUD];
    [self.sessionManager.chatManager sendMessageReceipt];
    [self doForceScrollToBottom];
}
- (void)bindData {
    @weakify(self)
    [self.sessionManager.reloadDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
        [self hideProgressHUD];
        [self setupData];
    }];
    // 多媒体点击
    [self.chatInputView.mediaView.selectedSubject subscribeNext:^(JHChatMediaModel * _Nullable x) {
        @strongify(self)
        [self didClickMediaWihtModel:x];
    }];
    [RACObserve(self.sessionManager.chatManager, toastText) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        [self showToast:x];
    }];
    [self.sessionManager.showWarningView subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self showWarningView];
    }];
    [self.chatInputView.viewFrameChanged subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        CGFloat yOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
        if (yOffset <= 0) return;
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.contentOffset = CGPointMake(0, yOffset);
        } completion:nil];
        
    }];
    [self.sessionManager.showUnReadSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSInteger count = [x integerValue];
        if (count <= 0) return;
        [self showUnreadView:count];
    }];
    [RACObserve(self.sessionManager, quickInfoList) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        NSArray<JHIMQuickModel *> *list = x;
        if (list.count == 0) return;
        [self.chatInputView hideLine];
        self.quickView.dataSource = list;
        [self.quickView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(54);
        }];
        [self doForceScrollToBottom];
    }];
    [RACObserve(self.sessionManager, mediaList) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        [self.chatInputView setupMedias:x];
    }];
    [self.sessionManager.toastSubject subscribeNext:^(NSString * _Nullable x) {
//        @strongify(self)
        JHTOAST(x);
    }];
    [self.sessionManager.eventSubject subscribeNext:^(JHChatCustomTipInfo * _Nullable x) {
        @strongify(self)
        [self receivedEvent : x];
    }];
    [self.sessionManager.pushEventSubject subscribeNext:^(NSDictionary * _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        [self pushVCWithParams : x];
    }];
}

- (void)showProgressHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
}
- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:self.view animated:true];
}
#pragma mark - 网络请求
- (void)getAccidRequest {
    if (self.userId.length <= 0) return;
    
    [JHChatBusiness getReceiveAccountWithUserId:self.userId successBlock:^(JHChatAccInfo * _Nonnull respondObject) {
        self.receiveAccount = respondObject.wyAccid;
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self hideProgressHUD];
        JHTOAST(@"网络异常，请重试");
    }];
}
#pragma mark - setupUI
- (void)setupUI {
    self.view.backgroundColor = HEXCOLOR(0xf5f6fa);
    [self registerNotification];
    [self initLeftButton];
    [self.jhNavView addSubview:self.naviRightButton];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.quickView];
    [self.view addSubview:self.chatInputView];
    [self.view addSubview:self.chatNewMessageView];
}

- (void)layoutViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.quickView.mas_top);
    }];
    [self.quickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.chatInputView.mas_top);
        make.height.mas_equalTo(0);
    }];
    [self.chatInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-UI.bottomSafeAreaHeight);
        make.left.right.mas_equalTo(0);
    }];
    [self.chatNewMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(26);
        make.bottom.mas_equalTo(self.chatInputView.mas_top).offset(-14);
    }];
    [self.naviRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.bottom.equalTo(self.jhNavView);
        make.height.mas_equalTo(UI.navBarHeight);
    }];
}

- (void)registerCells {
    [self.tableView registerClass:[JHChatTextCell class] forCellReuseIdentifier:@"JHChatTextCell"];
    [self.tableView registerClass:[JHChatImageCell class] forCellReuseIdentifier:@"JHChatImageCell"];
    [self.tableView registerClass:[JHChatVideoCell class] forCellReuseIdentifier:@"JHChatVideoCell"];
    [self.tableView registerClass:[JHChatAudioCell class] forCellReuseIdentifier:@"JHChatAudioCell"];
    [self.tableView registerClass:[JHChatGoodsCell class] forCellReuseIdentifier:@"JHChatGoodsCell"];
    [self.tableView registerClass:[JHChatOrderCell class] forCellReuseIdentifier:@"JHChatOrderCell"];
    [self.tableView registerClass:[JHChatCouponCell class] forCellReuseIdentifier:@"JHChatCouponCell"];
    [self.tableView registerClass:[JHChatDateCell class] forCellReuseIdentifier:@"JHChatDateCell"];
    [self.tableView registerClass:[JHChatRevokeCell class] forCellReuseIdentifier:@"JHChatRevokeCell"];
    [self.tableView registerClass:[JHChatTipCell class] forCellReuseIdentifier:@"JHChatTipCell"];
    [self.tableView registerClass:[JHChatCustomTipCell class] forCellReuseIdentifier:@"JHChatCustomTipCell"];
    
}
- (void)registerNotification {
  
}
#pragma mark - Tableview Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sessionManager.chatManager.messageList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHMessage *message = self.sessionManager.chatManager.messageList[indexPath.row];
    @weakify(self)
    [message.clickLinksEvent subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self openUrl:x];
    }];
    
    if (message.messageType == JHMessageTypeText) {
        JHChatTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHChatTextCell"];
        cell.delegate = self;
        cell.message = message;
        cell.indexPath = indexPath;
        return cell;
    }else if (message.messageType == JHMessageTypeImage) {
        JHChatImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHChatImageCell"];
        cell.delegate = self;
        cell.message = message;
        cell.indexPath = indexPath;
        return cell;
    }else if (message.messageType == JHMessageTypeAudio) {
        JHChatAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHChatAudioCell"];
        cell.delegate = self;
        cell.message = message;
        cell.indexPath = indexPath;
        return cell;
    }else if (message.messageType == JHMessageTypeVideo) {
        JHChatVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHChatVideoCell"];
        cell.delegate = self;
        cell.message = message;
        cell.indexPath = indexPath;
        return cell;
    }else if (message.messageType == JHMessageTypeOrder) {
        JHChatOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHChatOrderCell"];
        cell.delegate = self;
        cell.message = message;
        cell.indexPath = indexPath;
        return cell;
    }else if (message.messageType == JHMessageTypeGoods) {
        JHChatGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHChatGoodsCell"];
        cell.delegate = self;
        cell.message = message;
        cell.indexPath = indexPath;
        return cell;
    }else if (message.messageType == JHMessageTypeCoupon) {
        JHChatCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHChatCouponCell"];
        cell.delegate = self;
        cell.message = message;
        cell.indexPath = indexPath;
        return cell;
    }else if (message.messageType == JHMessageTypeDate) {
        JHChatDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHChatDateCell"];
        cell.message = message;
        return cell;
    }else if (message.messageType == JHMessageTypeRevoke) {
        JHChatRevokeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHChatRevokeCell"];
        cell.message = message;
        @weakify(self)
        cell.editEvent = ^(JHMessage * _Nonnull message) {
            @strongify(self)
            [self reEditMessage : message.message.text];
        };
        return cell;
    }else if (message.messageType == JHMessageTypeTip) {
        JHChatTipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHChatTipCell"];
        cell.delegate = self;
        cell.message = message;
        cell.indexPath = indexPath;
        return cell;
    }else if (message.messageType == JHMessageTypeCustomTip && message.customTipInfo.type == JHChatCustomTipTypeNormal) {
        JHChatCustomTipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHChatCustomTipCell"];
        cell.message = message;
        return cell;
    }else if (message.messageType == JHMessageTypeUnknown) {
        JHChatTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHChatTextCell"];
        cell.message = message;
        return cell;
    }
    
    return [[UITableViewCell alloc] initWithFrame:CGRectZero];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHMessage *message = self.sessionManager.chatManager.messageList[indexPath.row];
    return message.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark - 相机 - 相册
- (void)showCamera {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.videoMaximumDuration = VideoMaximumDuration;
    imagePickerController.mediaTypes = @[@"public.image", @"public.movie"];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    [self presentViewController:imagePickerController animated:true completion:nil];
}
- (void)showAlbum {
    JHRecycleImagePickerViewController *imagePicker = [[JHRecycleImagePickerViewController alloc] init];
    imagePicker.maxSelectedNum = 9;
    [self.navigationController pushViewController:imagePicker animated:true];
    @weakify(self)
    [imagePicker.selectAssets subscribeNext:^(NSArray<PHAsset *> * _Nullable x) {
        @strongify(self)
        if (x == nil || x.count <= 0) return;
        
        for(PHAsset *asset in x) {
            [JHChatMediaManager convertAsset:asset handler:^(NSString *localUrl, UIImage *image, UIImage *thumbImage) {
                if (localUrl != nil) {
                    [self sendVideoMessage:localUrl thumImage:thumbImage];
                }else {
                    [self sendImageMessage:image thumImage:thumbImage];
                }
            }];
        }
    }];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    // 选取完图片后跳转回原控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {//照片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (image == nil) return;
        
        @weakify(self)
        [JHChatMediaManager convertImage:image handler:^(UIImage * _Nonnull image, UIImage * _Nonnull thumbImage) {
            @strongify(self)
            [self sendImageMessage:image thumImage:thumbImage];
        }];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [PHPhotoLibrary saveImageDataToCameraRool:imageData completion:nil];
        
    }else if ([mediaType isEqualToString:@"public.movie"]) {
        NSURL *url  = [info objectForKey:UIImagePickerControllerMediaURL];
        @weakify(self)
        [JHChatMediaManager convertVideo:url handler:^(NSString * _Nonnull localUrl, UIImage * _Nonnull thumbImage) {
            @strongify(self)
            [self sendVideoMessage:localUrl thumImage:thumbImage];
        }];
        [PHPhotoLibrary saveMovieFileToCameraRoll:url completion:nil];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
}
#pragma mark - LAZY
- (void)setUserId:(NSString *)userId {
    _userId = userId;
    if (userId.length <= 0) return;
    [self getAccidRequest];
}
- (void)setReceiveAccount:(NSString *)receiveaAccount {
    _receiveAccount = receiveaAccount;
    if (receiveaAccount.length <= 0) return;
    self.sessionManager.sourceType = self.sourceType;
    [self.sessionManager startSessionWithReceiveAccount: receiveaAccount];
}
- (void)setGoodsInfo:(JHChatGoodsInfoModel *)goodsInfo {
    _goodsInfo = goodsInfo;
    self.sessionManager.goodsInfo = goodsInfo;
}
- (void)setOrderInfo:(JHChatOrderInfoModel *)orderInfo {
    _orderInfo = orderInfo;
    self.sessionManager.orderInfo = orderInfo;
}
- (JHSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [[JHSessionManager alloc] init];
        _sessionManager.delegate = self;
        [self bindData];
    }
    return _sessionManager;
}

- (JHSessionTableView *)tableView {
    if (!_tableView) {
        _tableView = [[JHSessionTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.backgroundColor = HEXCOLOR(0xf5f6fa);
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
//        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        @weakify(self)
        _tableView.touchBegin = ^{
            @strongify(self)
            [self.chatInputView hideKeyboard];
        };
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.sessionManager.chatManager loadMoreLocalMessage];
        }];
    }
    return _tableView;
}
- (JHChatInputView *)chatInputView {
    if (!_chatInputView) {
        _chatInputView = [[JHChatInputView alloc] initWithFrame:CGRectZero];
        _chatInputView.delegate = self;
    }
    return _chatInputView;
}
- (JHChatWarningView *)warningView {
    if (!_warningView) {
        _warningView = [[JHChatWarningView alloc] initWithFrame:CGRectZero];
        @weakify(self)
        _warningView.closedHandler = ^{
            @strongify(self)
            [self.sessionManager setWaringHiden];
            
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.jhNavView.mas_bottom);
                make.left.right.mas_equalTo(0);
                make.bottom.mas_equalTo(self.quickView.mas_top);
            }];
        };
    }
    return _warningView;
}
- (JHChatOrderView *)orderView {
    if (!_orderView) {
        _orderView = [[JHChatOrderView alloc] initWithFrame:CGRectZero];
        @weakify(self)
        _orderView.sendHandler = ^(JHChatOrderInfoModel * _Nonnull orderInfo) {
            @strongify(self)
            [self.sessionManager sendMessageWithOrder:orderInfo];
        };
    }
    return _orderView;
}
- (JHChatNewMessageView *)chatNewMessageView {
    if (!_chatNewMessageView) {
        _chatNewMessageView = [[JHChatNewMessageView alloc] initWithFrame:CGRectZero];
        _chatNewMessageView.hidden = true;
        @weakify(self)
        _chatNewMessageView.clickHandler = ^{
            @strongify(self)
//            self.neMessageCount = 0;
            self.chatNewMessageView.hidden = true;
            [self scrollToIndex:self.sessionManager.chatManager.unreadIndex];
        };
    }
    return _chatNewMessageView;
}
- (UIButton *)naviRightButton {
    if (!_naviRightButton) {
        _naviRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_naviRightButton setTitle:@"Ta的主页" forState:UIControlStateNormal];
        _naviRightButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
        [_naviRightButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_naviRightButton addTarget:self action:@selector(didClickUserInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naviRightButton;
}
- (JHIMQuickView *)quickView {
    if (!_quickView) {
        _quickView = [[JHIMQuickView alloc] initWithFrame:CGRectZero];
        @weakify(self)
        _quickView.handler = ^(JHIMQuickModel * _Nonnull model) {
            @strongify(self)
            [self quickViewHandler : model];
        };
    }
    return _quickView;
}
@end
