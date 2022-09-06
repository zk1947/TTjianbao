//
//  JHRejectShowViewController.m
//  TTjianbao
//
//  Created by plz on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRejectShowViewController.h"
#import "JHRejectShowDescCell.h"
#import "JHRejectShowReasonCell.h"
#import "JHRejectShowContactCell.h"
#import "UIView+AddSubviews.h"

@interface JHRejectShowViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView *tabelView;

@end

@implementation JHRejectShowViewController

#pragma mark - life cyle 1、控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
}

- (void)dealloc {
    NSLog(@"拒绝说明ViewController-%@ 释放", [self class]);
}

#pragma mark - 2、不同业务处理之间的方法

#pragma mark - Network 3、网络请求

#pragma mark - Action Event 4、响应事件

#pragma mark - Call back 5、回调事件

#pragma mark - Delegate 6、代理、数据源

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = HEXCOLOR(0xF5F6FA);
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [JHRejectShowDescCell cellHeight];
    }else if (indexPath.section == 1) {
        return [JHRejectShowReasonCell cellHeight];
    }
    return [JHRejectShowContactCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JHRejectShowDescCell *cell = [JHRejectShowDescCell cellWithTableView:tableView];
        return cell;
    }else if (indexPath.section == 1) {
        JHRejectShowReasonCell *cell = [JHRejectShowReasonCell cellWithTableView:tableView];
        return cell;
    }
    JHRejectShowContactCell *cell = [JHRejectShowContactCell cellWithTableView:tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tabelView) {
            cell.backgroundView = [self.view renderCornerRadiusWithCell:cell indexPath:indexPath tableView:tableView cornerRadius:8];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        NSLog(@"section=%ld",indexPath.section);
    }
}

#pragma mark - interface 7、UI处理
-(void)setupViews{
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    self.title = @"拒绝说明";
    
    [self.view addSubview:self.tabelView];
    [self.tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake([self navViewHeight], 10.f, 0.f, 10.f));
    }];
    
}

- (CGFloat)navViewHeight {
    CGFloat navHeight = UI.statusBarHeight + 44.f;
    return navHeight;
}
#pragma mark - lazy loading 8、懒加载
- (UITableView *)tabelView {
    if (!_tabelView) {
        _tabelView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tabelView.dataSource = self;
        _tabelView.delegate = self;
        _tabelView.backgroundColor = HEXCOLOR(0xF5F6FA);
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabelView.estimatedRowHeight = 10;
        if (@available(iOS 11.0, *)) {
            _tabelView.estimatedSectionHeaderHeight = 0.1f;
            _tabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [_tabelView registerClass:[JHRejectShowContactCell class] forCellReuseIdentifier:NSStringFromClass([JHRejectShowContactCell class])];


        if ([_tabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_tabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tabelView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _tabelView;
}
@end
