//
//  JHCustomerFeeEditController.m
//  TTjianbao
//
//  Created by wangjianios on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerFeeEditController.h"
#import "JHCustomerFeeEditToolView.h"
#import "JHCustomerFeeEditCell.h"
#import "UIScrollView+JHEmpty.h"
#import "SVProgressHUD.h"

@interface JHCustomerFeeEditController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

///存放版块信息的数组
@property (nonatomic, strong) NSMutableArray <JHCustomerFeeEditModel *> *dataArray;

@end

@implementation JHCustomerFeeEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"编辑定制费用";
    self.view.backgroundColor = UIColor.whiteColor;

    [self initRightButtonWithName:@"保存" action:@selector(rightActionButton:)];
    [self jhNavBottomLine];
    [self loadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [JHCustomerFeeEditCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHCustomerFeeEditCell *cell = [JHCustomerFeeEditCell dequeueReusableCellWithTableView:tableView];
    if(indexPath.row < self.dataArray.count)
    {
        @weakify(self);
        cell.model = self.dataArray[indexPath.row];
        cell.resetBlock = ^{
            @strongify(self);
            [self updateRequestWithIndex:indexPath.row minPrice:nil maxPrice:nil];
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.dataArray.count)
    {
        @weakify(self);
        JHCustomerFeeEditToolView *toolView = [[JHCustomerFeeEditToolView alloc] initWithFrame:self.view.bounds];
        toolView.model = self.dataArray[indexPath.row];
        toolView.callBalckBlock = ^(NSString * _Nonnull minPrice, NSString * _Nonnull maxPrice) {
            @strongify(self);
            [self.tableView reloadData];
            [self updateRequestWithIndex:indexPath.row minPrice:minPrice maxPrice:maxPrice];
        };
        [self.view addSubview:toolView];
    }
}

-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLine target:self addToSuperView:self.view];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorColor = APP_BACKGROUND_COLOR;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 65, 0, 0);
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)loadData
{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/anon/customize/fee/detail") Parameters:@{@"channelId" : self.channelLocalId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        self.dataArray = [JHCustomerFeeEditModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        [self.tableView reloadData];
        NSLog(@"%@",respondObject.data);
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        JHTOAST(respondObject.message);
    }];
}

////app/customize/fee/update
- (void)updateRequestWithIndex:(NSInteger)index minPrice:(NSString *)minPrice maxPrice:(NSString *)maxPrice
{
    JHCustomerFeeEditModel *m = self.dataArray[index];
    if(minPrice)
    {
        m.minPrice = minPrice.intValue;
        m.maxPrice = maxPrice.intValue;
    }
    else
    {
        m.minPrice = 0;
        m.maxPrice = 0;
    }
    [self.view endEditing:YES];
    [self.tableView reloadData];
}

- (void)rightActionButton:(UIButton *)sender
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSMutableArray *array = [NSMutableArray new];
    for (JHCustomerFeeEditModel *m in self.dataArray) {
        [array addObject:m.mj_keyValues];
    }
    [param setValue:array forKey:@"items"];
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/customize/fee/update") Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        
        if(self.callbackMethod)
        {
            self.callbackMethod();
        }
        [self.navigationController popViewControllerAnimated:YES];
        JHTOAST(@"修改成功");
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        JHTOAST(respondObject.message);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
