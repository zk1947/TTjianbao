//
//  JHRecycleMeAttentionViewController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleMeAttentionViewController.h"
#import "JHRecycleMeAttentionCell.h"
#import "JHRecycleSureButton.h"
#import "JHRecycleUploadProductBusiness.h"
#import "JHRefreshGifHeader.h"
#import "JHRefreshNormalFooter.h"
#import "SVProgressHUD.h"
#import "JHRecycleDetailViewController.h"
#import "CommAlertView.h"

static NSString * typeName = @"typeName";
static NSString * typeImage = @"typeImage";

@interface JHRecycleMeAttentionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView * tableView;

@property(nonatomic, strong) UIView * bottomSeleteAllView;

@property(nonatomic, strong) JHRecycleSureButton* cancleAttentionBtn;

@property(nonatomic, assign) NSInteger  pageNo;

@property(nonatomic, strong) UIButton* allBtn;

@property(nonatomic, strong) NSMutableArray<JHRecycleMeAttentionListModel*> * resultList;

@end

@implementation JHRecycleMeAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    [self setItems];
    [self layoutItems];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setItems{
    [self initRightButtonWithName:@"编辑" action:@selector(rightButtonActionWithSender:)];
    [self.jhRightButton setImage:[UIImage imageNamed:@"recycle_me_attention_edit"] forState:UIControlStateNormal];
    self.jhRightButton.imageEdgeInsets = UIEdgeInsetsMake(-8, 16, 8, -16);
    self.jhRightButton.titleEdgeInsets = UIEdgeInsetsMake(9, 0, -9, 0);
    self.jhRightButton.titleLabel.font = JHFont(10);
    [self.jhRightButton setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomSeleteAllView];
    [self.bottomSeleteAllView addSubview:self.cancleAttentionBtn];
    [self.bottomSeleteAllView addSubview:self.allBtn];
}

- (void)layoutItems{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(self.jhNavView.mas_bottom);
    }];
    [self.bottomSeleteAllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(UI.bottomSafeAreaHeight + 60);
    }];
    [self.cancleAttentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(275, 45));
        make.top.equalTo(@0).offset(8);
        make.right.equalTo(@0).offset(-12);
    }];
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.bottom.equalTo(self.cancleAttentionBtn);
        make.right.equalTo(self.cancleAttentionBtn.mas_left);
    }];
}

- (void)rightButtonActionWithSender:(UIButton*)sender{
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    [self refreshViewWithStatu:self.tableView.isEditing];
}
- (void)refreshViewWithStatu:(BOOL)isEditing{
    [UIView animateWithDuration:0.3 animations:^{
        if (isEditing) {
            self.bottomSeleteAllView.transform = CGAffineTransformMakeTranslation(0, - UI.bottomSafeAreaHeight - 60);
        }else{
            self.bottomSeleteAllView.transform = CGAffineTransformIdentity;
        }
    }];
}

- (void)refreshData{
    self.pageNo = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [JHRecycleUploadProductBusiness requestRecycleMeAttentionListPageNo:self.pageNo andPageSize:20 Completion:^(NSError * _Nullable error, JHRecycleMeAttentionModel * _Nullable model) {
        [self.tableView.mj_header endRefreshing];
        if (!error) {
            self.resultList = [NSMutableArray arrayWithArray:model.resultList];
            [self.tableView jh_reloadDataWithEmputyView];
            if (!model.hasMore) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.pageNo += 1;
        }

    }];
}

- (void)addMoreData{
    [JHRecycleUploadProductBusiness requestRecycleMeAttentionListPageNo:self.pageNo andPageSize:20 Completion:^(NSError * _Nullable error, JHRecycleMeAttentionModel * _Nullable model) {
        [self.tableView.mj_footer endRefreshing];
        if (!error) {
            [self.resultList addObjectsFromArray:model.resultList];
            [self.tableView jh_reloadDataWithEmputyView];
            if (!model.hasMore) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.pageNo += 1;
        }
    }];
}

- (void)cancleAttentionBtnAction:(UIButton*)sender{
    NSArray *rows = self.tableView.indexPathsForSelectedRows;
    [self.tableView setEditing:NO animated:YES];
    [self refreshViewWithStatu:NO];
    self.allBtn.selected = NO;
    NSMutableArray *cancleProductIDsArr = [NSMutableArray arrayWithCapacity:0];
    [rows enumerateObjectsUsingBlock:^(NSIndexPath*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JHRecycleMeAttentionListModel *model = self.resultList[obj.row];
        [cancleProductIDsArr addObject:[NSNumber numberWithInteger:model.productId.integerValue]];
    }];
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"确认要删除收藏记录吗？" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        ///数据请求
        [JHRecycleUploadProductBusiness requestRecycleMeAttentionRemoveProductIDs:cancleProductIDsArr Completion:^(NSError * _Nullable error) {
            if (!error) {
                [self.tableView.mj_header beginRefreshing];
            }else{
                [SVProgressHUD showErrorWithStatus:@"取消收藏失败"];
            }
        }];
    };
    
}

- (void)allBtnAction:(UIButton*)sender{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        for (int i = 0; i < self.resultList.count; i++) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }else{
        for (int i = 0; i < self.resultList.count; i++) {
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO];
        }
    }
}

#pragma mark -- <UITableViewDelegate and UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHRecycleMeAttentionListModel *model = self.resultList[indexPath.row];
    JHRecycleMeAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(JHRecycleMeAttentionCell.class) forIndexPath:indexPath];
    [cell refreshWithHomeSquareModel:model];
    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 编辑模式下不允许点击进入详情
    if (tableView.isEditing) {
//        JHRecycleMeAttentionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        return;
    }
    // 不是编辑模式下才允许进入详情页面
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHRecycleMeAttentionListModel *model = self.resultList[indexPath.row];
    JHRecycleDetailViewController *vc = [JHRecycleDetailViewController new];
    vc.identityType = 1;
    vc.productId = model.productId;
    [self.navigationController pushViewController:vc animated:YES];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

#pragma mark -- <set and get>


- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] init];
        view.delegate = self;
        view.dataSource = self;
        view.estimatedRowHeight = 153;
        view.rowHeight = UITableViewAutomaticDimension;
        view.tableFooterView = [UIView new];
        view.backgroundColor = HEXCOLOR(0xF5F5F5);
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.allowsMultipleSelectionDuringEditing = YES;
        [view registerClass:JHRecycleMeAttentionCell.class forCellReuseIdentifier:NSStringFromClass(JHRecycleMeAttentionCell.class)];
        view.contentInset = UIEdgeInsetsMake(0, 0, UI.bottomSafeAreaHeight + 60, 0);
        @weakify(self);
        view.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self refreshData];
        }];
        view.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self addMoreData];
        }];
        _tableView = view;
    }
    return _tableView;
}

- (UIView *)bottomSeleteAllView{
    if (!_bottomSeleteAllView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        _bottomSeleteAllView = view;
    }
    return _bottomSeleteAllView;
}

- (JHRecycleSureButton *)cancleAttentionBtn{
    if (!_cancleAttentionBtn) {
        _cancleAttentionBtn = [JHRecycleSureButton new];
        [_cancleAttentionBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
        [_cancleAttentionBtn addTarget:self action:@selector(cancleAttentionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancleAttentionBtn.layer.cornerRadius = 22.5;
    }
    return _cancleAttentionBtn;
}

- (UIButton *)allBtn{
    if (!_allBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(allBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"全选" forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
        [btn setImage:[UIImage imageNamed:@"recycle_piublish_price_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"recycle_piublish_price_selected"] forState:UIControlStateSelected];
        btn.titleLabel.font = JHFont(13);
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _allBtn = btn;
    }
    return _allBtn;
}

@end
