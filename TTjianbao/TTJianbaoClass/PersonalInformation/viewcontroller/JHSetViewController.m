//
//  JHSetViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/13.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHSetViewController.h"
#import "JHWebViewController.h"
#import "JHSettingAutoPlayController.h"
#import "NTESService.h"
#import "NTESLoginManager.h"
#import "JHQYChatManage.h"
#import "JHWebImage.h"
#import "NTESLogManager.h"
#import "FileUtils.h"
#import "JHSwitch.h"
#import "TTjianbaoBussiness.h"
#import "JHResaleLiveRoomTabView.h"
#import "JHMainLiveRoomTabView.h"
#import "JHLastSaleStoneView.h"
#import "JHMainLiveSmartModel.h"
#import "JHMainRoomOnSaleStoneView.h"
#import "UITitleValueMoreCell.h"
#import "CommAlertView.h"

#import "JHContactManager.h"



typedef NS_ENUM(NSInteger, JHSetListType) {
    ///用户协议
    JHSetListTypeUserProtocol=0,
    
    ///清除缓存
    JHSetListTypeCleanCache,
    
    ///去评价
    JHSetListTypeRecommnet,
    
    ///关于我们
    JHSetListTypeAboutUs,
    
    ///开发者选项
    JHSetListTypeDeveloper,
    
    ///浮窗直播开关
    JHSetListTypeFloatWindowSwitch,
    
    ///土豪进场特效开关
    JHSetListTypeRicherSwitch,
    
    /// 接收新消息通知
    JHSetListTypeReceiveMessageSwitch,
    
    ///个性推荐
    JHSetListTypeRecommendSwitch,
    
    ///视频自动播放
    JHSetListTypeAutoPlay,
    
};

@interface JHSetListModel : NSObject
@property (nonatomic,   copy) NSString *title;
@property (nonatomic,   copy) NSString *detailValue;
@property (nonatomic, assign) JHSetListType listType;

@end

@implementation JHSetListModel
@end

@interface JHSetViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHSwitch  *switchMessageView;

@end

@implementation JHSetViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@*************被释放",[self class])
}

- (UIView *)footer {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 61)];
    UIButton *loginoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    loginoutBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
    [loginoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginoutBtn.backgroundColor = [UIColor whiteColor];
    loginoutBtn.frame = CGRectMake(0, 10, ScreenW, 51);
    [loginoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:loginoutBtn];
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self  initToolsBar];
//    [self.navbar setTitle:@"设置"];
    self.title = @"设置"; //背景颜色不一致
//    self.view.backgroundColor = kColorF5F6FA;
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageSwitch) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self.view addSubview:self.tableView];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - GET

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight+10, ScreenW, ScreenH - UI.statusAndNavBarHeight - UI.bottomSafeAreaHeight-10) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[UITitleValueMoreCell class] forCellReuseIdentifier:@"UITitleValueMoreCell"];
        [_tableView registerClass:[UITitleValueMoreCell class] forCellReuseIdentifier:@"UITitleValueSwitchCell"];
        [_tableView registerClass:[UITitleValueMoreCell class] forCellReuseIdentifier:@"UITitleValueRichSwitchCell"];
        [_tableView registerClass:[UITitleValueMoreCell class] forCellReuseIdentifier:@"UITitleValueReceiveMessageSwitchCell"];
        if ([JHRootController isLogin]) {
            _tableView.tableFooterView = [self footer];
        }
        else {
            _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
        }
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHSetListModel *model = self.dataArray[indexPath.row];
    
    switch (model.listType) {
        case JHSetListTypeFloatWindowSwitch:
        {
          UITitleValueMoreCell *cell=[self configSwitchCell:tableView action:@selector(switchAction:) identifier:@"UITitleValueSwitchCell" type:JHSetListTypeFloatWindowSwitch];
          [cell setTitle:model.title value:model.detailValue placeholder:@""];
          return cell ;
        }
            break;
    
        case JHSetListTypeRicherSwitch:
        {
              UITitleValueMoreCell *cell=[self configSwitchCell:tableView action:@selector(switchRichAction:) identifier:@"UITitleValueRichSwitchCell" type:JHSetListTypeRicherSwitch];
              [cell setTitle:model.title value:model.detailValue placeholder:@""];
              return cell ;
        }
            break;
    
        case JHSetListTypeReceiveMessageSwitch:
        {
            UITitleValueMoreCell *cell=[self configSwitchCell:tableView action:@selector(switchMessageAction:) identifier:@"UITitleValueReceiveMessageSwitchCell" type:JHSetListTypeReceiveMessageSwitch];
            [cell setTitle:model.title value:model.detailValue placeholder:@""];
            return cell ;
        }
            break;
            
        case JHSetListTypeRecommendSwitch:
        {
            UITitleValueMoreCell *cell=[self configSwitchCell:tableView action:@selector(switchRecommendMessageAction:) identifier:@"UITitleValueReceiveMessageSwitchCell" type:JHSetListTypeRecommendSwitch];
            [cell setTitle:model.title value:model.detailValue placeholder:@""];
            return cell ;
        }
            break;
            
        default:
        {
            UITitleValueMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITitleValueMoreCell"];
            if (model.listType == JHSetListTypeCleanCache) {
                model.detailValue = [self getCacheString];
            }
            [cell setTitle:model.title value:model.detailValue placeholder:@""];
            return cell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHSetListModel *model = self.dataArray[indexPath.row];
    
    switch (model.listType) {
        case JHSetListTypeUserProtocol:
        {
            JHWebViewController *vc = [[JHWebViewController alloc] init];
            vc.titleString = @"用户服务与声明";
            vc.urlString = H5_BASE_STRING(@"/jianhuo/app/agreement/agreementEntrance.html");
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        case JHSetListTypeCleanCache:
        {
            if ([[self getCacheString] isEqualToString:@"0.0M"]) {
                [SVProgressHUD showErrorWithStatus:@"没有缓存,无需清理哦~"];
            }
            else
            {
                [self showClearCache:[self getCacheString]];
            }
        }
            break;
            
        case JHSetListTypeRecommnet:
        {  ///去评价
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1457794084?mt=8"]];
        }
            break;
            
        case JHSetListTypeAboutUs:
        {
            JHWebViewController *vc = [[JHWebViewController alloc] init];
            vc.titleString = @"关于我们";
            vc.urlString = H5_BASE_STRING(@"/jianhuo/aboutus.html");
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case JHSetListTypeDeveloper:
        {
            BOOL interactSDK = [[NSUserDefaults standardUserDefaults] boolForKey:LiveSDK];
            [[NSUserDefaults standardUserDefaults] setBool:!interactSDK forKey:LiveSDK];
             [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
            
        case JHSetListTypeAutoPlay:
        {
            [self.navigationController pushViewController:[JHSettingAutoPlayController new] animated:YES];
        }
            break;
            
        default:
            break;
    }
     
}
- (UITitleValueMoreCell *)configSwitchCell:(UITableView *)tableView action:(SEL)method identifier:(NSString *)dentifier type:(JHSetListType)type  {
    UITitleValueMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:dentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryView = nil;
        JHSwitch  *switchView=[[JHSwitch alloc]init];
    if(type == JHSetListTypeFloatWindowSwitch)
    {
        switchView.on=![[NSUserDefaults standardUserDefaults]boolForKey:kFloatWindowLiveClose];
    }
    else if(type == JHSetListTypeRicherSwitch)
    {
        switchView.on = [UserInfoRequestManager sharedInstance].user.customerRichStatus == 1;
    }else if (type == JHSetListTypeReceiveMessageSwitch){
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        switchView.on = (setting.types != UIUserNotificationTypeNone);
        self.switchMessageView = switchView;
    }
    else if (type == JHSetListTypeRecommendSwitch){
        switchView.on = ![[NSUserDefaults standardUserDefaults] boolForKey:NSUserDefaultsServerRecommendCloseSwitch];
    }
    switchView.onTintColor= kColorMain;
    [switchView addTarget:self action:method forControlEvents:UIControlEventValueChanged];
    [cell addSubview:switchView];
    [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset([switchView leftRightOffset:-15]);
        make.centerY.equalTo(cell);
    }];
    return cell;
}
- (void)loadData {
    
    {
        JHSetListModel *model1 = [[JHSetListModel alloc] init];
        model1.title = @"用户服务与声明";
        model1.detailValue = @"";
        model1.listType = JHSetListTypeUserProtocol;
        [self.dataArray addObject:model1];
    }
    
    {
        JHSetListModel *model2 = [[JHSetListModel alloc] init];
        model2.title = @"清除缓存";
        model2.detailValue = [self getCacheString];
        model2.listType = JHSetListTypeCleanCache;
        [self.dataArray addObject:model2];
    }
    
    {
        JHSetListModel *model3 = [[JHSetListModel alloc] init];
        model3.title = @"直播小屏观看";
        model3.detailValue = @"";
        model3.listType = JHSetListTypeFloatWindowSwitch;
        [self.dataArray addObject:model3];
    }
    {
        JHSetListModel *model8 = [[JHSetListModel alloc] init];
        model8.title = @"接收新消息通知";
        model8.detailValue = @"";
        model8.listType = JHSetListTypeReceiveMessageSwitch;
        [self.dataArray addObject:model8];
    }
    {
        JHSetListModel *model8 = [[JHSetListModel alloc] init];
        model8.title = @"接受个性化推荐";
        model8.detailValue = @"";
        model8.listType = JHSetListTypeRecommendSwitch;
        [self.dataArray addObject:model8];
    }
    if([UserInfoRequestManager sharedInstance].user.hasBigCustomerType == 1)
    {
        JHSetListModel *model4 = [[JHSetListModel alloc] init];
        model4.title = @"土豪进场特效";
        model4.detailValue = @"";
        model4.listType = JHSetListTypeRicherSwitch;
        [self.dataArray addObject:model4];
    }
    
    {
        JHSetListModel *model5 = [[JHSetListModel alloc] init];
        model5.title = @"视频自动播放";
        model5.detailValue = @"";
        model5.listType = JHSetListTypeAutoPlay;
        [self.dataArray addObject:model5];
    }
    
    {
        JHSetListModel *model5 = [[JHSetListModel alloc] init];
        model5.title = @"去评价";
        model5.detailValue = @"";
        model5.listType = JHSetListTypeRecommnet;
        [self.dataArray addObject:model5];
    }
 
    {
        JHSetListModel *model6 = [[JHSetListModel alloc] init];
        model6.title = @"关于我们";
        model6.detailValue = [NSString stringWithFormat:@"V%@", JHAppVersion];
        model6.listType = JHSetListTypeAboutUs;
        [self.dataArray addObject:model6];
    }
  
    {
        BOOL interactSDK = [[NSUserDefaults standardUserDefaults] boolForKey:LiveSDK];
        JHSetListModel *model7 = [[JHSetListModel alloc] init];
        model7.title = @"开发者选项";
        model7.detailValue = interactSDK?@"已关闭":@"已开启";
        model7.listType = JHSetListTypeDeveloper;
    }

    [self.tableView reloadData];
}
-(void)switchAction:(UISwitch*)aSwitch{
    
    if (!aSwitch.on) {
      aSwitch.on=YES;
      CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"关闭后将无法通过浮窗观看直播" cancleBtnTitle:@"仍然关闭" sureBtnTitle:@"不关闭"];
     [[UIApplication sharedApplication].keyWindow addSubview:alert];
        alert.cancleHandle = ^{
           aSwitch.on=NO;
        [[NSUserDefaults standardUserDefaults] setBool:!aSwitch.on forKey:kFloatWindowLiveClose];
        [[NSUserDefaults standardUserDefaults] synchronize];
        };
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:!aSwitch.on forKey:kFloatWindowLiveClose];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
}

-(void)switchRichAction:(UISwitch*)sender
{
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    [dic setValue:user.customerId forKey:@"customerId"];
    [dic setValue:(sender.on ? @1 : @0) forKey:@"status"];
    [HttpRequestTool postWithURL: FILE_BASE_STRING(@"/auth/customerRichStatus/update") Parameters:dic
           requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        user.customerRichStatus = sender.on ? 1 : 0;
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD showInfoWithStatus:respondObject.message];
    }];
}

- (void)switchRecommendMessageAction:(UISwitch*)sender
{
    if (!sender.on) {
      CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"关闭后将不会根据您平台的行为习惯为您进行个性化推荐和个性化消息推送" cancleBtnTitle:@"仍然关闭" sureBtnTitle:@"不关闭"];
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        alert.cancleHandle = ^{
            [self switchRecommendWithCount:1 switchView:sender];
        };
        alert.handle = ^{
            sender.on = YES;
        };
    }
    else
    {
        [self switchRecommendWithCount:0 switchView:sender];
    }
}

-(void)switchRecommendWithCount:(NSInteger)count switchView:(UISwitch *)switchView
{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/customer/setIsAcceptRecommendNoAuth") Parameters:@{@"isAcceptRecommend" : @(count)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel * _Nullable respondObject) {
        switchView.on = (count == 0 ? YES : NO);
        [[NSUserDefaults standardUserDefaults] setBool:!switchView.isOn forKey:NSUserDefaultsServerRecommendCloseSwitch];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        switchView.on = (count == 1 ? YES : NO);
        NSLog(@"1");
    }];
}
-(void)switchMessageAction:(UISwitch*)sender{
    
    if (!sender.on) {
//        sender.on=YES;
      CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"关闭后将无法接收新消息通知" cancleBtnTitle:@"仍然关闭" sureBtnTitle:@"不关闭"];
     [[UIApplication sharedApplication].keyWindow addSubview:alert];
        alert.cancleHandle = ^{
            // 跳转到系统设置
            NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:settingURL options:[NSDictionary dictionary] completionHandler:nil];
            } else {//iOS10之前
                [[UIApplication sharedApplication] openURL:settingURL];
            }
        };
        alert.handle = ^{
            sender.on=YES;
        };
    }else{
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:settingURL options:[NSDictionary dictionary] completionHandler:nil];
        } else {//iOS10之前
            [[UIApplication sharedApplication] openURL:settingURL];
        }
    }
}
- (void)refreshMessageSwitch{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    self.switchMessageView.on = (setting.types != UIUserNotificationTypeNone);
}
#pragma mark - *************** 弹出系统视图
- (void)showClearCache:(NSString *)sizeString {
    UIAlertView *cacheAlertView = [[UIAlertView alloc] initWithTitle:@"清除缓存"                                           message:[NSString stringWithFormat:@"当前缓存:%@,清除减少空间,保留提高加载速度",sizeString] delegate:self cancelButtonTitle:@"保留" otherButtonTitles:@"清除", nil];
    [cacheAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *path = [NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager removeItemAtPath:path error:NULL]) {
            
        }
        
           NSString *outputPath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/"];
        
        [[NSFileManager defaultManager] removeItemAtPath:outputPath
        error:nil];

        [JHWebImage clearDiskWithCompletion:^{
            [SVProgressHUD showSuccessWithStatus:@"清除成功"];
            [self.tableView reloadData];
        }];
        [JHWebImage clearCacheMemory];
        [self.tableView reloadData];
    }
}
#pragma mark - *************** 清除缓存
//获取缓存大小字符串
-(NSString *)getCacheString
{
    NSString *cache = @"0.0M";
    CGFloat size = (CGFloat)[JHWebImage totalDiskSize];
    if ((size/1024/1024) >= 1) {
        cache = [NSString stringWithFormat:@"%.1fM", size/1024/1024];
    }else if (size/1024 > 0){
        cache = [NSString stringWithFormat:@"%.1fKB", size/1024];
    }
    return cache;
}

- (void)logoutAction {
    //退出登录
    [JHRootController.serviceCenter willShowStartLiveButton:NO];
    [[JHBuryPointOperator shareInstance] userLogoutBury];
    [JHQYChatManage logout];
    [JHTracking logouted];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [JHRootController logoutAccountData];
    [FileUtils deleteFile:ChannelUserFileData];
    [UserInfoRequestManager sharedInstance].feidanPickerDataArray = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAppearRedHotKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAttentionStampTime];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGINSTATUS];
    ///银联签约认证每隔4小时申请一次认证发起交易
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSignContractFourHourKey];
    ///移除红包/礼物
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kWetherGrantGiftKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginedFirstGiftKey];

    ///退出登录 移除记录红包的key
//    [JHMaskingManager removeRedPocketKey];
    
    //清除最近联系人
    //[JHContactManager clear];
}

- (void)showDemoLog{
    
    UIViewController *vc = [[NTESLogManager sharedManager] demoLogViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav
                       animated:YES
                     completion:nil];
}

-(NSMutableArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [NSMutableArray arrayWithCapacity:8];
    }
    return _dataArray;
}
@end

