//
//  JHSeckillListViewController.m
//  TTjianbao
//
//  Created by jiang on 2020/3/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSeckillListViewController.h"
#import "JHSeckillTableViewCell.h"
#import "JHGoodsDetailViewController.h"

#import "JHSecKillReqMode.h"
@interface JHSeckillListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray <JHGoodsInfoMode*>*dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger roleType;

@end

@implementation JHSeckillListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [self setupViews];
}

-(void)loadNewData{
    
    self.pageSize=1;
    [self requestInfo];
    
}
-(void)loadMoreData{
    
    self.pageSize++;
    [self requestInfo];
}

-(void)requestInfo{
    
    JHSecKillReqMode* mode=[JHSecKillReqMode new];
    mode.sec_id=self.ses_id;
    mode.page=self.pageSize;
    
    [JHStoreApiManager getSeckillList:mode completion:^(RequestModel *respondObject, NSError *error) {
        [self endRefresh];
        if (!error) {
            [self handleDataWithArr:respondObject.data[@"goods_list"]];
        }
    }];
}
- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr = [JHGoodsInfoMode mj_objectArrayWithKeyValuesArray:array];
    if (self.pageSize == 1) {
        self.dataArray = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.dataArray addObjectsFromArray:arr];
    }
    [self.tableView reloadData];
    if ([arr count]==0) {

        self.tableView.mj_footer.hidden=YES;
    }
    else{
        self.tableView.mj_footer.hidden=NO;
    }
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupViews {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - GET

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        _tableView.contentInset=UIEdgeInsetsMake(0, 0,-UI.bottomSafeAreaHeight, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 155;
        JH_WEAK(self)
        _tableView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            JH_STRONG(self)
            [self loadMoreData];
        }];
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            JH_STRONG(self)
            [self loadNewData];
        }];
        _tableView.mj_footer.hidden=YES;
    }
    return _tableView;
}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

   static NSString *CellIdentifier=@"cellIdentifier";
    JHSeckillTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[JHSeckillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
         JH_WEAK(self)
        cell.buttonClick = ^(id obj) {
          JH_STRONG(self)
             JHSeckillTableViewCell *cell=(JHSeckillTableViewCell*)obj;
             [self buttonPrsss:self.dataArray[cell.cellIndex]];
        };
        
    }
        cell.cellIndex=indexPath.row;
        cell.dataCount=self.dataArray.count;
        [cell setGoodMode:self.dataArray[indexPath.row]];
        cell.titleMode=self.titleMode;
       
    
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 155;
    return  UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view=[UIView new];
    view.backgroundColor=[UIColor whiteColor];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHGoodsDetailViewController *vc = [JHGoodsDetailViewController new];
    JHGoodsInfoMode *data = self.dataArray[indexPath.row];
    vc.goods_id = data.goods_id;
    vc.ses_id = self.ses_id;
    vc.entry_type = JHFromStoreFollowSaleFlashList;  ///秒杀列表
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    
}
-(void)buttonPrsss:(JHGoodsInfoMode*)goodMode{
    
    if (goodMode.sk_status==3) {
        if ([self isLgoin]) {
            [JHStoreApiManager goodRemind:self.ses_id GoodId:goodMode.goods_id completion:^(RequestModel *respondObject, NSError *error) {
                if (!error) {
                    [self loadNewData];
                }
                else{
                    [self.view makeToast:error.localizedDescription duration:1 position:CSToastPositionCenter];
                }
            }];
        }
       
    }
    if (goodMode.sk_status==4) {
        if ([self isLgoin]) {
            [JHStoreApiManager goodCancelRemind:self.ses_id GoodId:goodMode.goods_id completion:^(RequestModel *respondObject, NSError *error) {
                if (!error) {
                    [self loadNewData];
                }
                else{
                    [self.view makeToast:error.localizedDescription duration:1 position:CSToastPositionCenter];
                }
            }];
        }
    }
    
    if (goodMode.sk_status==1) {
        JHGoodsDetailViewController *vc = [JHGoodsDetailViewController new];
        vc.goods_id = goodMode.goods_id;
        vc.ses_id=self.ses_id;
        vc.entry_type = JHFromStoreFollowSaleFlashListFastBuy;  ///秒杀列表
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
       
    }
}
-(BOOL)isLgoin
{
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {}];
        return  NO;
    }
    return  YES;
}
@end
