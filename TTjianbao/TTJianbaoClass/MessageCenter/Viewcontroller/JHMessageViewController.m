//
//  JHMessageViewController.m
//  TTjianbao
//
//  Created by mac on 2019/5/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHMessageViewController.h"
#import "JHMessageSubListController.h"
#import "JHMessageOpenNoticeView.h"
#import "JHPushSwitchTableViewCell.h"
#import "JHMsgListTableViewCell.h"
#import "JHMsgListHeaderTableViewCell.h"
#import "JHMessageCenterData.h"
#import "JHQYChatManage.h"
#import "JHGrowingIO.h"
#import "PanNavigationController.h"

#import "JHGreetViewController.h"
#import "JHCommunityNewListViewController.h"
#import "JHSessionListManager.h"
#import "JHSessionViewController.h"
#import "JHIMEntranceManager.h"
@interface JHMessageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) PushSwitchType pushSwitchType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHMessageCenterData* msgData;
@end

@implementation JHMessageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@*************被释放",[self class])
}

- (instancetype)init{
    
    if(self = [super init]){
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActiveFromViewLoad:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kefuNoreadCount:) name:NotificationNameChatUnreadCountChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvMsg:) name:NotificationNameChatReceivedMessage object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[JHIMLoginManager sharedManager] imLogin];
    [[JHSessionListManager sharedManager] getSessionList];
    [self.msgData kefuNoticeCount]; //获取 客服通知数
    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
//    [self setupToolBarWithTitle:@"消息中心"];
    self.title = @"消息中心";
    [self makeUI];
    
    [self.msgData checkShowPopupView:^(id obj) {
        if([obj isKindOfClass:[NSNumber class]])
        {//“status":1未开启显示,2未开启不显示,3开启不显示
            NSString *status;
            BOOL show = [(NSNumber*)obj boolValue];
            if(show)
            {
                JHMessageOpenNoticeView* noticeView = [JHMessageOpenNoticeView new];
                [self.view addSubview:noticeView];
                status = @"unopen_show";
            }
            else
            {
                BOOL isOpen = [CommHelp isUserNotificationEnable];
                if(isOpen)
                {
                    status = @"open_unshow";
                }
                else
                {
                    status = @"unopen_unshow";
                }
            }
            
           [JHGrowingIO trackPublicEventId:JHTrackMsgCenterEnter paramDict:@{@"from":self.from ? : @"", @"status":status}];
        }
    }];
    [self bindData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self didBecomeActiveFromViewLoad:YES];
    [self requestContentData];

    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        [nav setShouldReceiveTouchViewController:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - request
- (JHMessageCenterData *)msgData{
    if(!_msgData){
        _msgData = [JHMessageCenterData new];
    }
    return _msgData;
}

- (void)requestContentData
{
    JH_WEAK(self)
    [self.msgData requestData:^(id obj, id data) {
        JH_STRONG(self)
        [self reloadViewFromRequest:(obj ? YES : NO) endRefresh:(data ? YES : NO)];
    }];
}

#pragma mark - subview
- (void)makeUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHPushSwitchTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"JHPushSwitchTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHMsgListTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"JHMsgListTableViewCell"];

        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHMsgListHeaderTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"JHMsgListHeaderTableViewCell"];

        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 70;
        
        JH_WEAK(self)
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
    
            JH_STRONG(self)
            [self requestContentData];
        }];
    }
    return _tableView;
}

- (JHMsgListHeaderTableViewCell *)getHeaderCell {
    JHMsgListHeaderTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"JHMsgListHeaderTableViewCell"];
    JH_WEAK(self)
    cell.actionBlock = ^(NSString *type) {
        JH_STRONG(self)
        JHMsgCenterModel* model = [JHMsgCenterModel new];
        model.type = type;
        if([type isEqualToString: kMsgSublistTypeExpress])
        {
            model.title = @"订单物流";
        }
        else //kMsgSublistTypeActivity
        {
            model.title = @"优惠活动";
        }
        [self actionBtnWithModel:model];
        [self.tableView reloadData];
        [JHGrowingIO trackPublicEventId:JHTrackMsgCenterImportantCateClick paramDict:@{@"status":model.type}];
    };
    [cell updateData:self.msgData.mainDataArray unread:self.msgData.unReadModel];
    return cell;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {//通知&重要分类
        return 1 + ((self.pushSwitchType==PushSwitchTypeHidden) ? 0 : 1);
    }
    
    //分类+客服+商家&用户消息
    return self.msgData.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.pushSwitchType != PushSwitchTypeHidden) {
            if (indexPath.row == 0) {
                return kPushSwitchCellHeight;
            }
            return kMsgListHeaderCellHeight;
        }
        return kMsgListHeaderCellHeight;
    }
    return kMsgListCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.pushSwitchType != PushSwitchTypeHidden) {
            if (indexPath.row == 0) {
                JHPushSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHPushSwitchTableViewCell"];
                [cell showTextWithType:self.pushSwitchType];
                return cell;
                
            }else if (indexPath.row == 1){
                return [self getHeaderCell];
            }
        }else {
            return [self getHeaderCell];
        }
    }
   
    JHMsgListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHMsgListTableViewCell"];
    cell.model = self.msgData.dataArray[indexPath.row];

    return cell;
}
//cell can edit
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath{
    return  YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0)
        return UITableViewCellEditingStyleNone;
    return UITableViewCellEditingStyleDelete;
}

- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath{
    return  @"删除";
}

//执行删除操作
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
//    [tableView beginUpdates];
    if(indexPath.section == 1 && indexPath.row < self.msgData.dataArray.count &&
       indexPath.row >=0 && UITableViewCellEditingStyleDelete == editingStyle)
    {
        JHMsgCenterModel* model = self.msgData.dataArray[indexPath.row];

        if([model.type isEqualToString: kMsgSublistTypeKefu])
        {
            [self.msgData.dataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [JHQYChatManage deleteSessionWithShopId:model.shopId];//暂时不考虑失败情况,无回调
        }else if ([model.type isEqualToString: kMsgSublistTypeIM]) {
            [self.msgData.dataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[JHSessionListManager sharedManager] deleteSession:model.session];
        }
        else
        {
            [SVProgressHUD show];
            [self.msgData removeCategeryByType:model.type finish:^(NSString* msg) {
                if(msg)
                {
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                else
                {
                    [self.msgData removeDataFromModel:model];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [SVProgressHUD dismiss];
                }
            }];
        }
    }
//    [tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        JHMsgCenterModel *model = self.msgData.dataArray[indexPath.row];
        if([model.type isEqualToString:kMsgSublistTypeKefu]) {
//            [[JHQYChatManage shareInstance] showPlatformChatWithViewcontroller:self];
            [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:self shopId:model.shopId title:model.title];
            [JHGrowingIO trackPublicEventId:JHTrackMsgCenterServiceClick paramDict:@{@"account":model.shopId?:@""}];
        }
        else if ([model.type isEqualToString:kMsgSublistTypeGreet]) {
            //@我的  hutao--add
            JHGreetViewController *vc = [[JHGreetViewController alloc] init];
            vc.pageIndex = model.pageIndex;
            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        } else if ([model.type isEqualToString:kMsgSublistTypeCommunityNew]) {
            //社区官方消息  hutao--add
            JHCommunityNewListViewController *vc = [[JHCommunityNewListViewController alloc] init];
            vc.titleStr = model.title;
            vc.pageType = model.type;
            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        } else if ([model.type isEqualToString:@"recycle_community"]) {
            /// 回收消息
            JHCommunityNewListViewController *vc = [[JHCommunityNewListViewController alloc] init];
            vc.titleStr = model.title;
            vc.pageType = model.type;
            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        }else if ([model.type isEqualToString:kMsgSublistTypeIM]) {
            [JHIMEntranceManager pushSessionWithAccount:model.receiveAccount sourceType:JHIMSourceTypeSessionCenter ];
            [self.msgData setUnreadModelWithModel:model];
        }
        else {
            model.total = 0;
            [self actionBtnWithModel:model];
            [self.tableView reloadData];
            [JHGrowingIO trackPublicEventId:JHTrackMsgCenterCateClick paramDict:@{@"status":model.type}];
        }
    }
}

#pragma mark - refresh view
- (void)reloadViewFromRequest:(BOOL)isReload endRefresh:(BOOL)isRefresh
{
    if(isReload)
    {
        [self.tableView reloadData];
    }
    // 应该没用到
    if(isRefresh)
    {
        [self.tableView.mj_header endRefreshing];
    }
}

- (void)didBecomeActiveFromViewLoad:(BOOL)fromLoad{
    BOOL isOpen = [CommHelp isUserNotificationEnable];
    if(isOpen)
    {
        if(fromLoad)
            self.pushSwitchType = PushSwitchTypeHidden;
        else
            self.pushSwitchType = PushSwitchTypeShowOpen;
    }
    else
    {
        self.pushSwitchType = PushSwitchTypeShowClose;
    }
    [self.tableView reloadData];
}

- (void)kefuNoreadCount:(NSNotification *)noti {
    self.msgData.kefuNoticeCount = [noti.object integerValue];
    [self.msgData reloadKefuData];
    [self.tableView reloadData];
}

- (void)recvMsg:(NSNotification *)noti {
    [self.msgData reloadKefuData];
    [self.tableView reloadData];
}

#pragma mark - event
- (void)actionBtnWithModel:(JHMsgCenterModel*)model{

    [self.msgData setUnreadModelWithModel:model];
    
    JHMessageSubListController * message=[[JHMessageSubListController alloc] initWithTitle:model.title pageType:model.type];
    [self.navigationController pushViewController:message animated:YES];
}

- (void)bindData {
    @weakify(self)
    [self.msgData.reloadDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}
@end
