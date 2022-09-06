//
//  JHRecycleOrderBusinessViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessViewController.h"
#import "JHRecycleOrderBusinessViewModel.h"
#import "JHRecycleOrderBusinessDesCell.h"
#import "JHRecycleOrderBusinessVideoCell.h"
#import "JHRecycleOrderBusinessImageCell.h"
#import "JHPlayerViewController.h"
#import "JHNormalControlView.h"
#import "JHPlayerVerticalBigView.h"
#import "JHRefreshGifHeader.h"
#import "MBProgressHUD.h"
#import "JHPhotoBrowserManager.h"

@interface JHRecycleOrderBusinessViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) JHRecycleOrderBusinessViewModel *viewModel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) JHPlayerViewController *playerController;
@property (nonatomic, strong) JHNormalControlView *normalPlayerControlView;
@property (nonatomic, strong) JHPlayerVerticalBigView *verticalPlayerControlView;
@end

@implementation JHRecycleOrderBusinessViewController

#pragma mark - Life Cycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self registerCells];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.view == self.view) {
            [self dismissViewControllerAnimated:true completion:nil];
            return;
        }
    }
}
#pragma mark - Action functions
- (void)didClickCloseWithAction : (UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleOrderBusinessBaseViewModel *viewModel = self.viewModel.sectionViewModel.cellViewModelList[indexPath.section];
    
    if (viewModel.cellType != RecycleOrderBusinessCellTypeImage) return;
    
    [self showPhotoBrowserWithModel:viewModel];
}
#pragma mark - Private Functions
- (void)showProgressHUD {
    [MBProgressHUD showHUDAddedTo:self.contentView animated:true];
}
- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:self.contentView animated:true];
}
- (void)setPlayerViewsWithContent : (JHRecycleOrderBusinessVideoCell *)content {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [content.videoView insertSubview:self.playerController.view belowSubview:content.bgImageView];
        self.playerController.view.frame = content.videoView.bounds;
        
        [self.playerController setControlView:self.normalPlayerControlView];
        @weakify(self)
        [content.viewModel.playEvent subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            self.playerController.urlString = content.viewModel.videoUrl;
            [self.playerController setSubviewsFrame];
        }];
    });
}

- (void)showPhotoBrowserWithModel : (JHRecycleOrderBusinessBaseViewModel *)model {
    [JHPhotoBrowserManager showPhotoBrowserThumbImages:self.viewModel.mediumList
                                          mediumImages:self.viewModel.bigList
                                            origImages:self.viewModel.originList
                                               sources:@[[UIImageView new]]
                                          currentIndex:model.index
                                   canPreviewOrigImage:true
                                             showStyle:GKPhotoBrowserShowStyleZoom];
}
#pragma mark - Bind
- (void)bindData {
    @weakify(self)
    [self.viewModel.refreshTableView subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView jh_reloadDataWithEmputyView];
    }];
    [self.viewModel.endRefreshing subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self hideProgressHUD];
        [self.tableView jh_endRefreshing];
    }];
}
#pragma mark - setupUI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.closeButton];
    [self.contentView addSubview:self.tableView];
    [self showProgressHUD];
}
- (void)layoutViews {
    [self.contentView jh_cornerRadius:8
                           rectCorner:UIRectCornerTopLeft|UIRectCornerTopRight
                               bounds:self.contentView.bounds];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ScreenH * 3 / 4);
        make.left.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.contentView).offset(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(56);
        make.left.right.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(-UI.bottomSafeAreaHeight);
    }];
    
    
}
- (void)registerCells {
    [self.tableView registerClass:[JHRecycleOrderBusinessDesCell class]
           forCellReuseIdentifier:@"JHRecycleOrderBusinessDesCell"];
    [self.tableView registerClass:[JHRecycleOrderBusinessVideoCell class]
           forCellReuseIdentifier:@"JHRecycleOrderBusinessVideoCell"];
    [self.tableView registerClass:[JHRecycleOrderBusinessImageCell class]
           forCellReuseIdentifier:@"JHRecycleOrderBusinessImageCell"];
    
}
#pragma mark - uitableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.sectionViewModel.cellViewModelList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleOrderBusinessBaseViewModel *viewModel = self.viewModel.sectionViewModel.cellViewModelList[indexPath.section];
    if (viewModel.cellType == RecycleOrderBusinessCellTypeDes) {
        JHRecycleOrderBusinessDesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleOrderBusinessDesCell"
                                                                               forIndexPath: indexPath];
        if ([viewModel isKindOfClass:[JHRecycleOrderBusinessDesViewModel class]]) {
            cell.viewModel = (JHRecycleOrderBusinessDesViewModel *)viewModel;
        }
        return cell;
    }else if (viewModel.cellType == RecycleOrderBusinessCellTypeImage) {
        JHRecycleOrderBusinessImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleOrderBusinessImageCell"
                                                                               forIndexPath: indexPath];
        if ([viewModel isKindOfClass:[JHRecycleOrderBusinessImageViewModel class]]) {
            cell.viewModel = (JHRecycleOrderBusinessImageViewModel *)viewModel;
        }
        return cell;
    }else if (viewModel.cellType == RecycleOrderBusinessCellTypeVideo) {
        JHRecycleOrderBusinessVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleOrderBusinessVideoCell"
                                                                               forIndexPath: indexPath];
        
        if ([viewModel isKindOfClass:[JHRecycleOrderBusinessVideoViewModel class]]) {
            cell.viewModel = (JHRecycleOrderBusinessVideoViewModel *)viewModel;
            [self setPlayerViewsWithContent:cell];
        }
        return cell;
    }
    
    
    return [[UITableViewCell alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleOrderBusinessBaseViewModel *viewModel = self.viewModel.sectionViewModel.cellViewModelList[indexPath.section];
    return viewModel.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.viewModel.sectionViewModel.cellViewModelList.count - 1 == section) {
        return 0.1f;
    }
    return 10.0f;
}
#pragma mark - Lazy

- (void)setOrderId:(NSString *)orderId {
    _orderId = orderId;
//    [self showProgressHUD];
    self.viewModel.orderId = orderId;
    [self.viewModel getBusinessInfo];
}

- (JHRecycleOrderBusinessViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[JHRecycleOrderBusinessViewModel alloc] init];
        [self bindData];
    }
    return _viewModel;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"商家验收说明";
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
    }
    return _titleLabel;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton
        .jh_imageName(@"newStore_coupon_close_icon")
        .jh_action(self,@selector(didClickCloseWithAction:));
    }
    return _closeButton;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        @weakify(self);
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel getBusinessInfo];
        }];
    }
    return _tableView;
}

- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
        _playerController.looping = true;
        _playerController.alwaysPlay = true;
        _playerController.fullScreenView = self.verticalPlayerControlView;
        [self addChildViewController:_playerController];
//        @weakify(self);
//        _playerController.playbackStateDidChangedBlock = ^(TTVideoEnginePlaybackState playbackState) {
//            @strongify(self);
//            if (self.isScrollPause) { return; }
//            self.isPlaying = (playbackState == TTVideoEnginePlaybackStatePlaying);
//        };
    }
    return _playerController;
}
- (JHNormalControlView *)normalPlayerControlView {
    if (_normalPlayerControlView == nil) {
        _normalPlayerControlView = [[JHNormalControlView alloc] initWithFrame:self.playerController.view.bounds];
    }
    return _normalPlayerControlView;
}

- (JHPlayerVerticalBigView *)verticalPlayerControlView {
    if (_verticalPlayerControlView == nil) {
        _verticalPlayerControlView = [[JHPlayerVerticalBigView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        @weakify(self);
//        _verticalPlayerControlView.actionBlock = ^(JHFullScreenControlActionType actionType) {
//            @strongify(self);
//            [self handleFullScreenControlAction:actionType];
//        };
    }
    return _verticalPlayerControlView;
}
@end
