//
//  JHVoucherSelectListView.m
//  TTjianbao
//
//  Created by wuyd on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHVoucherSelectListView.h"
#import "TTjianbao.h"
#import "YDBaseTableView.h"
#import "JHVoucherSelectListCell.h"
#import "JHVoucherApiManager.h"
#import "ZHProgressHud.h"

//#define kTotalWidth JHScaleToiPhone6(286)
static const CGFloat totalWidth = 286;
static const CGFloat edgeSpace = 13;

@interface JHVoucherSelectListView () <UITableViewDelegate, UITableViewDataSource>

//UI Property
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel *titleLabel; //标题栏
@property (nonatomic, strong) UIView *titleLine; //标题栏分割线
@property (nonatomic, strong) UIButton *closeButton; // 关闭按钮
@property (nonatomic, strong) UIButton *sendButton; //发放
@property (nonatomic, strong) UILabel *tipLabel; //底部注释
@property (nonatomic, strong) YDBaseTableView *tableView;

//Data Property
@property (nonatomic,   copy) NSString *sellerId; //卖家id
@property (nonatomic,   copy) NSString *customerId; //买家id
@property (nonatomic, strong) JHVoucherListModel *curModel;
@property (nonatomic, strong) NSMutableArray *selectedIDs; //选中的代金券

//@property (nonatomic, copy) VoucherSelectedBlock selectedBlock;

@end

@implementation JHVoucherSelectListView

- (void)dealloc {
    _curModel = nil;
    _selectedIDs = nil;
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

+ (instancetype)voucherWithSellerId:(NSString *)sellerId customerId:(nonnull NSString *)customerId {
    JHVoucherSelectListView *view = [[JHVoucherSelectListView alloc] initWithFrame:CGRectZero
                                                                          sellerId:sellerId
                                                                        customerId:customerId];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame sellerId:(NSString *)sellerId customerId:(NSString *)customerId {
    self = [super initWithFrame:CGRectMake(0, 0, totalWidth, 0)];
    if (self) {
        _sellerId = sellerId;
        _customerId = customerId;
        
        [self initData];
        [self configUI];
        [self makeLayout];
        
        [self getVoucherList];
    }
    return self;
}

- (void)initData {
    _selectedIDs = [NSMutableArray new];
    
    _curModel = [[JHVoucherListModel alloc] init];
    _curModel.sellerId = _sellerId;
}

- (void)configUI {
    
    //container
    _container = [UIView new];
    _container.backgroundColor = [UIColor whiteColor];
    _container.clipsToBounds = YES;
    _container.sd_cornerRadius = @(4);
    [self addSubview:_container];
    
    //关闭按钮
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"icon_alert_close"] forState:UIControlStateNormal];
    [self addSubview:_closeButton];
    
    //标题栏
    _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:15] textColor:kColor333];
    _titleLabel.text = @"代金券";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //标题栏分割线
    _titleLine = [UIView new];
    _titleLine.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
    
    //列表
    _tableView = [[YDBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = [JHVoucherSelectListCell cellHeight];
    [_tableView registerClass:[JHVoucherSelectListCell class] forCellReuseIdentifier:kCellId_JHVoucherSelectListCell];
    
    //发放
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setTitle:@"发放" forState:UIControlStateNormal];
    _sendButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
    [_sendButton setTitleColor:kColor333 forState:UIControlStateNormal];
    [_sendButton setTitleColor:kColor999 forState:UIControlStateDisabled];
    [_sendButton setBackgroundImage:[UIImage imageWithColor:kColorMain] forState:UIControlStateNormal];
    [_sendButton setBackgroundImage:[UIImage imageWithColor:kColorMain] forState:UIControlStateHighlighted];
    [_sendButton setBackgroundImage:[UIImage imageWithColor:kColorEEE] forState:UIControlStateDisabled];
    _sendButton.sd_cornerRadius = @(20);
    
    //底部注释
    _tipLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:11] textColor:kColor999];
    _tipLabel.text = @"注：发放后无需领取直接到用户账号";
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    
    [_container sd_addSubviews:@[_titleLabel, _titleLine, _tableView, _sendButton, _tipLabel]];
    
    //点击事件
    @weakify(self);
    [[_closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.closeBlock) {
            self.closeBlock();
        }
    }];
    
    [[_sendButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        //发放代金券
        [self sendVoucherRequest];
    }];
}

//默认布局
- (void)makeLayout {
    _closeButton.sd_layout
    .topEqualToView(self).rightSpaceToView(self, 0).widthIs(26).heightEqualToWidth();
    
    //container
    _container.sd_layout
    .topSpaceToView(self, edgeSpace).leftSpaceToView(self, edgeSpace).rightSpaceToView(self, edgeSpace);
    
    _titleLabel.sd_layout
    .topEqualToView(_container).leftEqualToView(_container).rightEqualToView(_container).heightIs(44);
    
    _titleLine.sd_layout
    .topSpaceToView(_titleLabel, 0).leftEqualToView(_container).rightEqualToView(_container).heightIs(1);
    
    _tableView.sd_layout
    .topSpaceToView(_titleLine, 0).leftEqualToView(_container).rightEqualToView(_container).heightIs(160);
    
    _sendButton.sd_layout
    .topSpaceToView(_tableView, 13)
    .centerXEqualToView(_container)
    .widthIs(230)
    .heightIs(40);
    
    _tipLabel.sd_layout
    .topSpaceToView(_sendButton, 10).leftSpaceToView(_container, 15).rightSpaceToView(_container, 15).heightIs(16);
    
    [_container setupAutoHeightWithBottomView:_tipLabel bottomMargin:15];
    [self setupAutoHeightWithBottomView:_container bottomMargin:0];
}

//空页面布局
- (void)makeEmptyLayout {
    [_sendButton setTitle:@"我知道了" forState:UIControlStateNormal];
    _sendButton.sd_layout.topSpaceToView(_tableView, 0).widthIs(140);
    _tipLabel.hidden = YES;
    
    [_container setupAutoHeightWithBottomView:_sendButton bottomMargin:17];
    [self setupAutoHeightWithBottomView:_container bottomMargin:0];
}


#pragma mark -
#pragma mark - 监听选择代金券，动态切换发放按钮
- (void)startRACEvent {
    //发放按钮状态
    @weakify(self);
    RAC(self, sendButton.enabled) = [RACSignal combineLatest:@[RACObserve(self, selectedIDs)] reduce:^id (NSMutableArray *list) {
        @strongify(self);
        return @(self.selectedIDs.count > 0);
    }];
}

#pragma mark -
#pragma mark - 网络请求

//获取可发放代金券列表
- (void)getVoucherList {
    [self.container beginLoading];
    @weakify(self);
    [JHVoucherApiManager getValidDataList:_curModel block:^(JHVoucherListModel * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self.container endLoading];
        self.tableView.scrollEnabled = (respObj != nil);
        
        if (respObj) {
            [self.curModel configModel:respObj];
            [self.tableView reloadData];
            //启动监听
            [self startRACEvent];
            
        } else {
            [self makeEmptyLayout];
        }
        
        [self.container configBlankType:YDBlankTypeNoValidVoucherList hasData:_curModel.list.count > 0 hasError:NO offsetY:-(self.tableView.height_sd/3) reloadBlock:^(id sender) {
            
        }];
    }];
}

//发放代金券
- (void)sendVoucherRequest {
    if (_curModel.list.count == 0 || [_sendButton.titleLabel.text isEqualToString:@"我知道了"]) {
        if (self.closeBlock) {
            self.closeBlock();
        }
        return;
    }
    
    [ZHProgressHud showLoading:@"正在发放..." inView:self];
    @weakify(self);
    [JHVoucherApiManager sendVoucherToUserId:_customerId sellerId:_sellerId voucherIds:_selectedIDs block:^(RequestModel * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [ZHProgressHud hide];
        if (hasError) {
            [UITipView showTipStr:respObj.message];
        } else {
            [ZHProgressHud showSuccess:@"发放成功" inView:self];
            if (self.closeBlock) {
                self.closeBlock();
            }
        }
    }];
}


#pragma mark -
#pragma mark - UITableViewDataSource & UITableViewDelegate M

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _curModel.list.count;
}

/** 适配iOS11：这两个方法必须实现，且返回高度必须大于0，不然不起作用！！！ */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHVoucherSelectListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId_JHVoucherSelectListCell forIndexPath:indexPath];
    
    cell.sd_indexPath = indexPath;
    cell.curData = _curModel.list[indexPath.row];
    
    @weakify(self);
    cell.cellClickBlock = ^(JHVoucherSelectListCell * _Nonnull curCCell, JHVoucherListData * _Nonnull data) {
        @strongify(self);
        [self __handleSelectedData:data atIndexPath:curCCell.sd_indexPath];
    };
    
    return cell;
}

- (void)__handleSelectedData:(JHVoucherListData *)data atIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *ids = [self mutableArrayValueForKey:@"selectedIDs"]; //为了kvo
    
    if (data.checkedStatus) { //选中状态
        if ([ids containsObject:@(data.voucherId).stringValue]) {
            [ids removeObject:@(data.voucherId).stringValue];
        }
        [ids addObject:@(data.voucherId).stringValue];
        
    } else { //如果是取消关注则删除
        if ([ids containsObject:@(data.voucherId).stringValue]) {
            [ids removeObject:@(data.voucherId).stringValue];
        }
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

@end
