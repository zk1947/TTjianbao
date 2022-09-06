//
//  JHPurchaseStoneView.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHPurchaseStoneView.h"


#define kPurchaseTypeDefaultCellIdentifier    @"kPurchaseTypeDefaultCellIdentifier"
#define kPurchaseTypeCutCellIdentifer          @"kPurchaseTypeCutCellIdentifer"
#define kPurchaseTypeSplitCellIdentifier        @"kPurchaseTypeSplitCellIdentifier"

@interface JHPurchaseStoneView () <UITableViewDelegate, UITableViewDataSource, JHTableViewCellDelegate>
{
    JHPurchaseType purcharseType;
    NSMutableArray* dataArr;
    JHStonePageType pageType;
}

@end

@implementation JHPurchaseStoneView

- (void)updateData:(NSArray*)array pageType:(JHStonePageType)type
{
    pageType = type;
    dataArr = [NSMutableArray arrayWithArray:array];
    
    [self.pTableView reloadData];
}

- (void)setupView
{
    [self addSubview:self.pTableView];
    [self.pTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.pTableView addRefreshView];
    [self.pTableView addLoadMoreView];
}

- (UITableView*)pTableView
{
    if(!_pTableView)
    {
        _pTableView = [[JHTableViewExt alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _pTableView.backgroundColor = [UIColor clearColor];//HEXCOLOR(0xf8f8f8);
        _pTableView.delegate = self;
        _pTableView.dataSource = self;
        _pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pTableView.showsHorizontalScrollIndicator = NO;
    }
    
    return _pTableView;
}

#pragma mark - load data
- (void)loadNew
{
    if([self.delegate respondsToSelector:@selector(reloadNewData:)])
        [self.delegate reloadNewData:YES];
}

- (void)loadMore
{
    if([self.delegate respondsToSelector:@selector(reloadNewData:)])
        [self.delegate reloadNewData:NO];
}

- (void)hideRefreshMoreWithData:(BOOL)hasData
{
    [self.pTableView hideRefreshView];
    if(hasData)
        [self.pTableView hideLoadMoreView];
    else
        [self.pTableView hideLoadMoreWithNoData];
}

#pragma mark - table datasource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    JHPurchaseStoneListModel* model = [dataArr objectAtIndex:indexPath.row];
    purcharseType = (JHPurchaseType)[JHPurchaseStoneModel PurchaseTypeFromState:model.transitionState];
    switch (purcharseType)
    {
        case JHPurchaseTypeDefault:
        default:
            {
                JHPurchaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kPurchaseTypeDefaultCellIdentifier];
                if(!cell)
                {
                    cell = [[JHPurchaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPurchaseTypeDefaultCellIdentifier];
                    cell.delegate = self;
                    [cell setupSubviews:pageType];
                }
                
                [cell setCellData:model pageType:pageType];
                return cell;
            }
            break;
            
        case JHPurchaseTypeCut:
            {
                JHPurchaseCutTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kPurchaseTypeCutCellIdentifer];
                if(!cell)
                {
                    cell = [[JHPurchaseCutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPurchaseTypeCutCellIdentifer];
                    cell.delegate = self;
                    [cell setupSubviews:pageType];//super draw
                }
                
                [cell updateCell:model pageType:pageType];
                return cell;
            }
            break;
        
        case JHPurchaseTypeSplit:
            {
                JHPurchaseSplitTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kPurchaseTypeSplitCellIdentifier];
                if(!cell)
                {
                    cell = [[JHPurchaseSplitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPurchaseTypeSplitCellIdentifier];
                    cell.delegate = self;
                    [cell setupSubviews:pageType];//super draw
                }
                
                [cell updateCell:model pageType:pageType];
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
    if(purcharseType == JHPurchaseTypeCut)
        return kPurchaseTableCutCellHeight;
    else if(purcharseType == JHPurchaseTypeSplit)
    {
        JHPurchaseStoneListModel* model = dataArr[indexPath.row];
        NSUInteger count = [model.children count]; //N个子单children,每个子单下有n个vattachment
        CGFloat height = kPurchaseTableSplitCellHeight + (count > 0 ? kPurchaseTableSplitCellOffsetHeight : 0);
        for (int i = 0; i < count; i++)
        {
            JHPurchaseStoneListModel* childrenModel = model.children[i];
            height += kPurchaseTableSplitOneCellHeight; //包含了image高度
            if([childrenModel.attachmentList count] <= 0)
                height -= kPurchaseTableSplitOneCellImageHeight; //如果没有image,减去image高度
        }
        return height;
    }
    else
        return kPurchaseTableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >= 0 && indexPath.row < dataArr.count)
    {
        JHPurchaseStoneListModel* model = [dataArr objectAtIndex:indexPath.row];
        //model.orderId 进入订单详情
        if([self.delegate respondsToSelector:@selector(gotoOrderDetailPage:)])
        {
            [self.delegate gotoOrderDetailPage:model];
        }
    }
}

#pragma mark - delegate
- (void)pressButtonType:(RequestType)type tableViewCell:(UITableViewCell*_Nullable)cell
{
    NSIndexPath* indexPath = [self.pTableView indexPathForCell:cell];
    NSInteger index = indexPath.row;
    if(indexPath && index >= 0 && index < dataArr.count)
    {
        JHPurchaseStoneListModel* model = [dataArr objectAtIndex:indexPath.row];
        //model.orderId 进入订单详情
        if([self.delegate respondsToSelector:@selector(gotoStoneResellPage:)])
        {
            [self.delegate gotoStoneResellPage:model];
        }
    }
}

@end
