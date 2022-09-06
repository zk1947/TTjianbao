//
//  JHMyCenterImageAppraiserView.m
//  TTjianbao
//
//  Created by liuhai on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCenterImageAppraiserView.h"
#import "JHMyCenterAppraiserViewModel.h"
#import "JHMyCenterAppraiserViewCell.h"
#import "JHMyCenterUserHeaderView.h"
#import "JHMyCenterButtonModel.h"
#import "JHMyCenterImageAppraiserCell.h"
#import "JHImageAppraisalRecordViewController.h"
#import "JHImageTextWaitAuthListViewController.h"
#import "JHMyCenterImageAppraiserNumCell.h"

@interface JHMyCenterImageAppraiserView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) JHMyCenterUserHeaderView *headerView;

@property (nonatomic, weak) UITableView* tableView;


@end

@implementation JHMyCenterImageAppraiserView

-(void)dealloc{
    NSLog(@"🔥dealloc－－－－%@",self.class);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(245, 246, 250);
        [self headerView];
        [self.tableView reloadData];
    }
    return self;
}

-(void)reload{
    [self.headerView reload];
    [self.tableView reloadData];
}
#pragma mark --------------- tableview ---------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    

    if (indexPath.row == 0) {
        
        JHMyCenterImageAppraiserCell *cell = [JHMyCenterImageAppraiserCell dequeueReusableCellWithTableView:tableView];
        JHMyCenterButtonModel *model = [JHMyCenterButtonModel creatWithIcon:@"my_center_appraiser_4" name:@"开启接单" type:JHMyCenterButtonTypeGetAppraisal];
        cell.model = model;
        return cell ;
    }
    
    if (indexPath.row == 1) {
        JHMyCenterImageAppraiserNumCell *cell = [JHMyCenterImageAppraiserNumCell dequeueReusableCellWithTableView:tableView];
        JHMyCenterButtonModel *model = [JHMyCenterButtonModel creatWithIcon:@"my_center_appraiser_2" name:@"待鉴定" type:JHMyCenterButtonTypeOrderAppraisal];
        cell.model = model;
        return  cell;
    }
    if (indexPath.row == 2) {
        JHMyCenterAppraiserViewCell *cell = [JHMyCenterAppraiserViewCell dequeueReusableCellWithTableView:tableView];
        JHMyCenterButtonModel *model = [JHMyCenterButtonModel creatWithIcon:@"my_center_appraiser_3" name:@"鉴定记录" type:JHMyCenterButtonTypeAppraisalRecord];
        cell.model = model;
        return  cell;
    }
    return  [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 1) {
        //待鉴定
        JHImageTextWaitAuthListViewController * vc = [[JHImageTextWaitAuthListViewController alloc] init];
        [JHRootController.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 2){
//        鉴定记录
        JHImageAppraisalRecordViewController * vc = [[JHImageAppraisalRecordViewController alloc] init];
        [JHRootController.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ---------------------------- get set ----------------------------
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLine target:self addToSuperView:self];
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.rowHeight = 50.f;
        _tableView.separatorColor = RGB(238, 238, 238);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        [_tableView jh_cornerRadius:8];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self.headerView.mas_bottom).offset(-[JHMyCenterUserHeaderView viewBottom]);
            make.height.mas_equalTo(150);
        }];
    }
    return _tableView;
}


- (JHMyCenterUserHeaderView *)headerView{
    if(!_headerView){
        _headerView = [JHMyCenterUserHeaderView new];
        [self addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo([JHMyCenterUserHeaderView viewHeight]);
        }];
    }
    return _headerView;
}

@end
