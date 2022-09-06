//
//  JHNewStoreHomeBoutiqueViewController.m
//  TTjianbao
//
//  Created by user on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeBoutiqueViewController.h"

@interface JHNewStoreHomeBoutiqueViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView    *boutiqueTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@end

@implementation JHNewStoreHomeBoutiqueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)setupViews {
    
}

- (UITableView *)boutiqueTableView {
    if (!_boutiqueTableView) {
        _boutiqueTableView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _boutiqueTableView.dataSource                     = self;
        _boutiqueTableView.delegate                       = self;
        _boutiqueTableView.backgroundColor                = HEXCOLOR(0xF5F6FA);
        _boutiqueTableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _boutiqueTableView.estimatedRowHeight             = 10.f;
        if (@available(iOS 11.0, *)) {
            _boutiqueTableView.estimatedSectionHeaderHeight   = 0.1f;
            _boutiqueTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        if ([_boutiqueTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_boutiqueTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        
        if ([_boutiqueTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_boutiqueTableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _boutiqueTableView;
}

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}



@end
