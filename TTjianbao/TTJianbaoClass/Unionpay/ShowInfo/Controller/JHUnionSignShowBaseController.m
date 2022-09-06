//
//  JHUnionSignShowBaseController.m
//  TTjianbao
//
//  Created by apple on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUnionSignShowBaseController.h"
#import "JHUnionSignShowShopInfoController.h"
#import "JHUnionSignShowAccountInfoController.h"
#import "JHUnionSignShowRealNameController.h"
@interface JHUnionSignShowBaseController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JHUnionSignShowBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([NSArray has:self.dataArray[section]]) {
        NSArray *arr = self.dataArray[section];
        return arr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [JHUnionSignShowBaseCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    view.backgroundColor = UIColor.clearColor;
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, CGFLOAT_MIN)];
    view.backgroundColor = UIColor.clearColor;
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHUnionSignShowBaseCell *cell = [JHUnionSignShowBaseCell dequeueReusableCellWithTableView:tableView];
    JHUnionSignShowBaseModel *model = self.dataArray[indexPath.section][indexPath.row];
    [cell setTitle:model.title desc:model.desc hiddenPushIcon:model.hiddenPushIcon];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHUnionSignShowBaseModel *model = self.dataArray[indexPath.section][indexPath.row];
    
    switch (model.type) {
        case JHUnionSignShowTypeRealName:
        {
            JHUnionSignShowRealNameController *vc = [JHUnionSignShowRealNameController new];
            vc.model = self.model;
            vc.title = @"实名认证";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
            case JHUnionSignShowTypeShopInfo:
            {
                JHUnionSignShowShopInfoController *vc = [JHUnionSignShowShopInfoController new];
                vc.model = self.model;
                vc.title = @"营业信息";
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
            
            case JHUnionSignShowTypeAccountInfo:
            {
                JHUnionSignShowAccountInfoController *vc = [JHUnionSignShowAccountInfoController new];
                vc.model = self.model;
                vc.title = @"账户信息";
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
            
            case JHUnionSignShowTypeSignInfo:
            {
                [JHRouterManager pushWebViewWithUrl:self.model.requestInfoUrl title:@"电子签约" controller:self];
            }
            break;
            
        default:
            break;
    }
}

-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStyleGrouped separatorStyle:UITableViewCellSeparatorStyleSingleLine target:self addToSuperView:self.view];
        _tableView.separatorColor = RGB(238,238,238);
        _tableView.backgroundColor = APP_BACKGROUND_COLOR;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.jhNavView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray arrayWithCapacity:6];
    }
    return _dataArray;
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
