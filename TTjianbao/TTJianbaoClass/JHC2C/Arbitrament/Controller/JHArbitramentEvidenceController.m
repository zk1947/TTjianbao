//
//  JHArbitramentEvidenceController.m
//  TTjianbao
//
//  Created by lihui on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHArbitramentEvidenceController.h"
#import "JHArbitramentListCell.h"
#import "JHArbitramentReportCell.h"
#import "JHArbitramentDescriptionCell.h"

@interface JHArbitramentEvidenceController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JHArbitramentEvidenceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交凭证";
    [self configTable];
}

- (void)configTable {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, ScreenH - UI.statusAndNavBarHeight) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kColorF5F5F8;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ///商品报告
        JHArbitramentReportCell *cell = [JHArbitramentReportCell dequeueReusableCellWithTableView:tableView];
        return cell;
    }
    if (indexPath.section == 2) {
        ///补充描述和凭证
        JHArbitramentDescriptionCell *cell = [JHArbitramentDescriptionCell dequeueReusableCellWithTableView:tableView];
        return cell;
    }

    JHArbitramentListCell *cell = [JHArbitramentListCell dequeueReusableCellWithTableView:tableView];
    cell.title = @"货物状态";
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.f;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ///商品报告
        return [JHArbitramentReportCell cellHeight];
    }
    if (indexPath.section == 2) {
        ///补充描述和凭证
        return [JHArbitramentDescriptionCell cellHeight];
    }

    return [JHArbitramentListCell cellHeight];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
