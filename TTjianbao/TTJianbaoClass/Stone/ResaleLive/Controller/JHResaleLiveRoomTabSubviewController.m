//
//  JHResaleLiveRoomTabSubviewController.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHResaleLiveRoomTabSubviewController.h"
#import "JHBuyPriceTableViewCell.h"
#import "JHRROnSaleTableViewCell.h"
#import "JHStoneResaleTableViewCell.h"
#import "JHMyPriceTableViewCell.h"
#import "JHBuyerPriceListModel.h"
#import "JHMyPriceListModel.h"
#import "BYTimer.h"

#define kResaleLiveRoomTabStoneResaleIdentifier     @"kResaleLiveRoomTabStoneResaleIdentifier"
#define kResaleLiveRoomTabOnSaleIdentifier          @"kResaleLiveRoomTabOnSaleIdentifier"
#define kResaleLiveRoomTabBuyPriceIdentifier        @"kResaleLiveRoomTabBuyPriceIdentifier"
#define kResaleLiveRoomTabMyPriceIdentifier         @"kResaleLiveRoomTabMyPriceIdentifier"

@interface JHResaleLiveRoomTabSubviewController ()<JHResaleLiveRoomTabDataDelegate>
{
    JHResaleLiveRoomTabType pageType;
    NSUInteger pageIndex;
    NSString* channelId;
    BYTimer *timer;
}

@property (nonatomic, strong) JHResaleLiveRoomTabDataModel* dataModel;
@property (nonatomic, strong) NSMutableArray* dataArr;
@property (nonatomic, strong) NSMutableArray* backupDataArr;

@end

@implementation JHResaleLiveRoomTabSubviewController
@synthesize dataArr;

- (void)dealloc
{
    [SVProgressHUD dismiss];
    [timer stopGCDTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithPageType:(JHResaleLiveRoomTabType)type channelId:(NSString*)mChannelId
{
    if(self = [super init])
    {
        pageType = type;
        channelId = mChannelId;
        self.dataArr = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshByPushLiveroomAttach:) name:kPushStoneExplainNotification object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self removeNavView];
    //1,原石回血直接请求 2,其他三个tab需要登录后,允许请求
    if(pageType == JHResaleLiveRoomTabTypeStoneResale || [JHRootController isLogin])
    {
        [self loadNew];//优先请求data
    }
    else
    {
        [self mayShowEmptyPage];
    }
    //页面绘制
    self.view.backgroundColor = kCellThemeClearColor; //半透明
    [self.view addSubview:self.jhTableView];
    self.jhTableView.backgroundColor = kCellThemeClearColor; //半透明
    [self.jhTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //加载更多
    [self addLoadMoreView];
    if(pageType == JHResaleLiveRoomTabTypeMyPrice)
    {
        [self updateCellTimeStatus];//timer
    }
}

//无数据界面
- (void)mayShowEmptyPage
{
    if([self.dataArr count] > 0)
    {
        [self hiddenDefaultImage];
        //关掉加载更多view
        [self hideLoadMoreView];
        if(self.customAction && pageType == JHResaleLiveRoomTabTypeStoneResale)
            self.customAction(@(JHResaleTabStyleDefault));//默认给低样式
    }
    else
    {
        [self showImageName:@"img_empty_page" title:@"暂无内容" superview:self.jhTableView];//定制title和image
        [self hideLoadMoreWithNoData];
        if(self.customAction && pageType == JHResaleLiveRoomTabTypeStoneResale)
            self.customAction(@(JHResaleTabStyleHidden));
    }
}

- (void)callbackRefreshData
{
    [self loadNew];
}

- (void)refreshStoneResaleWithHiddenRecord:(BOOL)isHidden
{
    if(dataArr.count > 0 && JHResaleLiveRoomTabTypeStoneResale == pageType)
    {
        if(isHidden)
        {
            self.backupDataArr = [NSMutableArray arrayWithArray:dataArr];
            JHGoodResaleListModel* model = [[JHGoodResaleListModel alloc]initWithModel: dataArr[0]];
            model.offerRecordList = [NSArray array];
            model.isSimpleShow = YES;
            dataArr = [NSMutableArray arrayWithObject:model];
        }
        else
        {
            dataArr = [NSMutableArray arrayWithArray:self.backupDataArr];
        }

        [self.jhTableView reloadData];
    }
}

- (void)refreshStoneResaleCell:(NSIndexPath*)indexPath model:(JHGoodResaleListModel*)model
{
    if(JHResaleLiveRoomTabTypeStoneResale == pageType)
    {
        if(indexPath.row >= 0 && indexPath.row < dataArr.count && model)
        {
            [dataArr replaceObjectAtIndex:indexPath.row withObject:model];//更新数据
            NSArray* indexPathArr = [NSArray arrayWithObjects:indexPath, nil];
            [self.jhTableView reloadRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationAutomatic];//刷cell
        }
    }
}

- (void)refreshByPushLiveroomAttach:(NSNotification*)notify
{
    if(pageType == JHResaleLiveRoomTabTypeStoneResale)
    {
        JHStoneMessageModel* msg = [JHStoneMessageModel new];
        [msg mj_setKeyValues:[notify userInfo]];
        NSInteger explainingFlag = msg.explainingFlag; //是否为正在讲解（0：否、1：是）
        NSString* stoneRestoreId = msg.stoneRestoreId; //原石回血单ID
        for (int index = 0; index < [self.backupDataArr count]; index++)
        {
            JHGoodResaleListModel* backModel = self.backupDataArr[index];
            if([stoneRestoreId isEqualToString:backModel.stoneRestoreId])
            {
                @synchronized (self) {
                    //更新backup data
                    backModel.explainingFlag = explainingFlag;
                    //更新显示用data:1-list缩短时,数组仅有一个值2-list展开时,与backup一致
                    if(index < [dataArr count])
                    {
                        JHGoodResaleListModel* model = dataArr[index];
                        model.explainingFlag = explainingFlag;
                        //refresh show list
                        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                        [self.jhTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }
            }
        }
    }
}

-(void)updateCellTimeStatus
{
    if (!timer)
    {
        timer=[[BYTimer alloc]init];
    }
    JH_WEAK(self)
    [timer startGCDTimerOnMainQueueWithInterval:1 Blcok:^{
        JH_STRONG(self)
        [self updateTime];
    }];
    
}

-(void)updateTime
{
    NSArray* cellArr = [self.jhTableView visibleCells];
    for(id obj in cellArr)
    {
        if([obj isKindOfClass:[JHMyPriceTableViewCell class]])
        {
            JHMyPriceTableViewCell *cell=(JHMyPriceTableViewCell *)obj;
            JHMyPriceListModel* model = cell.cellModel;
            if ([CommHelp dateRemaining:model.offerDetail.expireTime] > 0)
            {
                cell.retainTimeText = [CommHelp getHMSWithSecond:[CommHelp dateRemaining:model.offerDetail.expireTime]];
            }
            else
            {
                cell.retainTimeText = @"0:0:0";
            }
        }
    }
}

#pragma mark - request
- (JHResaleLiveRoomTabDataModel*)dataModel
{
    if(!_dataModel)
    {
        _dataModel = [JHResaleLiveRoomTabDataModel new];
        _dataModel.delegate = self;
    }
    return _dataModel;
}

- (void)loadNew
{
    pageIndex = 0;
    [SVProgressHUD show];///loading  缺少配对 dismiss 切换直播间有几率不消失
    [self.dataModel requestByPage:pageType channelId:channelId pageIndex:pageIndex];
}

- (void)loadMore
{
    [self.dataModel requestByPage:pageType channelId:channelId pageIndex:++pageIndex];
}

//JHResaleLiveRoomTabDataDelegate
- (void)responseData:(NSMutableArray*)dataArray error:(NSString*)errorMsg
{
    if(errorMsg)
    {
        //tips
    }
    else
    {
        if(pageIndex > 0)
            [self.dataArr addObjectsFromArray:dataArray];
        else
            self.dataArr = dataArray;
        self.backupDataArr = [NSMutableArray arrayWithArray:dataArr];
        [self.jhTableView reloadData];
    }

    [self mayShowEmptyPage];
    [SVProgressHUD dismiss];
}

#pragma mark - table datasource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    switch (pageType)
    {
        case JHResaleLiveRoomTabTypeStoneResale:
        default:
        {
            JHStoneResaleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kResaleLiveRoomTabStoneResaleIdentifier];
            if(!cell)
            {
                cell = [[JHStoneResaleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kResaleLiveRoomTabStoneResaleIdentifier];
                cell.delegate = self.delegate;
            }
            cell.indexPath = indexPath;
            [cell updateCell:[dataArr objectAtIndex:indexPath.row]];
            
            return cell;
        }
            break;
            
        case JHResaleLiveRoomTabTypeOnSale:
            {
                JHRROnSaleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kResaleLiveRoomTabOnSaleIdentifier];
                if(!cell)
                {
                    cell = [[JHRROnSaleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kResaleLiveRoomTabOnSaleIdentifier];
                    cell.delegate = self.delegate;
                }
                
                [cell updateCell:[dataArr objectAtIndex:indexPath.row]];
                
                return cell;
            }
            break;
            
        case JHResaleLiveRoomTabTypeBuyPrice:
               {
                   JHBuyPriceTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kResaleLiveRoomTabBuyPriceIdentifier];
                   if(!cell)
                   {
                       cell = [[JHBuyPriceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kResaleLiveRoomTabBuyPriceIdentifier];
                       [cell setCellThemeType:JHCellThemeTypeClearColor];
                       cell.delegate = self.delegate;
                   }
                   
                   [cell updateCell:[dataArr objectAtIndex:indexPath.row]];
                   
                   return cell;
               }
               break;
            
        case JHResaleLiveRoomTabTypeMyPrice:
            {
                JHMyPriceTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kResaleLiveRoomTabMyPriceIdentifier];
                if(!cell)
                {
                    cell = [[JHMyPriceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kResaleLiveRoomTabMyPriceIdentifier];
                    [cell setCellThemeType:JHCellThemeTypeClearColor];
                    cell.delegate = self.delegate;
                }
                
                [cell updateCell:[dataArr objectAtIndex:indexPath.row]];
                
                return cell;
            }
            break;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat themeClearColorOffset = 10.0;   //主题透明时,不要间距10
    CGFloat themeClearColorFixOffset = 0.0;//高度缩小{22~37}
    if(pageType == JHResaleLiveRoomTabTypeBuyPrice)
    {
        themeClearColorFixOffset = 25.0;
        if(indexPath.row < [dataArr count])
        {
            //根据出价用户个数增加高度，每个用户出价高度为(40+10)
            JHBuyerPriceModel* model = dataArr[indexPath.row];
            NSUInteger n = model.customerOfferList.count > 0 ? (model.customerOfferList.count - 1) : 0;
            return kBuyPriceTableCellHeight - themeClearColorOffset - themeClearColorFixOffset + n * kBuyerPriceViewHeight;
        }
        else
            return kBuyPriceTableCellHeight - themeClearColorOffset - themeClearColorFixOffset;
    }
    else if(pageType == JHResaleLiveRoomTabTypeMyPrice)
    {
        themeClearColorFixOffset = 22.0;
        CGFloat offset = kMyPriceTableCellRetainTimeHeight;
        if(indexPath.row < [dataArr count])
        {
            JHMyPriceListModel* model = dataArr[indexPath.row];
            if(model.offerDetail.offerState == 2)
                offset = 0.0;
        }

        return kMyPriceTableCellHeight - themeClearColorOffset - themeClearColorFixOffset - offset;
    }
    else if (pageType == JHResaleLiveRoomTabTypeStoneResale)
    {
        JHGoodResaleListModel* model = dataArr[indexPath.row];
        NSUInteger n = model.offerRecordList.count;
        return kStoneResaleTableCellHeight + n * kStoneResaleDetailCellHeight + 15;
    }
    else
    {
        return kRRSaleTableCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* stoneId = @"";
    switch (pageType)
    {
        case JHResaleLiveRoomTabTypeStoneResale:
        {
            [JHGrowingIO trackEventId:JHTrackStoneRestoreClick_offer variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];//click
        }
        case JHResaleLiveRoomTabTypeOnSale:
        default:
        {
            JHGoodResaleListModel* model = [dataArr objectAtIndex:indexPath.row];
            stoneId = model.stoneRestoreId;
        }
            break;
            
        case JHResaleLiveRoomTabTypeBuyPrice:
        {
            JHBuyerPriceModel* model = [dataArr objectAtIndex:indexPath.row];
            stoneId = model.stoneRestoreId;
        }
               break;
            
        case JHResaleLiveRoomTabTypeMyPrice:
        {
            JHMyPriceListModel* model = [dataArr objectAtIndex:indexPath.row];
            stoneId = model.stoneRestoreId;
        }
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNeedShowliveSmallViewNotification object:nil];
    [JHRouterManager pushStoneDetailWithStoneId:stoneId complete:nil];
}

@end
