//
//  JHMainLiveRoomTabSubviewController.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMainLiveRoomTabSubviewController.h"
#import "JHLastSaleTableViewCell.h"
#import "JHMROnSaleTableViewCell.h"
#import "JHOffSaleTableViewCell.h"
#import "JHStonePopViewHeader.h"
#import "JHAnchorBreakPaperViewController.h"
#import "JHSendOrderProccessGoodServiceView.h"
#import "JHMainLiveRoomExplainModel.h"
#import "ChannelMode.h"

#import "JHPutShelveModel.h"

#define kMLRTabLastSaleIdentifier     @"kMLRTabLastSaleIdentifier"
#define kMLRTabWillSaleIdentifier      @"kMLRTabWillSaleIdentifier"
#define kMLRTabToSeeIdentifier        @"kMLRTabToSeeIdentifier"
#define kMLRTabOffSaleIdentifier       @"kMLRTabOffSaleIdentifier"

@interface JHMainLiveRoomTabSubviewController () <JHMainLiveRoomTabDataDelegate, JHTableViewCellDelegate>
{
    JHMainLiveRoomTabType pageType;
    NSUInteger pageIndex;
    NSString* channelId;
    NSString* keyword;
}

@property (nonatomic, strong) JHMainLiveRoomTabDataModel* dataModel;
@end

@implementation JHMainLiveRoomTabSubviewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithPageType:(JHMainLiveRoomTabType)type channelId:(NSString*)mChannelId
{
    if(self = [super init])
    {
        pageType = type;
        channelId = mChannelId;
        keyword = @"";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWillSaleTable:) name:JHNotificationShelveStatusChange object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //优先请求data
    [self loadNew];
    //页面绘制
    self.view.backgroundColor = HEXCOLOR(0xf8f8f8);
    [self.view addSubview:self.jhTableView];
    [self.jhTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //加载更多
    [self addLoadMoreView];
    if(JHMainLiveRoomTabTypeResaleStone == pageType || JHMainLiveRoomTabTypeResaleStoneTab== pageType || JHMainLiveRoomTabTypeWillSaleFromUserCenter == pageType)
        [self addRefreshView];
}

- (void)hideRefreshMoreWithData:(BOOL)hasData
{
    if(JHMainLiveRoomTabTypeResaleStone == pageType || JHMainLiveRoomTabTypeResaleStoneTab == pageType ||JHMainLiveRoomTabTypeWillSaleFromUserCenter == pageType)
        [self hideRefreshView];
    if(hasData)
        [self hideLoadMoreView];
    else
        [self hideLoadMoreWithNoData];
}

//无数据界面
- (void)mayShowEmptyPage
{
    if([_dataModel.dataArray count] > 0)
    {
        [self hiddenDefaultImage];
        //关掉加载更多view
        [self hideRefreshMoreWithData:YES];
    }
    else
    {
        [self showDefaultImageWithView:self.jhTableView];
        //关掉加载更多view
        [self hideRefreshMoreWithData:NO];
    }
}

- (void)callbackRefreshData
{
    [self loadNew];
}

- (void)refreshWillSaleTable:(NSNotification*)notify
{
    if(pageType == JHMainLiveRoomTabTypeWillSale || pageType == JHMainLiveRoomTabTypeWillSaleFromUserCenter)
    {
        JHPutShelveModel *model =(JHPutShelveModel*)notify.object;
        [_dataModel queryWillSaleOnshelfState:pageType stoneId:model.stoneRestoreId];
        [self.jhTableView reloadData];
    }
}

//点击按钮后刷新list-cell
- (void)reloadListAfterClickIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath withObject:(JHUCOnSaleListModel*)model
{
    [_dataModel.dataArray replaceObjectAtIndex:index withObject:model];
    [self.jhTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - data request
- (JHMainLiveRoomTabDataModel*)dataModel
{
    if(!_dataModel)
    {
        _dataModel = [JHMainLiveRoomTabDataModel new];
        _dataModel.delegate = self;
    }
    return _dataModel;
}

- (void)loadNew
{
    [SVProgressHUD show];
    pageIndex = 0;
    [self.dataModel requestByPage:pageType channelId:channelId pageIndex:pageIndex keyword:keyword];
}

- (void)loadMore
{
    [self.dataModel requestByPage:pageType channelId:channelId pageIndex:++pageIndex keyword:keyword];
}

- (void)refreshPageBySearch:(NSString*)text
{
    keyword = text;
    [self loadNew];
}

#pragma mark - JHMainLiveRoomTabDataDelegate
- (void)responsePage:(JHMainLiveRoomTabType)type error:(NSString*)errorMsg
{
    [SVProgressHUD dismiss];
     if(errorMsg)
    {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }
    else
    {
       [self.jhTableView reloadData];
    }

    [self mayShowEmptyPage];
}

#pragma mark - table datasource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    switch (pageType)
    {
        case JHMainLiveRoomTabTypeLastSale:
        default:
            {
                JHLastSaleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kMLRTabLastSaleIdentifier];
                if(!cell)
                {
                    cell = [[JHLastSaleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMLRTabLastSaleIdentifier];
                    cell.delegate = self;
                    [cell setupSubviewsByType:JHLastSaleCellTypeDefault];
                }
                
                [cell updateCell:[_dataModel.dataArray objectAtIndex:indexPath.row]];
                
                return cell;
            }
            break;
            
        case JHMainLiveRoomTabTypeWillSale:
        case JHMainLiveRoomTabTypeWillSaleFromUserCenter:
            {
                JHLastSaleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kMLRTabWillSaleIdentifier];
                if(!cell)
                {
                    cell = [[JHLastSaleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMLRTabWillSaleIdentifier];
                    cell.delegate = self;
                    if(pageType == JHMainLiveRoomTabTypeWillSaleFromUserCenter)
                        [cell setupSubviewsByType:JHLastSaleCellTypeWillSaleFromUserCenter];
                    else
                        [cell setupSubviewsByType:JHLastSaleCellTypeWillSale];
                }
                
                [cell updateCell:[_dataModel.dataArray objectAtIndex:indexPath.row]];
                
                return cell;
            }
            break;
            
        case JHMainLiveRoomTabTypeToSee:
        case JHMainLiveRoomTabTypeResaleStone:
        case JHMainLiveRoomTabTypeResaleStoneTab:
           {
               JHMROnSaleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kMLRTabToSeeIdentifier];
               if(!cell)
               {
                   cell = [[JHMROnSaleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMLRTabToSeeIdentifier];
                   if(pageType == JHMainLiveRoomTabTypeToSee)
                       [cell setupSubviewsByType:JHMROnSaleCellTypeToSee];
                   else if(pageType == JHMainLiveRoomTabTypeResaleStoneTab)
                       [cell setupSubviewsByType:JHMROnSaleCellTypeSaleTab];
                   else
                       [cell setupSubviewsByType:JHMROnSaleCellTypeDefault];
               }
               cell.delegate = self;
               [cell updateCell:[_dataModel.dataArray objectAtIndex:indexPath.row]];
               
               return cell;
           }
           break;
            
        case JHMainLiveRoomTabTypeOffSale:
            {
                JHOffSaleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kMLRTabOffSaleIdentifier];
                if(!cell)
                {
                    cell = [[JHOffSaleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMLRTabOffSaleIdentifier];
                }
                
                [cell updateCell:[_dataModel.dataArray objectAtIndex:indexPath.row]];

                return cell;
            }
            break;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [_dataModel.dataArray count];
    return count;
}

#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(pageType == JHMainLiveRoomTabTypeOffSale)
        return 110+kCellMargin; //宝友下架
    else if(pageType == JHMainLiveRoomTabTypeResaleStoneTab || pageType == JHMainLiveRoomTabTypeResaleStone)
    {
//        JHUCOnSaleListModel* model = [_dataModel.dataArray objectAtIndex:indexPath.row];
//        NSInteger count = [model.seekCustomerImgList count];
//        if(count == 0)
//            return 110+kCellMargin+30;//隐藏求看头像一行
        //编辑+开始讲解 = 30 + 10：因此这一行全部显示
        return 150+kCellMargin;
    }
    else
    {
        CGFloat offset = 0.0;
        if(JHMainLiveRoomTabTypeLastSale == pageType)
        {
            if(indexPath.row < [_dataModel.dataArray count])
            {
                JHLastSaleGoodsModel* model = [_dataModel.dataArray objectAtIndex:indexPath.row];
                if(model.sendButton == 0 && model.saleButton == 0 && model.processButton == 0 && model.splitButton == 0)
                {
                    offset = kLastSaleCellButtonHeight;//四个按钮都不显示时,高度缩减
                }
            }
        }
        return 150+kCellMargin-offset;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* stoneId = nil;
    switch (pageType)
    {
        case JHMainLiveRoomTabTypeWillSale:
            /*不允许跳转详情页,待上架商品不该有详情页*/
            break;
        case JHMainLiveRoomTabTypeLastSale:
        case JHMainLiveRoomTabTypeWillSaleFromUserCenter:
        default:
            {
                JHLastSaleGoodsModel* model = [_dataModel.dataArray objectAtIndex:indexPath.row];
                stoneId = model.stoneRestoreId ? : model.stoneId;
            }
            break;
            
        case JHMainLiveRoomTabTypeToSee:
        case JHMainLiveRoomTabTypeResaleStone:
        case JHMainLiveRoomTabTypeResaleStoneTab:
           {
               JHUCOnSaleListModel* model = [_dataModel.dataArray objectAtIndex:indexPath.row];
               stoneId = model.stoneRestoreId ? : model.stoneId;
           }
           break;
            
        case JHMainLiveRoomTabTypeOffSale:
            {
                JHOffSaleGoodsModel* model = [_dataModel.dataArray objectAtIndex:indexPath.row];
                stoneId = model.stoneRestoreId;
            }
            break;
    }
    if(stoneId)
    {
        JH_WEAK(self)
        [JHRouterManager pushStoneDetailWithStoneId:stoneId complete:^(id  _Nonnull data) {
            JH_STRONG(self)
            if(self->pageType == JHMainLiveRoomTabTypeToSee)
            {//暂时注释,不刷新
//                BOOL isExplained = [data boolValue];
//                if(isExplained)
//                {
//                    [self callbackRefreshData];
//                }
            }
        }];
    }
}

#pragma mark - events ~ JHTableViewCellDelegate
- (void)pressButtonType:(RequestType)type dataModel:(JHLastSaleGoodsModel*)model indexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressButtonType:dataModel:indexPath:)]) {
        [self.delegate pressButtonType:type dataModel:model indexPath:indexPath];
    }
}

- (void)pressButtonType:(RequestType)type tableViewCell:(UITableViewCell*)cell
{
    __weak JHUCOnSaleListModel* model = nil;
    __weak NSIndexPath* indexPath = [self.jhTableView indexPathForCell:cell];
    NSInteger index = indexPath.row;
    if(indexPath && index >= 0 && index < _dataModel.dataArray.count)
    {
        model = _dataModel.dataArray[index];
        if(type == RequestTypeExplain)
        {
            JHMainLiveRoomExplainModel *explain = [[JHMainLiveRoomExplainModel alloc] init];
            explain.stoneRestoreId = model.stoneRestoreId;
            //讲解操作，0开始讲解，1停止讲解
            explain.explainingFlag = model.explainingFlag;
            JH_WEAK(self)
            [explain asynRequestWithResponse:^(id respData, NSString *errorMsg) {
                JH_STRONG(self)
                if(errorMsg)
                {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }
                else
                {
                    model.explainingFlag = !model.explainingFlag;
                    model.buttonTxt = model.explainingFlag ? @"停止讲解" : @"开始讲解";
                    [self reloadListAfterClickIndex:index indexPath:indexPath withObject:model];
                }
            }];
        }
    }
}

@end
