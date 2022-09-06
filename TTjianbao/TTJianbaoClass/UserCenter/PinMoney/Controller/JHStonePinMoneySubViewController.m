//
//  JHStonePinMoneySubViewController.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/2.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStonePinMoneySubViewController.h"
#import "JHStonePinMoneyTableViewCell.h"


@interface JHStonePinMoneySubViewController ()
{
    JHStonePinMoneySubPageType pageType;
    NSUInteger pageIndex;
    NSMutableArray* dataArr;
}

@end

@implementation JHStonePinMoneySubViewController

- (instancetype)initWithPageType:(JHStonePinMoneySubPageType)type
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
    //优先请求data
    [self loadNew];
    //绘制
    [self.view addSubview:self.jhTableView];
    self.jhTableView. backgroundColor = HEXCOLOR(0xf8f8f8);
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

#pragma mark - request
- (void)loadNew
{
    [SVProgressHUD show];
    pageIndex = 0;
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
    [kStonePinMoneyData requestAccountFlowWith:@"" type:@"" pageType:pageType pageIndex:pageIndex response:^(id respData, NSString *errorMsg) {
        JH_STRONG(self)
        [SVProgressHUD dismiss];
        if(errorMsg)
        {
//            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        else
        {
            if(pageIndex > 0)
                [dataArr addObjectsFromArray:respData];
            else
                dataArr = [NSMutableArray arrayWithArray:respData];

            [self.jhTableView reloadData];
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
    JHStonePinMoneyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JHStonePinMoneyTableViewCellIdentifier"];
    if(!cell)
    {
        cell = [[JHStonePinMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHStonePinMoneyTableViewCellIdentifier"];
    }
    
   // [cell updateData:dataArr[indexPath.row]];
    [cell setModel:dataArr[indexPath.row]];
    [cell setCellIndex:indexPath.row];
    
    @weakify(self);
//    cell.buttonBlock = ^(id obj, id data) {
//    @strongify(self);
//
//    };
    cell.buttonBlock = ^(NSInteger cellIndex, BOOL multiLine) {
        
        @strongify(self);
        JHAccountFlowModel * mode = dataArr[cellIndex];
        mode.multiLine = multiLine;
        [self.jhTableView reloadData];
        
    };
    
    return cell;
}

#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView. backgroundColor = HEXCOLOR(0xf8f8f8);
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView. backgroundColor = HEXCOLOR(0xf8f8f8);
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (void)dealloc{
    NSLog(@"%@*************被释放",[self class])
}

@end
