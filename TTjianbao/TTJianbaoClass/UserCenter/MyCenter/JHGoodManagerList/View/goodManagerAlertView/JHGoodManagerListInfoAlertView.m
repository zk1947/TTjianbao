//
//  JHGoodManagerListInfoAlertView.m
//  TTjianbao
//
//  Created by user on 2021/8/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerListInfoAlertView.h"
#import "UIView+JHGradient.h"
#import "JHGoodManagerListAlertInputTableViewCell.h"
#import "JHGoodManagerListAlertTimeChooseTableViewCell.h"
#import "JHGoodManagerListAlertDurationTableViewCell.h"
#import "JHGoodManagerSingleton.h"
#import "JHBusinessPubishNomalModel.h"
#import "UIButton+LXExpandBtn.h"

@interface JHGoodManagerListInfoAlertView ()<
UITableViewDelegate,
UITableViewDataSource>
{
    UIView *showview;
}
@property (nonatomic, strong) UILabel                    *title;
@property (nonatomic, strong) UIButton                   *sureBtn;
@property (nonatomic, strong) UIButton                   *closeButton;
@property (nonatomic, strong) UIButton                   *cancleBtn;
@property (nonatomic, strong) UIView                     *lineView;
@property (nonatomic, strong) UITableView                *goodTableView;
@property (nonatomic, strong) NSMutableArray             *dataArray;
@property (nonatomic, strong) JHGoodManagerListModel     *itemModel;
@property (nonatomic, strong) JHBusinessPubishNomalModel *showModel;
@end

@implementation JHGoodManagerListInfoAlertView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithTitle:(NSString *)title
               cancleBtnTitle:(NSString *)cancleTitle
                 sureBtnTitle:(NSString *)completeTitle
                    itemModel:(JHGoodManagerListModel *)itemModel {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        [self resetStatus];
        self.backgroundColor = [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        self.itemModel = itemModel;
        [self setupViews:title cancleBtnTitle:cancleTitle sureBtnTitle:completeTitle];
        [self addCloseBtn];
    }
    return self;
}

- (void)resetStatus {
    [JHGoodManagerSingleton shared].startAuctionPrice = @"";
    [JHGoodManagerSingleton shared].addAuctionPrice = @"";
    [JHGoodManagerSingleton shared].sureMoney = @"";
    [JHGoodManagerSingleton shared].putOnType = @"0";
    [JHGoodManagerSingleton shared].auctionDuration = @"";
    [JHGoodManagerSingleton shared].auctionStartTime = @"";
}


- (void)setupViews:(NSString *)title
    cancleBtnTitle:(NSString *)cancleTitle
      sureBtnTitle:(NSString *)completeTitle {
    showview                        = [[UIView alloc]init];
    showview.center                 = self.center;
    showview.contentMode            = UIViewContentModeScaleAspectFit;
    showview.userInteractionEnabled = YES;
    showview.layer.cornerRadius     = 8;
    showview.backgroundColor        = HEXCOLOR(0xFFFFFF);
    [self addSubview:showview];
    [showview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@260);
        make.center.equalTo(self);
    }];
    
    UIView *titleBack = [[UIView alloc]init];
    [showview addSubview:titleBack];
    [titleBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showview).offset(20);
        make.centerX.equalTo(showview);
        if (title.length<=0) {
            make.height.offset(0);
        } else {
            make.height.offset(30);
        }
    }];
    
    _title               = [[UILabel alloc]init];
    _title.text          = title;
    _title.font          = [UIFont fontWithName:kFontMedium size:15.f];
    _title.textColor     = HEXCOLOR(0x333333);
    _title.numberOfLines = 1;
    _title.textAlignment = NSTextAlignmentCenter;
    _title.lineBreakMode = NSLineBreakByWordWrapping;
    [titleBack addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleBack);
        make.centerX.equalTo(titleBack);
    }];
    
    /// 横划线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = HEXCOLOR(0xEDEDED);
    [showview addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(10.f);
        make.left.equalTo(showview.mas_left);
        make.right.equalTo(showview.mas_right);
        make.height.mas_equalTo(0.5f);
    }];
    
    [showview addSubview:self.goodTableView];
    [self.goodTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.equalTo(showview.mas_left);
        make.right.equalTo(showview.mas_right);
        make.height.mas_equalTo(250.f);
    }];

    _cancleBtn                    = [[UIButton alloc]init];
    _cancleBtn.contentMode        = UIViewContentModeScaleAspectFit;
    _cancleBtn.titleLabel.font    = [UIFont fontWithName:kFontNormal size:15.f];
    _cancleBtn.backgroundColor    = HEXCOLOR(0xFFFFFF);
    _cancleBtn.layer.cornerRadius = 20.f;
    _cancleBtn.layer.borderColor  = HEXCOLOR(0xBDBFC2).CGColor;
    _cancleBtn.layer.borderWidth  = 0.5f;
    [_cancleBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [showview addSubview:_cancleBtn];
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodTableView.mas_bottom).offset(20.f);
        make.bottom.equalTo(showview.mas_bottom).offset(-15.f);
        make.left.offset(25.f);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    _sureBtn                     = [[UIButton alloc]init];
    _sureBtn.contentMode         = UIViewContentModeScaleAspectFit;
    [_sureBtn setTitle:completeTitle forState:UIControlStateNormal];
    [_sureBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    _sureBtn.titleLabel.font     = [UIFont fontWithName:kFontNormal size:15.f];
    [_sureBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn.layer.cornerRadius  = 20.f;
    _sureBtn.layer.masksToBounds = YES;
    [showview addSubview:_sureBtn];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cancleBtn);
        make.bottom.equalTo(showview.mas_bottom).offset(-15.f);
        make.right.offset(-25.f);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    [self dataShow];
}

#pragma mark -
- (UITableView *)goodTableView {
    if (!_goodTableView) {
        _goodTableView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _goodTableView.dataSource                     = self;
        _goodTableView.delegate                       = self;
        _goodTableView.backgroundColor                = HEXCOLOR(0xFFFFFF);
        _goodTableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _goodTableView.estimatedRowHeight             = 10.f;
        
        _goodTableView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _goodTableView.estimatedSectionHeaderHeight   = 0.1f;
            _goodTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_goodTableView registerClass:[JHGoodManagerListAlertInputTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHGoodManagerListAlertInputTableViewCell class])];
        
        [_goodTableView registerClass:[JHGoodManagerListAlertTimeChooseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHGoodManagerListAlertTimeChooseTableViewCell class])];
        
        [_goodTableView registerClass:[JHGoodManagerListAlertDurationTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHGoodManagerListAlertDurationTableViewCell class])];
                
        if ([_goodTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_goodTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _goodTableView;
}


- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.goodTableView reloadData];
}

- (void)addCloseBtn {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"jhGoodManagerList_close"] forState:UIControlStateNormal ];
    closeButton.contentMode = UIViewContentModeScaleAspectFit;
    [closeButton addTarget:self action:@selector(HideMicPopView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.hitTestEdgeInsets = UIEdgeInsetsMake(-15.f, -15.f, -15.f, -15.f);
    [showview addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title.mas_centerY);
        make.right.equalTo(showview).offset(-15.f);
        make.size.mas_equalTo(CGSizeMake(12, 11));
    }];
}


- (void)addBackGroundTap {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HideMicPopView)]];
}

- (void)cancel {
    if (self.cancleHandle) {
        self.cancleHandle();
    }
    [self HideMicPopView];
}

- (void)complete {
    if (self.handle) {
        self.handle();
    }
    [self HideMicPopView];
}

- (void)close {
    if (self.closeBlock) {
        self.closeBlock();
    }
    [self HideMicPopView];
}

- (void)HideMicPopView {
    [self removeFromSuperview];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}


#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <3) {
        JHGoodManagerListAlertInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHGoodManagerListAlertInputTableViewCell class])];
        if (!cell) {
            cell = [[JHGoodManagerListAlertInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHGoodManagerListAlertInputTableViewCell class])];
        }
        [cell setViewModel:self.dataArray[indexPath.row]];
        return cell;
    } else if (indexPath.row == 3) {
        JHGoodManagerListAlertTimeChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHGoodManagerListAlertTimeChooseTableViewCell class])];
        if (!cell) {
            cell = [[JHGoodManagerListAlertTimeChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHGoodManagerListAlertTimeChooseTableViewCell class])];
        }
        [cell setViewModel:self.dataArray[indexPath.row]];
        @weakify(self);
        cell.putOnNowBlock = ^{
            @strongify(self);
            [self refreshDataArray];
            NSDictionary *dict3 = @{
                @"num":@(3),
                @"name":@"商品发布",
                @"placeholder":@"立即上架",
                @"value":@"",
            };
            [self.dataArray addObject:dict3];
            
            
            NSDictionary *dict4 = @{
                @"num":@(4),
                @"name":@"持续时间",
                @"placeholder":@"请选择上拍时间",
                @"value":@"",
            };
            [self.dataArray addObject:dict4];
            
            [self.goodTableView reloadData];
            [self.goodTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(250.f);
            }];

        };
        cell.putOnwithTimeBlock = ^{
            @strongify(self);
            [self refreshDataArray];
            NSDictionary *dict3 = @{
                @"num":@(3),
                @"name":@"商品发布",
                @"placeholder":@"指定时间上架",
                @"value":@"",
            };
            [self.dataArray addObject:dict3];
            
            
            NSDictionary *dict4 = @{
                @"num":@(4),
                @"name":@"开始时间",
                @"placeholder":@"请选择上拍时间",
                @"value":@"",
            };
            [self.dataArray addObject:dict4];
            
            NSDictionary *dict5 = @{
                @"num":@(5),
                @"name":@"持续时间",
                @"placeholder":@"请选择上拍时间",
                @"value":@"",
            };
            [self.dataArray addObject:dict5];
            
            [self.goodTableView reloadData];
            [self.goodTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(300.f);
            }];

        };
        return cell;
    } else {
        JHGoodManagerListAlertDurationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHGoodManagerListAlertDurationTableViewCell class])];
        if (!cell) {
            cell = [[JHGoodManagerListAlertDurationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHGoodManagerListAlertDurationTableViewCell class])];
        }
        [cell setViewModel:self.dataArray[indexPath.row]];
        cell.pubishModel = self.showModel;
        return cell;
    }
}

- (void)loadData:(JHBusinessPubishNomalModel *)model {
    NSDictionary *dict0 = @{
        @"num":@(0),
        @"name":@"起拍价",
        @"placeholder":@"请输入最低成交价",
        @"value":NONNULL_STR(self.itemModel.startPriceYuan)
    };
    [self.dataArray addObject:dict0];
    
    NSDictionary *dict1 = @{
        @"num":@(1),
        @"name":@"加价幅度",
        @"placeholder":@"请输入加价幅度",
        @"value":NONNULL_STR(self.itemModel.bidIncrementYuan)
    };
    [self.dataArray addObject:dict1];
    
    NSDictionary *dict2 = @{
        @"num":@(2),
        @"name":@"保证金",
        @"placeholder":@"请输入保证金金额",
        @"value":NONNULL_STR(self.itemModel.earnestMoneyYuan)
    };
    [self.dataArray addObject:dict2];
    
    NSDictionary *dict3 = @{
        @"num":@(3),
        @"name":@"商品发布",
        @"placeholder":@"立即上架",
        @"value":@"",
    };
    [self.dataArray addObject:dict3];
    
    
    NSDictionary *dict4 = @{
        @"num":@(4),
        @"name":@"持续时间",
        @"placeholder":@"请选择上拍时间",
        @"value":@"",
    };
    [self.dataArray addObject:dict4];

    [self.goodTableView reloadData];
}


- (void)refreshDataArray {
    [self.dataArray removeAllObjects];

    NSDictionary *dict0 = @{
        @"num":@(0),
        @"name":@"起拍价",
        @"placeholder":@"请输入最低成交价",
        @"value":NONNULL_STR([JHGoodManagerSingleton shared].startAuctionPrice)
    };
    [self.dataArray addObject:dict0];
    
    NSDictionary *dict1 = @{
        @"num":@(1),
        @"name":@"加价幅度",
        @"placeholder":@"请输入加价幅度",
        @"value":NONNULL_STR([JHGoodManagerSingleton shared].addAuctionPrice)
    };
    [self.dataArray addObject:dict1];
    
    NSDictionary *dict2 = @{
        @"num":@(2),
        @"name":@"保证金",
        @"placeholder":@"请输入保证金金额",
        @"value":NONNULL_STR([JHGoodManagerSingleton shared].sureMoney)
    };
    [self.dataArray addObject:dict2];
}



- (void)dataShow {
    [SVProgressHUD show];
    @weakify(self);
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/getPublishInfo") Parameters:@{@"businessLineType":@"MALL"} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self);
        [SVProgressHUD dismiss];
        JHBusinessPubishNomalModel *backModel = [JHBusinessPubishNomalModel mj_objectWithKeyValues:respondObject.data];
        self.showModel = backModel;
        [self loadData:backModel];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
//        @strongify(self);
        [SVProgressHUD dismiss];
    }];
    
}

@end
