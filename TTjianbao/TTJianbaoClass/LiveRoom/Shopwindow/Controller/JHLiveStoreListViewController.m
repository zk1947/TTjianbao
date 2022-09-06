//
//  JHLiveStoreListViewController.m
//  TTjianbao
//
//  Created by YJ on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderDetailViewController.h"
#import "JHOrderDetailMode.h"
#import "JHOrderViewModel.h"
#import <NIMSDK/NIMSDK.h>
#import "NTESSessionMsgConverter.h"
#import "JHOrderConfirmViewController.h"
#import "JHSaleGoodsAddView.h"
#import "JHLiveStoreListViewController.h"
#import "JHLiveStoreListCell.h"
#import "JHUIFactory.h"
#import "UIView+JHGradient.h"
#import "JHShopwindowRequest.h"
#import "JHShopwindowGoodsListModel.h"
#import "JHGrowingIO.h"

#define kStoreCellUpIdentifier  @"StoreCellUpIdentifier"
#define kStoreCellNormalIdentifier  @"kStoreCellNormalIdentifier"
#define kStoreCellHistroyIdentifier  @"kStoreCellHistroyIdentifier"

@interface JHLiveStoreListViewController ()

@property (nonatomic, assign)JHLiveStoreListShowType storeTyoe;

@property (nonatomic, strong) ChannelMode *channel;

@property (nonatomic, strong) NSMutableArray <JHShopwindowGoodsListModel *>* arrayData;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *addGoodsButton;
@property (nonatomic, strong) NSMutableArray * uploadData;

@end

@implementation JHLiveStoreListViewController

- (instancetype)initWithType:(JHLiveStoreListShowType)type channel:(ChannelMode * _Nullable)channel {
    self = [super init];
    if (self) {
        _channel = channel;
        self.storeTyoe = type;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNew) name:@"shopwindowNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNew) name:ORDERSTATUSCHANGENotifaction object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillDisappear:(BOOL)animated{
    if (self.uploadData.count > 0) {
        
        NSMutableArray * temp = [self.uploadData mutableCopy];
        [self sa_uploadData:temp];
        [self.uploadData removeAllObjects];
    }
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.jhTableView.showsVerticalScrollIndicator = NO;
    
    [self requestData];
    //页面绘制
    self.view.backgroundColor = HEXCOLOR(0xFFFFFF);
    self.jhTableView.estimatedRowHeight = 130;
    [self.view addSubview:self.jhTableView];
    self.jhTableView.backgroundColor = HEXCOLOR(0xFFFFFF);
    if (self.storeTyoe == JHLiveStoreListShowTypeWithSaler_Header) {
        [self showTopHeaderView:@"添加商品" andDesc:@"商品上架后观众可在直播间浏览，方便您与观众按编号沟通。"];
    }
    else if (self.storeTyoe == JHLiveStoreListShowTypeWithSaler) {
        [self showTopHeaderView:@"一键上架" andDesc:@"温馨提示：上架商品最多展示50件"];
    }
    [self.jhTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self addRefreshView];
    
   // [self showBottomView]; 产品要求去掉
}
- (void)showBottomView{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    UILabel *tipLabel = [JHUIFactory createLabelWithTitle:@"—— 已经到底喽~ ——" titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentCenter];
    [self.bottomView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(10);
        make.right.equalTo(self.bottomView).offset(-10);
        make.top.equalTo(self.bottomView).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    self.jhTableView.tableFooterView = self.bottomView;
}

- (void)showTopHeaderView:(NSString *)btnTitle andDesc:(NSString *)desc
{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 70)];
//    headerView.backgroundColor = [UIColor whiteColor];
    self.addGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addGoodsButton setTitle:btnTitle forState:UIControlStateNormal];
    [self.addGoodsButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    self.addGoodsButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    [self.headerView addSubview:self.addGoodsButton];
    [self.addGoodsButton addTarget:self action:@selector(popAddGoodsView:) forControlEvents:UIControlEventTouchUpInside];
    [self.addGoodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(10);
        make.right.equalTo(self.headerView).offset(-10);
        make.top.equalTo(self.headerView).offset(0);
        make.height.mas_equalTo(44);
    }];
    self.addGoodsButton.layer.cornerRadius = 22;
    self.addGoodsButton.layer.masksToBounds = YES;
    [self.addGoodsButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    UILabel *tipLabel = [JHUIFactory createLabelWithTitle:desc titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentCenter];
    [self.headerView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(10);
        make.right.equalTo(self.headerView).offset(-10);
        make.top.mas_equalTo(self.addGoodsButton.mas_bottom).offset(9);
        make.height.mas_equalTo(17);
    }];
    //set tableview header
    self.jhTableView.tableHeaderView = self.headerView;
}
- (void)resetAddGoodsButton:(BOOL)isselect{
    if (isselect) {
        self.addGoodsButton.selected = YES;
        [self.addGoodsButton setTitleColor:HEXCOLORA(0x333333,0.2) forState:UIControlStateSelected];
        [self.addGoodsButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xF2F2F2), HEXCOLOR(0xF2F2F2)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    }else{
        self.addGoodsButton.selected = NO;
        [self.addGoodsButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [self.addGoodsButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    }
    
}
//获取在售数量
- (void)getSaleNum{
    @weakify(self);
    [JHShopwindowRequest requestshopwindowNumWithId:self.channel.channelLocalId successBlock:^(NSString * _Nonnull text) {
        @strongify(self);
        [self resetAddGoodsButton:([text floatValue]>=50)?YES:NO];
    }];
}
//添加商品点击
- (void)popAddGoodsView:(UIButton *)sender{
    
    if ([sender.currentTitle isEqualToString:@"一键上架"]) {
        if (sender.isSelected) { //上架商品满
            [SVProgressHUD showInfoWithStatus:@"上架商品超过限制，您可下架后再上架其他"];
        }else{
            @weakify(self);
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/showGoods/onekeyUpLine") Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
                @strongify(self);
                [SVProgressHUD showInfoWithStatus:OBJ_TO_STRING(respondObject.data)];
                [self requestData];
                
            } failureBlock:^(RequestModel * _Nullable respondObject) {
                [self getSaleNum];
                [SVProgressHUD showInfoWithStatus:respondObject.message];
            }];
        }
        
    }else{
        JHSaleGoodsAddView *sendView = [[JHSaleGoodsAddView alloc] initWithData:nil];
        @weakify(self);
        sendView.hiddenBlock = ^(BOOL hidden) {
            @strongify(self);
            [self loadNew];
            if(self.hiddenBlock)
            {
                self.hiddenBlock(hidden);
            }
        };
        if(self.hiddenBlock)
        {
            self.hiddenBlock(YES);
        }
    }
    
    
}
//无数据界面
- (void)mayShowEmptyPage
{
    if([self.arrayData count] > 0)
    {
        [self hiddenDefaultImage];
        self.jhTableView.tableFooterView = self.bottomView;
        if (self.storeTyoe == JHLiveStoreListShowTypeWithSaler){
            self.jhTableView.tableHeaderView = self.headerView;
        }
    }
    else
    {
        [self showDefaultImageWithView:self.jhTableView];
        [self setDefaultImageOffset:-30 andView:self.jhTableView];
        self.jhTableView.tableFooterView = nil;
        
        if (self.storeTyoe == JHLiveStoreListShowTypeWithSaler){
            self.jhTableView.tableHeaderView = nil;
        }
    }
}

#pragma mark - request
//- (JHUserCenterResaleDataModel*)dataModel
//{
//    if(!_dataModel)
//    {
//        _dataModel = [JHUserCenterResaleDataModel new];
//        _dataModel.delegate = self;
//    }
//    return _dataModel;
//}
//
- (void)loadNew
{
    [self requestData];
}
- (void)requestData
{

    if (self.storeTyoe == JHLiveStoreListShowTypeWithSaler_Header) {
        //已上架数据
        JH_WEAK(self)
        [JHShopwindowRequest requestUpListDeleteWithChannelLocalId:self.channel.channelId type:1 successBlock:^(NSArray<JHShopwindowGoodsListModel *> * _Nonnull data) {
            JH_STRONG(self)
            [self.arrayData removeAllObjects];
            [self.arrayData addObjectsFromArray:data];
            [self.jhTableView reloadData];
            [self hideRefreshView];
            [self mayShowEmptyPage];
        }];
    }else if (self.storeTyoe == JHLiveStoreListShowTypeWithSaler){
        //历史数据
        JH_WEAK(self)
        [JHShopwindowRequest requestUpListDeleteWithChannelLocalId:self.channel.channelId type:2 successBlock:^(NSArray<JHShopwindowGoodsListModel *> * _Nonnull data) {
            JH_STRONG(self)
            [self.arrayData removeAllObjects];
            [self.arrayData addObjectsFromArray:data];
            [self.jhTableView reloadData];
            [self hideRefreshView];
            [self mayShowEmptyPage];
            [self getSaleNum];
        }];
    }else{
        JH_WEAK(self)
        [JHShopwindowRequest requestUpListDeleteWithChannelLocalId:self.channel.channelLocalId type:0 successBlock:^(NSArray<JHShopwindowGoodsListModel *> * _Nonnull data) {
            JH_STRONG(self)
            [self.arrayData removeAllObjects];
            [self.arrayData addObjectsFromArray:data];
            [self.jhTableView reloadData];
            [self hideRefreshView];
            [self mayShowEmptyPage];
        }];
    }
}

#pragma mark - table datasource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    JHLiveStoreListCell* cell = nil;
    if (self.storeTyoe == JHLiveStoreListShowTypeWithSaler_Header) { //上架页cell
        cell = [tableView dequeueReusableCellWithIdentifier:kStoreCellUpIdentifier];
        if(!cell)
        {
            cell = [[JHLiveStoreListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kStoreCellUpIdentifier withCellType:JHLiveStoreListCellTypeSalerList_UP];
            
        }
        JHShopwindowGoodsListModel * model = self.arrayData[indexPath.row];
        [cell setCellDataModel:model andIndexPath:indexPath];
    }else if (self.storeTyoe == JHLiveStoreListShowTypeWithSaler){  //历史页cell
        cell = [tableView dequeueReusableCellWithIdentifier:kStoreCellHistroyIdentifier];
        if(!cell)
        {
            cell = [[JHLiveStoreListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kStoreCellHistroyIdentifier withCellType:JHLiveStoreListCellTypeSalerList_Histroy];
            
        }
        JHShopwindowGoodsListModel * model = self.arrayData[indexPath.row];
        [cell setCellDataModel:model andIndexPath:indexPath];
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:kStoreCellNormalIdentifier];
        if(!cell)
        {
            cell = [[JHLiveStoreListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kStoreCellNormalIdentifier withCellType:JHLiveStoreListCellTypeUserList];
            
        }
        if (indexPath.row < self.arrayData.count) {
            JHShopwindowGoodsListModel * model = self.arrayData[indexPath.row];
            [cell setCellDataModel:model andIndexPath:indexPath];
        }
        
    }
    @weakify(self);
    cell.clickButtonTypeBlock = ^(NSInteger type) {
        @strongify(self);
        [self clickWithIndexPath:indexPath type:type];
    };
    return cell;
       
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.storeTyoe == JHLiveStoreListShowTypeWithNormal) {
        JHShopwindowGoodsListModel * model = self.arrayData[indexPath.row];
        NSString * strtemp = [NSString stringWithFormat:@"%@",model.Id];
        if (![self.uploadData containsObject:strtemp]) {
            [self.uploadData addObject:strtemp];
            if (self.uploadData.count>=10) {
    
                NSMutableArray * temp = [self.uploadData mutableCopy];
                [self sa_uploadData:temp];
                [self.uploadData removeAllObjects];
            }
        }
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}
#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSMutableArray <JHShopwindowGoodsListModel *>*)arrayData{
    if (!_arrayData) {
        _arrayData = [[NSMutableArray alloc] initWithCapacity:8];
    }
    return _arrayData;
}
/// 1-咨询主播  2-去支付  3-购买   4-编辑   5-（删除）下架    6-删除    7-上架
-(void)clickWithIndexPath:(NSIndexPath *)indexPath type:(NSInteger)type
{
    JHShopwindowGoodsListModel *model = SAFE_OBJECTATINDEX(self.arrayData, indexPath.row);
    if(!model)
    {
        return;
    }
    switch (type) {
        case 1:///咨询主播
        {
            if(model.goodsStatus != 1)
            {
                [SVProgressHUD showInfoWithStatus:@"商品己销售，请刷新查看"];
            }
            else
            {
                static BOOL canSend = YES;
                if(canSend)
                {
                    [SVProgressHUD showInfoWithStatus:@"已将你的咨询信息发布到直播间"];
                    [self didSendText:[NSString stringWithFormat:@"想看%@号宝贝",model.sort]];
                    canSend = NO;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        canSend = YES;
                    });
                }
                else
                {
                    [SVProgressHUD showInfoWithStatus:@"请勿频繁操作"];
                }
            }
            [JHGrowingIO trackEventId:JHChannelLocalldShopConsultClick variables:@{@"channelLocalId":self.channel.channelId ? : @""}];
        }
            break;
            
        case 2:///去支付
        {
            JH_WEAK(self);
            [self gotoBuyWithModel:model successBlock:^(RequestModel *respondObject){
                JH_STRONG(self);
                JHOrderDetailMode *detail=[JHOrderDetailMode mj_objectWithKeyValues:respondObject.data];
                if (detail.orderId&&[detail.orderId length]>0) {
                    ///订单详情页面
                    [self enterOrderDetailPage:detail.orderId];
                }
            } failBlock:^(NSString *message) {
                [SVProgressHUD showErrorWithStatus:message];
            }];
        }
            return;
            
        case 3:///购买
        {
            [self sa_jhTrackingData:model];
            
            JH_WEAK(self);
            
            [self gotoBuyWithModel:model successBlock:^(RequestModel *respondObject) {
                JH_STRONG(self);
                [JHShopwindowRequest requestEditDetailWithId:model.Id successBlock:^(JHShopwindowGoodsListModel * _Nonnull data) {
                    
                    if(data.goodsStatus == 1 && data.onlineFlag == 1)
                    {
                        JHOrderConfirmViewController *vc = [JHOrderConfirmViewController new];
                        vc.goodsId = model.code;
                        vc.orderType = JHOrderTypeshopWindow;
                        vc.orderCategory = @"showWindowOrder";
                        vc.activeConfirmOrder = YES;
//                        vc.payBlock = ^{
//                            [self loadNew];
//                        };
                        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
//                        if(self.removeBlock)
//                        {
//                            self.removeBlock();
//                        }
                    }
                    else
                    {
                        [self loadNew];
                        [SVProgressHUD showInfoWithStatus:@"商品已售完或已下架"];
                    }
                }];

            } failBlock:^(NSString *message) {
                CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:message cancleBtnTitle:@"我知道了"];
                [[UIApplication sharedApplication].keyWindow addSubview:alert];
            }];
            [JHGrowingIO trackEventId:JHChannelLocalldShopBuyClick variables:@{@"channelLocalId":self.channel.channelId ? : @""}];
        }
            break;
            
        case 4:///编辑
        {
            @weakify(self);
            [JHShopwindowRequest requestEditDetailWithId:model.Id successBlock:^(JHShopwindowGoodsListModel * _Nonnull data) {
                if(data.goodsStatus == 1)
                {
                    if(self.hiddenBlock)
                    {
                        self.hiddenBlock(YES);
                    }
                    
                    JHSaleGoodsAddView *sendView = [[JHSaleGoodsAddView alloc] initWithData:data];
                    sendView.hiddenBlock = ^(BOOL hidden) {
                        @strongify(self);
                        if(self.hiddenBlock)
                        {
                            [self loadNew];
                            self.hiddenBlock(hidden);
                        }
                    };
                }
                else
                {
                    [self loadNew];
                    [SVProgressHUD showInfoWithStatus:@"商品已售出"];
                }
            }];
        }
            break;
            
        case 5:///（删除）下架
        {
            [JHShopwindowRequest requestDownLineWithId:model.Id successBlock:^{
                [self.arrayData removeObjectAtIndex:indexPath.row];
                [self.jhTableView reloadData];
                [self mayShowEmptyPage];
            }];
        }
            break;
            
        case 6:///删除
        {
            [self showSheetWithBlock:^{
                [JHShopwindowRequest requestDownLineDeleteWithId:model.Id successBlock:^{
                    [self.arrayData removeObjectAtIndex:indexPath.row];
                    [self.jhTableView reloadData];
                    [self mayShowEmptyPage];
                }];
            }];
            
        }
            break;
            
        case 7:///上架
        {
            [JHShopwindowRequest requestUpLineWithId:model.Id successBlock:^{
                [self.arrayData removeObjectAtIndex:indexPath.row];
                [self.jhTableView reloadData];
                [self mayShowEmptyPage];
                [self getSaleNum];
            }];
        }
            break;
            
        case 8:///上架列表删除
        {
            [self showSheetWithBlock:^{
                [JHShopwindowRequest requestUpListDeleteWithId:model.Id successBlock:^{
                    [self.arrayData removeObjectAtIndex:indexPath.row];
                    [self.jhTableView reloadData];
                    [self mayShowEmptyPage];
                }];
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)didSendText:(NSString *)text
{
    NIMMessage *message = [NTESSessionMsgConverter msgWithText:text];

    NIMMessageChatroomExtension *ext = [[NIMMessageChatroomExtension alloc] init];
    ext.roomAvatar = [UserInfoRequestManager sharedInstance].user.icon?:@"";
    ext.roomNickname = [UserInfoRequestManager sharedInstance].user.name?:@"";
    
    if ([JHRootController isLogin]){
    
        NSMutableDictionary *dic = [[UserInfoRequestManager sharedInstance] getEnterChatRoomExtWithChannel:self.channel];
        dic[@"roomRole"] = @"0";
        ext.roomExt = [dic mj_JSONString];
    }
    
    message.messageExt = ext;
    
    NIMSession *session = [NIMSession session:self.channel.roomId type:NIMSessionTypeChatroom];
    
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}

-(void)showSheetWithBlock:(dispatch_block_t)block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除吗" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(block)
        {
            block();
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)gotoBuyWithModel:(JHShopwindowGoodsListModel *)model successBlock:(void(^)(RequestModel *respondObject))successBlock failBlock:(void(^)(NSString *message))failBlock
{
    JHGoodsOrderDetailReqModel *m = [JHGoodsOrderDetailReqModel new];
    m.goodsId = model.code;
    m.orderType = @(JHOrderTypeshopWindow).stringValue;
    m.orderCategory = @"showWindowOrder";
    
    [JHOrderViewModel requestGoodsConfirmDetail:m completion:^(RequestModel *respondObject, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            successBlock(respondObject);
        }
        else {
            failBlock(respondObject.message);
        }
    }];
}

- (void)enterOrderDetailPage:(NSString *)orderId {
    JHOrderDetailViewController *vc = [[JHOrderDetailViewController alloc] init];
    vc.orderId = orderId;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}


- (NSMutableArray *)uploadData{
    if (!_uploadData) {
        _uploadData = [NSMutableArray array];
    }
    return _uploadData;
}
- (void)sa_uploadData:(NSMutableArray *)array{
    [JHTracking trackEvent:@"ep" property:@{@"page_position":@"直播间商品橱窗列表页",@"model_name":@"橱窗商品列表",@"res_type":@"商品feeds",@"channel_local_id":self.channel.channelLocalId,@"item_list":array}];
}
- (void)sa_jhTrackingData:(JHShopwindowGoodsListModel *)model{
    [JHTracking trackEvent:@"buyButtonClick" property:@{@"page_position":@"直播间橱窗弹层页",@"button_name":@"购买",@"commodity_id":model.Id,@"commodity_name":model.title,@"original_price":model.price,@"channel_local_id":self.channel.channelLocalId,@"live_type":self.channel.channelCategory}];
}
@end
