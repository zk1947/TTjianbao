//
//  JHBusinessCollegeViewController.m
//  TTjianbao
//
//  Created by user on 2021/5/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessCollegeViewController.h"
#import "JHBusinessCollegeTableViewCell.h"
#import "UIView+JHGradient.h"

@interface JHBusinessCollegeViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView    *busControlTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@end

@implementation JHBusinessCollegeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品管理";
    self.view.backgroundColor = HEXCOLOR(0xF5F5F8);
    [self setupViews];
    [self loadData];
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (CGFloat)navViewHeight {
    CGFloat navHeight = UI.statusBarHeight + 44.f;
    return navHeight;
}

- (void)setupViews {
    [self.view addSubview:self.busControlTableView];
    [self.busControlTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake([self navViewHeight], 10.f, 0.f, 10.f));
    }];
    
    UIButton *publishGoodsBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
    publishGoodsBtn.titleLabel.font     = [UIFont fontWithName:kFontMedium size:16.f];
    publishGoodsBtn.layer.cornerRadius  = 5.f;
    publishGoodsBtn.layer.masksToBounds = YES;
    [publishGoodsBtn setTitle:@"发布商品" forState:UIControlStateNormal];
    [publishGoodsBtn setTitleColor:kColor222 forState:UIControlStateNormal];
    [publishGoodsBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [publishGoodsBtn addTarget:self action:@selector(publishGoodsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publishGoodsBtn];
    [publishGoodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-UI.bottomSafeAreaHeight-33.f);
        make.left.equalTo(self.view.mas_left).offset(28.f);
        make.right.equalTo(self.view.mas_right).offset(-28.f);
        make.height.mas_equalTo(44.f);
    }];
}

- (UITableView *)busControlTableView {
    if (!_busControlTableView) {
        _busControlTableView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _busControlTableView.dataSource                     = self;
        _busControlTableView.delegate                       = self;
        _busControlTableView.backgroundColor                = HEXCOLOR(0xF5F6FA);
        _busControlTableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _busControlTableView.estimatedRowHeight             = 10.f;
        if (@available(iOS 11.0, *)) {
            _busControlTableView.estimatedSectionHeaderHeight   = 0.1f;
            _busControlTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        [_busControlTableView registerClass:[JHBusinessCollegeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHBusinessCollegeTableViewCell class])];

        if ([_busControlTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_busControlTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_busControlTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_busControlTableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _busControlTableView;
}

///
- (void)loadData {
    
}

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = HEXCOLOR(0xF5F5F8);
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHBusinessCollegeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHBusinessCollegeTableViewCell class])];
    if (!cell) {
        cell = [[JHBusinessCollegeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHBusinessCollegeTableViewCell class])];
    }
    [cell setViewModel:@"jhSetting_business_onePrice" text:@"一口价商品管理"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)publishGoodsBtnAction:(UIButton *)btn {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择发布商品类型" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
//    [alert addAction:[UIAlertAction actionWithTitle:@"拍卖商品" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"一口价商品" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }]];

    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];

}

@end
