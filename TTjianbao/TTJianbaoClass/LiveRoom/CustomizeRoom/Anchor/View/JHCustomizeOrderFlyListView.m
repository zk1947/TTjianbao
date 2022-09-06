//
//  JHCustomizeOrderFlyListView.m
//  TTjianbao
//
//  Created by user on 2021/1/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHCustomizeOrderFlyListView.h"
#import "UIButton+LXExpandBtn.h"
#import "JHLiveApiManager.h"
#import "IQKeyboardManager.h"
//#import "OrderMode.h"
#import "JHCustomizePackageFlyOrderModel.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "TTjianbaoUtil.h"
#import "OrderMode.h"
#import "UIScrollView+JHEmpty.h"
#import "JHNOAllowTabelView.h"

typedef void (^ccActionBlock)(JHCheckCustomizeOrderListModel *model);
@interface JHCustomizeOrderFlyListTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel                        *orderIdLabel;
@property (nonatomic, strong) UILabel                        *statusLabel;
@property (nonatomic, strong) UIImageView                    *posterImageView;
@property (nonatomic, strong) UILabel                        *redBorderLabel;
@property (nonatomic, strong) UILabel                        *infoLabel;
@property (nonatomic, strong) UILabel                        *timeLabel;
@property (nonatomic, strong) UILabel                        *moneyLabel;
@property (nonatomic, strong) UIButton                       *customizeButton;
@property (nonatomic, strong) JHCheckCustomizeOrderListModel *orderListModel;
@property (nonatomic,   copy) ccActionBlock                   clickBlock;

- (void)setViewModel:(JHCheckCustomizeOrderListModel *)viewModel;
@end

@implementation JHCustomizeOrderFlyListTableViewCell

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _orderIdLabel           = [[UILabel alloc] init];
    _orderIdLabel.textColor = HEXCOLOR(0x333333);
    _orderIdLabel.font      = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_orderIdLabel];
    [_orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10.f);
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.height.mas_equalTo(17.f);
    }];
    
    _statusLabel           = [[UILabel alloc] init];
    _statusLabel.textColor = HEXCOLOR(0x333333);
    _statusLabel.font      = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderIdLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(17.f);
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXCOLOR(0xF5F6FA);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderIdLabel.mas_bottom).offset(5.f);
        make.left.equalTo(self.orderIdLabel.mas_left);
        make.right.equalTo(self.statusLabel.mas_right);
        make.height.mas_equalTo(0.5f);
    }];

    
    _posterImageView                     = [[UIImageView alloc] init];
    _posterImageView.layer.cornerRadius  = 8.f;
    _posterImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_posterImageView];
    [_posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderIdLabel.mas_left);
        make.top.equalTo(lineView.mas_bottom).offset(10.f);
        make.size.mas_equalTo(CGSizeMake(55.f, 55.f));
    }];
    
    _redBorderLabel                     = [[UILabel alloc] init];
    _redBorderLabel.textColor           = HEXCOLOR(0xFF4200);
    _redBorderLabel.font                = [UIFont fontWithName:kFontNormal size:10.f];
    _redBorderLabel.textAlignment       = NSTextAlignmentCenter;
    _redBorderLabel.layer.borderWidth   = 0.5f;
    _redBorderLabel.layer.borderColor   = HEXCOLOR(0xFF4200).CGColor;
    _redBorderLabel.layer.cornerRadius  = 2.f;
    _redBorderLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_redBorderLabel];
    [_redBorderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.posterImageView.mas_top);
        make.left.equalTo(self.posterImageView.mas_right).offset(10.f);
        make.width.mas_equalTo(24.f);
        make.height.mas_equalTo(17.f);
    }];
    
    _moneyLabel           = [[UILabel alloc] init];
    _moneyLabel.textColor = HEXCOLOR(0x333333);
    _moneyLabel.font      = [UIFont fontWithName:kFontBoldDIN size:18.f];
    [self.contentView addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.posterImageView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(18.f);
    }];
    
    _infoLabel               = [[UILabel alloc] init];
    _infoLabel.textColor     = HEXCOLOR(0x333333);
    _infoLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _infoLabel.numberOfLines = 2;
    [self.contentView addSubview:_infoLabel];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.redBorderLabel.mas_centerY);
        make.left.equalTo(self.redBorderLabel.mas_right).offset(5.f);
        make.right.equalTo(self.contentView.mas_right).offset(-71.f);
        make.height.mas_equalTo(18.f);
    }];
    
//    _nameLabel           = [[UILabel alloc] init];
//    _nameLabel.textColor = HEXCOLOR(0x333333);
//    _nameLabel.font      = [UIFont fontWithName:kFontNormal size:12.f];
//    [self.contentView addSubview:_nameLabel];
//    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.infoLabel.mas_bottom);
//        make.left.equalTo(self.redBorderLabel.mas_left);
//        make.height.mas_equalTo(18.f);
//    }];
    
    _timeLabel           = [[UILabel alloc] init];
    _timeLabel.textColor = HEXCOLOR(0x333333);
    _timeLabel.font      = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.posterImageView.mas_bottom);
        make.left.equalTo(self.redBorderLabel.mas_left);
        make.height.mas_equalTo(18.f);
    }];
    
    
    _customizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.customizeButton setTitle:@"定制" forState:UIControlStateNormal];
    [_customizeButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _customizeButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
    [_customizeButton addTarget:self action:@selector(customizeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _customizeButton.layer.cornerRadius  = 13.5f;
    _customizeButton.layer.masksToBounds = YES;
    [self.contentView addSubview:_customizeButton];
    [_customizeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.f);
        make.width.mas_equalTo(54.f);
        make.height.mas_equalTo(27.f);
    }];
}

- (void)setViewModel:(JHCheckCustomizeOrderListModel *)viewModel {
    self.orderListModel = viewModel;
    self.orderIdLabel.text = [NSString stringWithFormat:@"订单号：%@",viewModel.orderCode];
    NSArray *arr = [viewModel.goodsUrl componentsSeparatedByString:@","];
    if (arr.count >0) {
        [self.posterImageView jhSetImageWithURL:[NSURL URLWithString:arr[0]] placeholder:kDefaultCoverImage];
    } else {
        [self.posterImageView jhSetImageWithURL:[NSURL URLWithString:viewModel.goodsUrl] placeholder:kDefaultCoverImage];
    }
    
    if ([viewModel.materialSource isEqualToString:@"1"]) {
        self.redBorderLabel.text = @"自有";
        self.moneyLabel.text = @""; /// 自有不显示价格
        self.statusLabel.text = @""; /// 自有不显示待付款等信息
    } else {
        self.redBorderLabel.text = @"已购";
        self.statusLabel.text = [OrderMode orderStatusExt:viewModel.orderStatus isBuyer:NO];
        self.moneyLabel.attributedText = [self getPriceAttributedString:viewModel.originOrderPrice];
    }
    
    if (viewModel.connectFlag == 1) { /// 正在连麦中，背景高亮
        self.contentView.backgroundColor = HEXCOLOR(0xFFF9F5);
    } else {
        self.contentView.backgroundColor = HEXCOLOR(0xFFFFFF);
    }
    
    if (viewModel.buttonFlag == 1) {
        self.customizeButton.backgroundColor = HEXCOLOR(0xFFD70F);
    } else {
        self.customizeButton.backgroundColor = HEXCOLOR(0xEDEDED);
    }
    
    self.infoLabel.text = viewModel.goodsTitle;
    self.timeLabel.text = viewModel.orderCreateTime;
}

- (NSMutableAttributedString *)getPriceAttributedString:(NSString *)oPrice {
    float price = [oPrice floatValue];
    NSString *string = [NSString stringWithFormat:@"￥%@",PRICE_FLOAT_TO_STRING(price)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes: @{NSFontAttributeName:JHBoldFont(11), NSForegroundColorAttributeName: HEXCOLOR(0x333333)}];
    [attributedString addAttributes:@{NSFontAttributeName: JHDINBoldFont(18)} range:NSMakeRange(1, string.length-1)];
    return attributedString;
}

- (void)customizeButtonAction:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock(self.orderListModel);
    }
}

@end



@interface JHCustomizeOrderFlyListView ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UILabel            *titleLabel;
@property (nonatomic, strong) UILabel            *tipsLabel;
@property (nonatomic, strong) JHNOAllowTabelView *orderTabelView;
@property (nonatomic, strong) NSMutableArray     *dataSourceArray;
@property (nonatomic, assign) NSInteger           pageIndex;
@end

@implementation JHCustomizeOrderFlyListView
- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (instancetype)initWithCustomerId:(NSInteger)customerId {
    self = [super init];
    if (self) {
        _customerId = customerId;
        self.pageIndex = 1;
//        [self setupUI];
//        [self loadData];
    }
    return self;
}


- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)showAlert {
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f;

//    if (self.orderType == JHCustomizeUserOrderTypeIntent || self.orderType == JHCustomizeUserOrderTypeSure) {
//        [self makeUI];
//    }else if (self.orderType == JHCustomizeUserOrderTypeIntentUser || self.orderType == JHCustomizeUserOrderTypeSureUser){
//        [self makeUI_User];
//    }
    
    [self setupUI];
    [self loadDataWithHud:YES];
    @weakify(self);
    self.orderTabelView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadDataWithHud:NO];
    }];
    [super showAlert];
    [self.dataSourceArray removeAllObjects];
}

- (void)loadDataWithHud:(BOOL)showHud {
    if (showHud) {
        [SVProgressHUD show];
    }
    @weakify(self);
    [JHLiveApiManager checkUserCustomizeListPackageWithCustomerId:self.customerId pageIndex:self.pageIndex pageSize:10 Completion:^(NSError * _Nullable error, NSArray<JHCheckCustomizeOrderListModel *> * _Nullable array) {
        @strongify(self);
        if (showHud) {
            [SVProgressHUD dismiss];
        }
        if (error || array.count == 0) {
            [self.orderTabelView jh_reloadDataWithEmputyView];
            self.orderTabelView.mj_footer.hidden = YES;
            [self.orderTabelView jh_footerStatusWithNoMoreData:YES];
            return;
        }
        if (array.count >= 10) {
            self.pageIndex ++;
            [self.orderTabelView jh_footerStatusWithNoMoreData:NO];
            self.orderTabelView.mj_footer.hidden = NO;
        } else {
            [self.orderTabelView jh_footerStatusWithNoMoreData:YES];
            self.orderTabelView.mj_footer.hidden = YES;
        }
//        [self.dataSourceArray removeAllObjects];
        [self.dataSourceArray addObjectsFromArray:array];
        [self.orderTabelView reloadData];
    }];
}

- (void)setupUI {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(ScreenW - 60.f);
        make.height.mas_equalTo(537.f);
    }];
    
    _titleLabel           = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = HEXCOLOR(0x333333);
    _titleLabel.font      = [UIFont fontWithName:kFontNormal size:18.f];
    _titleLabel.text      = @"定制订单";
    [self.backView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.backView);
        make.height.mas_equalTo(54.f);
    }];
    
//    _clostBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _clostBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-15.f, -15.f, -15.f, -15.f);
//    [self.backView addSubview:_clostBtn];
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right).offset(-15.f);
        make.top.equalTo(self.backView.mas_top).offset(15.f);
        make.width.height.mas_equalTo(20.f);
    }];
    
    _tipsLabel               = [[UILabel alloc] init];
    _tipsLabel.numberOfLines = 2;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Tips：用户连麦时已选择的订单会背景高亮显示，您可以根据实际情况选择要定制的订单"];
    NSRange range1 = [[str string] rangeOfString:@"Tips：用户连麦时已选择的订单会"];
    [str addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x999999) range:range1];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontNormal size:12.f] range:range1];
    NSRange range2 = [[str string] rangeOfString:@"背景高亮"];
    [str addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xFF4200) range:range2];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontBoldPingFang size:12.f] range:range2];
    NSRange range3 = [[str string] rangeOfString:@"显示，您可以根据实际情况选择要定制的订单"];
    [str addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x999999) range:range3];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontNormal size:12.f] range:range3];
    _tipsLabel.attributedText = str;
    [self.backView addSubview:_tipsLabel];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.backView.mas_left).offset(10.f);
        make.right.equalTo(self.backView.mas_right).offset(-10.f);
        make.height.mas_equalTo(34.f);
    }];
    [self.backView addSubview:self.orderTabelView];
    [self.orderTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(10.f);
        make.left.right.bottom.equalTo(self.backView);
    }];
}

- (JHNOAllowTabelView *)orderTabelView {
    if (!_orderTabelView) {
        _orderTabelView                                = [[JHNOAllowTabelView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _orderTabelView.dataSource                     = self;
        _orderTabelView.delegate                       = self;
        _orderTabelView.separatorColor                 = [UIColor clearColor];
        _orderTabelView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _orderTabelView.estimatedRowHeight             = 10.f;
        if (@available(iOS 11.0, *)) {
            _orderTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
//            self.automaticallyAdjustsScrollViewInsets   = NO;
        }

        [_orderTabelView registerClass:[JHCustomizeOrderFlyListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustomizeOrderFlyListTableViewCell class])];

        if ([_orderTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_orderTabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_orderTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_orderTabelView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _orderTabelView;
}

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.f;
    }
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = HEXCOLOR(0xF5F6FA);
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHCustomizeOrderFlyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustomizeOrderFlyListTableViewCell class])];
    if (!cell) {
        cell = [[JHCustomizeOrderFlyListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustomizeOrderFlyListTableViewCell class])];
    }
    [cell setViewModel:self.dataSourceArray[indexPath.section]];
    @weakify(self);
    cell.clickBlock = ^(JHCheckCustomizeOrderListModel *model) {
        @strongify(self);
        if (self.cusActionBlock) {
            self.cusActionBlock(model,self);
        }
    };
    return cell;
}


@end
