//
//  JHPlateAboutViewController.m
//  TTjianbao
//
//  Created by apple on 2020/9/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlateAboutViewController.h"
#import "UIScrollView+JHEmpty.h"
#import "JHPalteAboutTableViewCell.h"
#import "JHPlateDetailModel.h"
#import "JHSQManager.h"

@interface JHPlateAboutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) JHPlateDetailModel *model;

@end

@implementation JHPlateAboutViewController
- (instancetype)initWithModel:(JHPlateDetailModel*)model{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.jhTitleLabel.font = JHFont(18);
    self.title = self.model.name;
    [self jhNavBottomLine];
    [self tableView];
}
#pragma mark --------------- UITableViewDelegate DataSource ---------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.viewModel.dataArray.count;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0 || section == 1)
    {
        return 1;
    }
    return self.model.owners.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110;
    }else if (indexPath.section == 1){
        return [JHPalteAboutDescTableViewCell cellHeight:self.model.desc].height+10;
    }else{
        return 70;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [UILabel jh_labelWithBoldFont:18 textColor:HEXCOLOR(0x333333) addToSuperView:view];
        label.frame = CGRectMake(15, 10, 100, 25);
        label.text = (section == 1) ? @"版块简介":@"版主信息";
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        JHPalteAboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell"];
        if (!cell) {
            cell = [[JHPalteAboutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aboutCell"];
        }
        [cell setDataWithCell:self.model];
        return cell;
    }
    else if(indexPath.section == 1){//row = 1
        JHPalteAboutDescTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCell"];
         if (!cell) {
             cell = [[JHPalteAboutDescTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"descCell"];
         }
        [cell updateUI:self.model.desc];
        return cell;
    }else if(indexPath.section == 2){
        JHPalteAboutModerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moderCell"];
         if (!cell) {
             cell = [[JHPalteAboutModerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moderCell"];
         }
        [cell resetCellDataWithModel:self.model.owners[indexPath.row]];
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 2){
        [JHSQManager enterUserInfoVCWithPublisher:self.model.owners[indexPath.row]];
    }
    
}


-(UITableView *)tableView
{
    if(!_tableView){
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStyleGrouped separatorStyle:UITableViewCellSeparatorStyleNone target:self addToSuperView:self.view];
        _tableView.sectionFooterHeight = 10.f;
        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
        self.tableView.backgroundColor = UIColor.whiteColor;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
        }];
        
    }
    return _tableView;
}




@end
