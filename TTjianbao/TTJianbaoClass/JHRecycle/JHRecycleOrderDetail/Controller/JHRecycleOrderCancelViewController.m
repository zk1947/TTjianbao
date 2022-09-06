//
//  JHRecycleOrderCancelViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderCancelViewController.h"
#import "JHRecycleOrderCancelCell.h"
#import "JHRecycleOrderCancelViewModel.h"
#import "JHRecycleOrderCancelCellViewModel.h"
#import "MBProgressHUD.h"
#import "UIView+JHGradient.h"

static const CGFloat ContentViewHeight = 334.f;
static const CGFloat TableViewTopSpace = 13.f;

static const CGFloat ButtonViewTopSpace = 8.f;
static const CGFloat ButtonViewHeight = 44.f;


@interface JHRecycleOrderCancelViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) JHRecycleOrderCancelViewModel *viewModel;
@end

@implementation JHRecycleOrderCancelViewController

#pragma mark - Life Cycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self layoutViews];
    [self registerCells];
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    [self layoutViews];
//}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.titleLabel.text = titleString;
}
- (void)dealloc {
    NSLog(@"回收取消列表详情-%@ 释放", [self class]);
}

- (void)showCancelButton {
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(ButtonViewTopSpace + UI.bottomSafeAreaHeight));
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(ButtonViewHeight);
    }];
    
    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cancelButton.mas_right).mas_offset(20);
        make.bottom.mas_equalTo(self.cancelButton);
        make.height.mas_equalTo(self.cancelButton);
        make.width.mas_equalTo(self.cancelButton);
        make.right.mas_equalTo(-20);
    }];

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
- (void)didClickConfirmAction : (UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    if (self.selectCompleteBlock) {
        self.selectCompleteBlock(self.msg, self.code);
    }
    if (self.code == nil) return;
    if (self.msg == nil) return;
    self.selectedMsg = self.msg;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleOrderCancelCellViewModel *viewModel = self.viewModel.cellViewModels[indexPath.section];
    viewModel.isSelected = true;
    self.msg = viewModel.titleText;
    self.code = viewModel.code;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleOrderCancelCellViewModel *viewModel = self.viewModel.cellViewModels[indexPath.section];
    viewModel.isSelected = false;
    self.msg = @"";
    self.code = @"";
}
#pragma mark - Private Functions
- (void)showProgressHUD {
    [MBProgressHUD showHUDAddedTo:self.contentView animated:true];
}
- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:self.contentView animated:true];
}
#pragma mark - Bind
- (void)bindData {
    @weakify(self)
    [self.viewModel.refreshTableView subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self updateContentViewHight];
        [self.tableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{   //默认选中第一个
            //刷新完成，执行后续代码
            if (self.viewModel.cellViewModels.count == 0) {
                return;
            }
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        });
    }];
    [self.viewModel.endRefreshing subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self hideProgressHUD];
    }];
}
#pragma mark - setupUI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.closeButton];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.confirmButton];
}
- (void)layoutViews {
    [self.contentView jh_cornerRadius:8];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(ContentViewHeight + UI.bottomSafeAreaHeight);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(13);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(TableViewTopSpace);
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.confirmButton.mas_top).offset(-ButtonViewTopSpace);
    }];
    
    if(self.isShowCancel) {
        [self showCancelButton];
    }else {
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-(ButtonViewTopSpace + UI.bottomSafeAreaHeight));
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.height.mas_equalTo(ButtonViewHeight);
        }];
    }
}

- (void)updateContentViewHight {
    //+45 是要预留出来半个cell的高度
    CGFloat contentViewHeight = self.viewModel.cancelViewHeight > 447 + 45 ? 447 + 45 : self.viewModel.cancelViewHeight;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentViewHeight + UI.bottomSafeAreaHeight);
    }];
}

- (void)registerCells {
    [self.tableView registerClass:[JHRecycleOrderCancelCell class]
           forCellReuseIdentifier:@"JHRecycleOrderCancelCell"];
}
#pragma mark - uitableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.cellViewModels.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleOrderCancelCellViewModel *viewModel = self.viewModel.cellViewModels[indexPath.section];
    JHRecycleOrderCancelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleOrderCancelCell"
                                                                           forIndexPath: indexPath];
   
    cell.viewModel = viewModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleOrderCancelCellViewModel *viewModel = self.viewModel.cellViewModels[indexPath.section];
    return viewModel.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.viewModel.cellViewModels.count - 1 == section) {
        return 0.1f;
    }
    return 10.0f;
}

- (void)setTitleText:(NSString *)text {
    self.titleLabel.text = text;
}
#pragma mark - Lazy
- (void)setOrderId:(NSString *)orderId {
    orderId = orderId;
    [self showProgressHUD];
    self.viewModel.orderId = orderId;
    
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    self.viewModel.dataArray = dataArray;
}

- (void)setRequestType:(NSInteger)requestType {
    _requestType = requestType;
    [self showProgressHUD];
    if(_requestType==4){
        self.viewModel.dataSource = self.datas;
    }
    self.viewModel.requestType = requestType;
}
- (JHRecycleOrderCancelViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[JHRecycleOrderCancelViewModel alloc] init];
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
        _titleLabel.text = @"选择取消理由";
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
//        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}
- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        [_confirmButton jh_cornerRadius:ButtonViewHeight / 2];
        [_confirmButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xffd710), HEXCOLOR(0xffc242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        [_confirmButton addTarget:self action:@selector(didClickConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        [_cancelButton jh_cornerRadius:ButtonViewHeight / 2];
        _cancelButton.backgroundColor = UIColor.whiteColor;
        
        _cancelButton.layer.cornerRadius = 22;
        _cancelButton.layer.borderWidth = 0.5;
        _cancelButton.layer.borderColor = RGB(189, 191, 194).CGColor;
//        [_cancelButton setImage:[UIImage imageNamed:@"recycle_Arbitration_close"] forState:UIControlStateNormal];
//        [_cancelButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xffd710), HEXCOLOR(0xffc242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        [_cancelButton addTarget:self action:@selector(didClickCloseWithAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}


@end
