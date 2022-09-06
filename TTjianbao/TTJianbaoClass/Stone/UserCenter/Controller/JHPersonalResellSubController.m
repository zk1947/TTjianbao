//
//  JHPersonalResellSubController.m
//  TTjianbao
//
//  Created by jesee on 20/5/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPersonalResellSubController.h"
#import "JHPersonalResellTableViewCell.h"
#import "JHStoneSendGoodsViewController.h"
#import "JHOrderDetailViewController.h"

@interface JHPersonalResellSubController () <JHTableViewCellDelegate>
{
    JHPersonalResellSubPageType pageType;
    NSUInteger pageIndex;
    NSMutableArray* dataArr;
    NSString* total;
}

@property (nonatomic, strong) JHPersonalResellDataModel* resellData;
@property (nonatomic, strong) NSMutableArray* dataArr;
@property (nonatomic, copy) NSString* lastStoneId;
@end

@implementation JHPersonalResellSubController
@synthesize dataArr;

- (void)dealloc{
    NSLog(@"%@*************被释放",[self class])
}
- (instancetype)initWithPageType:(JHPersonalResellSubPageType)type
{
    if(self = [super init])
    {
        pageType = type;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    //优先请求data
    [self loadNew];
    //绘制
    [self.view addSubview:self.jhTableView];
    [self.jhTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //加载更多
    [self addLoadMoreView];
    //下拉刷新
    [self addRefreshView];
}

//无数据界面
- (void)mayShowEmptyPage
{
    if([dataArr count] > 0)
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
    //刷新tab后面的total
    [self refreshTabTotal];
}
//刷新tab后面的total
- (void)refreshTabTotal
{
    if(self.customAction)
    {
        self.customAction(@(pageType),total);
    }
}

- (void)hideRefreshMoreWithData:(BOOL)hasData
{
    [self hideRefreshView];
    if(hasData)
        [self hideLoadMoreView];
    else
        [self hideLoadMoreWithNoData];
}

- (void)refreshPage
{
    [self loadNew];
}

- (JHPersonalResellDataModel *)resellData
{
    if(!_resellData)
    {
        _resellData = [JHPersonalResellDataModel new];
    }
    return _resellData;
}

#pragma mark - request
- (void)loadNew
{
    [SVProgressHUD show];
    pageIndex = 0;
    self.lastStoneId = @"";
    [self requestData:pageIndex];
}

- (void)loadMore
{
    if([dataArr count] == 0)
    {
        dataArr = [NSMutableArray array];
        [self loadNew];
    }
    else
        [self requestData:++pageIndex];
}
//JHResaleLiveRoomTabDataDelegate
- (void)requestData:(NSUInteger)pageIndex
{
    JH_WEAK(self)
    [self.resellData asynReqPersonalResellListPageType:pageType lastStoneId:self.lastStoneId response:^(JHPersonalResellModel* respData, NSString *errorMsg) {
        JH_STRONG(self)
        [SVProgressHUD dismiss];
        if(errorMsg)
        {
//            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        else
        {
            self->total = respData.total;
            if(pageIndex > 0)
                [self.dataArr addObjectsFromArray:respData.list];
            else
                self.dataArr = [NSMutableArray arrayWithArray:respData.list];
            [self.jhTableView reloadData];
            JHPersonalResellListModel* lastModel = [self.dataArr lastObject];
            self.lastStoneId = lastModel.stoneResaleId ? : @"";
        }

        [self mayShowEmptyPage];
    }];
}

#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHPersonalResellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHPersonalResellTableViewCell class])];
    if(!cell)
    {
        cell = [[JHPersonalResellTableViewCell alloc] initWithPageStyle:pageType reuseIdentifier:NSStringFromClass([JHPersonalResellTableViewCell class])];
        cell.mDelegate = self;
    }
    cell.indexPath = indexPath;
    
    [cell updateCell:dataArr[indexPath.row]];
    return cell;
}

#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    if(indexPath && index >= 0 && index < self.dataArr.count)
    {
        JHPersonalResellListModel* model = self.dataArr[index];
        [JHRouterManager pushPersonReSellDetailWithStoneResaleId:model.stoneResaleId];
    }
}

//从列表删除后,如果个数为0,则重新加载
- (void)reloadListAfterDeleteIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath
{
    //delete
    [self.dataArr removeObjectAtIndex:index];
    [self.jhTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //reload
    if([self.dataArr count] == 0)
    {
        [self loadNew];
    }
}

//编辑后返回刷新list-cell
- (void)reloadListAfterEditIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath withObject:(JHPersonalResellListModel*)model
{
    [self.dataArr replaceObjectAtIndex:index withObject:model];
    [self.jhTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
}

- (void)pressButtonType:(JHPersonalResellCellActiveType)type tableViewCell:(UITableViewCell*)cell
{
    __weak JHPersonalResellListModel* model = nil;
    __weak NSIndexPath* indexPath = [self.jhTableView indexPathForCell:cell];
    NSInteger index = indexPath.row;
    if(indexPath && index >= 0 && index < self.dataArr.count)
    {
        model = self.dataArr[index];
    }
    switch(type)
    {
        case JHPersonalResellCellActiveTypeDelete:
        {
            JH_WEAK(self)
            UIAlertController *alerts = [UIAlertController alertControllerWithTitle:@"是否确认删除此商品，删除后无法恢复？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alerts addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
            [alerts addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                JH_STRONG(self)
                [self.resellData asynReqPersonalResellDelete:model.stoneResaleId response:^(id respData, NSString *errorMsg) {
                    
                    if(errorMsg)
                    {
                        [SVProgressHUD showErrorWithStatus:errorMsg];
                    }
                    else
                    {
                        [self reloadListAfterDeleteIndex:index indexPath:indexPath];
                    }
                }];
            }]];
            [[JHRouterManager jh_getViewController] presentViewController:alerts animated:YES completion:nil];
        }
            break;
        
        case JHPersonalResellCellActiveTypeShelve:
        {
            [self.resellData asynReqPersonalResellShelve:model.stoneResaleId response:^(id respData, NSString *errorMsg) {
                if(errorMsg)
                {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }
                else
                {
                    [SVProgressHUD showSuccessWithStatus:@"上架成功"];
                    [self reloadListAfterDeleteIndex:index indexPath:indexPath];
                }
            }];
        }
            break;
        
        case JHPersonalResellCellActiveTypeUnshelve:
        {
            JH_WEAK(self)
            UIAlertController *alerts = [UIAlertController alertControllerWithTitle:@"是否确认下架此商品？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alerts addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
            [alerts addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                JH_STRONG(self)
                [self.resellData asynReqPersonalResellUnshelve:model.stoneResaleId response:^(id respData, NSString *errorMsg) {
                    if(errorMsg)
                    {
                        [SVProgressHUD showErrorWithStatus:errorMsg];
                    }
                    else
                    {
                        [self reloadListAfterDeleteIndex:index indexPath:indexPath];
                    }
                }];
            }]];
            [[JHRouterManager jh_getViewController] presentViewController:alerts animated:YES completion:nil];
        }
            break;
        
        case JHPersonalResellCellActiveTypeEdit:
        {
            JH_WEAK(self)
            [JHRouterManager pushPersonReSellPublishWithStoneResaleId:model.stoneResaleId editSuccessBlock:^{
                JH_STRONG(self)
                [self.resellData asynReqPersonalResellListItem:model.stoneResaleId response:^(JHPersonalResellListModel* itemModel, NSString *errorMsg) {
                    [self reloadListAfterEditIndex:index indexPath:indexPath withObject:itemModel];
                }];
            }];
        }
            break;
            
        case JHPersonalResellCellActiveTypeDetail:
        {
            JHOrderDetailViewController * order=[[JHOrderDetailViewController alloc]init];
            order.isSeller = YES;
            order.orderId = model.orderId;
            [[JHRouterManager jh_getViewController].navigationController pushViewController:order animated:YES];
        }
            break;
        
        case JHPersonalResellCellActiveTypeSend:
        {
            JHStoneSendGoodsViewController* stoneSend = [JHStoneSendGoodsViewController new];
            stoneSend.goodId = model.stoneResaleId;
            [[JHRouterManager jh_getViewController].navigationController pushViewController:stoneSend animated:YES];
            JH_WEAK(self)
            stoneSend.sendSuccessBlock = ^(id obj) {
                JH_STRONG(self)
                NSString *status = (NSString*)obj;
                model.orderStatus = status; //发货后返回订单状态
                [self reloadListAfterEditIndex:index indexPath:indexPath withObject:model];
            };
          }
            break;
        
        default:
            break;
    }
}

@end
