//
//  JHNewStoreKillActivityTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/9/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreKillActivityTableViewCell.h"
#import "YDCountDown.h"

@interface JHNewStoreKillActivityGoodsInfoView : UIView
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *redPriceLabel;
@property (nonatomic, strong) UILabel     *grayPriceLabel;
@property (nonatomic, strong) JHNewStoreHomeKillActivityPageItemModel *itemModel;
@property (nonatomic, copy) void(^goodDidClickedBlock) (JHNewStoreHomeKillActivityPageItemModel *item);
@end

@implementation JHNewStoreKillActivityGoodsInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLOR(0xFFFFFF);
    self.backgroundColor             = HEXCOLOR(0xFFFFFF);
    self.layer.cornerRadius          = 4.f;
    self.layer.masksToBounds         = YES;
    
    _imgView                  = [UIImageView new];
    _imgView.clipsToBounds    = YES;
    _imgView.contentMode      = UIViewContentModeScaleAspectFill;
    _imgView.image            = [UIImage imageNamed:@"newStore_detail_shopProduct_Placeholder"];
    [self addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(78.f);
    }];

    _titleLabel               = [UILabel labelWithFont:[UIFont fontWithName:kFontBoldPingFang size:12.f] textColor:kColor333];
    _titleLabel.numberOfLines = 1;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(3.f);
        make.left.equalTo(self.mas_left).offset(3.f);
        make.right.equalTo(self.mas_right).offset(-2.f);
        make.height.mas_equalTo(17.f);
    }];

    _redPriceLabel            = [[UILabel alloc] init];
    _redPriceLabel.textColor  = HEXCOLOR(0xF23730);
    _redPriceLabel.font       = [UIFont fontWithName:kFontBoldDIN size:10.f];
    [self addSubview:_redPriceLabel];
    [_redPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.titleLabel.mas_left);
        make.height.mas_equalTo(16.f);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-4.f);
    }];

    _grayPriceLabel           = [[UILabel alloc] init];
    _grayPriceLabel.textColor = HEXCOLOR(0x999999);
    _grayPriceLabel.font      = [UIFont fontWithName:kFontBoldDIN size:9.f];
    [self addSubview:_grayPriceLabel];
    [_grayPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.redPriceLabel.mas_bottom);
        make.left.equalTo(self.redPriceLabel.mas_right).offset(1.f);
        make.height.mas_equalTo(14.f);
    }];
    
    UIView *lineGrayView = [[UIView alloc] init];
    lineGrayView.backgroundColor = HEXCOLOR(0x999999);
    [_grayPriceLabel addSubview:lineGrayView];
    [lineGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.grayPriceLabel.mas_centerY);
        make.left.right.equalTo(self.grayPriceLabel);
        make.height.mas_equalTo(1.f);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productDidClicked)];
    [self addGestureRecognizer:tap];
}

- (void)productDidClicked {
    if (self.goodDidClickedBlock) {
        self.goodDidClickedBlock(self.itemModel);
    }
}

- (void)setViewModel:(JHNewStoreHomeKillActivityPageItemModel *)viewModel {
    _itemModel = viewModel;
    [self.imgView jhSetImageWithURL:[NSURL URLWithString:viewModel.mainImageUrl.middleUrl] placeholder:[UIImage imageNamed:@"newStore_detail_shopProduct_Placeholder"]];
    self.titleLabel.text = NONNULL_STR(viewModel.productName);
    
    NSString *newPriceStrRed  = [NSString stringWithFormat:@"￥%@",viewModel.productSeckillPrice];
    NSString *newPriceStrGray = [NSString stringWithFormat:@"￥%@",viewModel.productOriginalPrice];
    CGSize size1 = [self calculationTextWidthWith:newPriceStrRed font:[UIFont fontWithName:kFontBoldDIN size:10.f]];
    CGSize size2 = [self calculationTextWidthWith:newPriceStrGray font:[UIFont fontWithName:kFontNormal size:9.f]];

    if (size1.width+size2.width > [self cellWidth]) {
        self.grayPriceLabel.hidden = YES;
    } else {
        self.grayPriceLabel.hidden = NO;
    }
    self.redPriceLabel.text  = [NSString stringWithFormat:@"￥%@",NONNULL_STR(viewModel.productSeckillPrice)];
    self.grayPriceLabel.text = [NSString stringWithFormat:@"￥%@",NONNULL_STR(viewModel.productOriginalPrice)];
}

- (CGSize)calculationTextWidthWith:(NSString *)string font:(UIFont *)font {
    CGSize width = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return width;
}

- (CGFloat)cellWidth {
    return (ScreenW - 18.f*2 - 6.f*3)/4.f - 5.f;
}

@end



@interface JHNewStoreKillActivityGoodsInfoTableViewCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray   *viewArray;
@property (nonatomic, copy) void(^cellGoodDidClickedBlock) (JHNewStoreHomeKillActivityPageItemModel *item);
- (void)setViewModel:(NSArray <JHNewStoreHomeKillActivityPageItemModel *>*)viewModel;
@end

@implementation JHNewStoreKillActivityGoodsInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)viewArray {
    if (!_viewArray) {
        _viewArray = [[NSMutableArray alloc] init];
    }
    return _viewArray;
}


- (void)setupViews {
    CGFloat left  = 0.f;
    CGFloat space = 6.f;
    CGFloat width = (ScreenW - 18.f*2 - 6.f*3)/4.f;
    for (int i = 0; i < 4; i++) {
        JHNewStoreKillActivityGoodsInfoView *view = [[JHNewStoreKillActivityGoodsInfoView alloc] init];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(left + (width + space)*i);
            make.top.equalTo(self.contentView.mas_top);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(118.2f);
        }];
        [self.viewArray addObject:view];
        @weakify(self);
        view.goodDidClickedBlock = ^(JHNewStoreHomeKillActivityPageItemModel *item) {
            @strongify(self);
            if (self.cellGoodDidClickedBlock) {
                self.cellGoodDidClickedBlock(item);
            }
        };
    }
}

- (void)setViewModel:(NSArray <JHNewStoreHomeKillActivityPageItemModel *>*)viewModel {
    for (int i = 0; i< self.viewArray.count; i++) {
        JHNewStoreKillActivityGoodsInfoView *view = self.viewArray[i];
        if (viewModel[i]) {
            view.hidden = NO;
            [view setViewModel:viewModel[i]];
        } else {
            view.hidden = YES;
        }
    }
}

@end



@interface JHNewStoreKillActivityTableViewCell ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UIView                          *backView;
@property (nonatomic, strong) UIImageView                     *titleImageView;
@property (nonatomic, strong) UIView                          *countDownView;
@property (nonatomic, strong) UILabel                         *countDownNameLabel;
@property (nonatomic, strong) UILabel                         *countDownValueLabel;
@property (nonatomic, strong) UIButton                        *moreButton;
@property (nonatomic, strong) UIImageView                     *moreButtonImageView;
@property (nonatomic, strong) UITableView                     *killGoodTabelView;
@property (nonatomic, strong) NSMutableArray                  *dataArray;
@property (nonatomic, strong) JHNewStoreHomeKillActivityModel *killViewModel;
@property (nonatomic, strong) NSTimer                         *scrolTimer;
@property (nonatomic, assign) BOOL                             hasScrol;
@property (nonatomic, strong) YDCountDown                     *countDown;
@property (nonatomic, assign) BOOL                             needMinus;
@end

@implementation JHNewStoreKillActivityTableViewCell

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_countDown) {
            _countDown = [[YDCountDown alloc] init];
        }
        _hasScrol = NO;
        _needMinus = NO;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = HEXCOLOR(0xFFE9E0);
    _backView.layer.cornerRadius = 8.f;
    _backView.layer.masksToBounds = YES;
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.right.equalTo(self.contentView.mas_left).offset(-10.f);
//        make.height.mas_equalTo(170.f);
        make.width.mas_equalTo(ScreenW - 20.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.f);
    }];
    
    _titleImageView = [[UIImageView alloc] init];
    _titleImageView.image = [UIImage imageNamed:@"jh_newStore_home_killActivity"];
    _titleImageView.userInteractionEnabled = YES;
    [_backView addSubview:_titleImageView];
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top).offset(13.f);
        make.left.equalTo(self.backView.mas_left).offset(8.f);
        make.width.mas_equalTo(63.f);
        make.height.mas_equalTo(17.f);
    }];
    UITapGestureRecognizer *tapTitle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleDidClicked)];
    [_titleImageView addGestureRecognizer:tapTitle];

        
    _countDownView = [[UIView alloc] init];
    _countDownView.layer.cornerRadius = 2.f;
    _countDownView.layer.masksToBounds = YES;
    _countDownView.userInteractionEnabled = YES;
    [_backView addSubview:_countDownView];
    [_countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleImageView.mas_centerY);
        make.left.equalTo(self.titleImageView.mas_right).offset(9.f);
        make.width.mas_equalTo(86.f);
        make.height.mas_equalTo(17.f);
    }];
    UITapGestureRecognizer *tapCount0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(countDownDidClicked)];
    [_countDownView addGestureRecognizer:tapCount0];

    
    _countDownNameLabel                 = [[UILabel alloc] init];
    _countDownNameLabel.textColor       = HEXCOLOR(0xFFFFFF);
    _countDownNameLabel.textAlignment   = NSTextAlignmentLeft;
    _countDownNameLabel.font            = [UIFont fontWithName:kFontMedium size:10.f];
    _countDownNameLabel.backgroundColor = HEXCOLOR(0xF03D37);
    _countDownNameLabel.userInteractionEnabled = YES;
    [_countDownView addSubview:_countDownNameLabel];
    [_countDownNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.countDownView);
        make.width.mas_equalTo(36.5f);
    }];
    UITapGestureRecognizer *tapCount1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(countDownDidClicked)];
    [_countDownNameLabel addGestureRecognizer:tapCount1];
    
    _countDownValueLabel                 = [[UILabel alloc] init];
    _countDownValueLabel.textColor       = HEXCOLOR(0xF03D37);
    _countDownValueLabel.textAlignment   = NSTextAlignmentLeft;
    _countDownValueLabel.font            = [UIFont fontWithName:kFontMedium size:10.f];
//    _countDownValueLabel.text            = @" 01:25:24";
    _countDownValueLabel.backgroundColor = HEXCOLOR(0xFFFFFF);
    _countDownValueLabel.userInteractionEnabled = YES;
    [_countDownView addSubview:_countDownValueLabel];
    [_countDownValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.countDownView);
        make.left.equalTo(self.countDownNameLabel.mas_right);
        make.right.equalTo(self.countDownView.mas_right);
    }];
    UITapGestureRecognizer *tapCount2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(countDownDidClicked)];
    [_countDownValueLabel addGestureRecognizer:tapCount2];
    
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreButton setTitle:@"更多秒杀" forState:UIControlStateNormal];
    [_moreButton setTitleColor:HEXCOLOR(0xFC3130) forState:UIControlStateNormal];
    _moreButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:11.f];
    _moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_moreButton addTarget:self action:@selector(moreButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_moreButton];
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleImageView.mas_centerY);
        make.right.equalTo(self.backView.mas_right).offset(-24.f);
        make.width.mas_equalTo(44.f);
        make.height.mas_equalTo(16.f);
    }];
    
    _moreButtonImageView = [[UIImageView alloc] init];
    _moreButtonImageView.image = [UIImage imageNamed:@"jh_newStore_killMore"];
    _moreButtonImageView.userInteractionEnabled = YES;
    [_backView addSubview:_moreButtonImageView];
    [_moreButtonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moreButton.mas_centerY);
        make.left.equalTo(self.moreButton.mas_right).offset(3.f);
        make.width.mas_equalTo(11.f);
        make.height.mas_equalTo(12.f);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreButtonDidClicked)];
    [_moreButtonImageView addGestureRecognizer:tap];
    
    [_backView addSubview:self.killGoodTabelView];
    [self.killGoodTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleImageView.mas_bottom).offset(12.f);
        make.left.equalTo(self.backView.mas_left).offset(8.f);
        make.right.equalTo(self.backView.mas_right).offset(-8.f);
        make.height.mas_equalTo(120.f);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-10.f);
    }];
    
    self.scrolTimer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.scrolTimer forMode:NSRunLoopCommonModes];
}

- (UITableView *)killGoodTabelView {
    if (!_killGoodTabelView) {
        _killGoodTabelView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _killGoodTabelView.dataSource                     = self;
        _killGoodTabelView.delegate                       = self;
        _killGoodTabelView.backgroundColor                = [UIColor clearColor];
        _killGoodTabelView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _killGoodTabelView.estimatedRowHeight             = 120.f;
        _killGoodTabelView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _killGoodTabelView.estimatedSectionHeaderHeight   = 0.1f;
            _killGoodTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_killGoodTabelView registerClass:[JHNewStoreKillActivityGoodsInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHNewStoreKillActivityGoodsInfoTableViewCell class])];

        if ([_killGoodTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_killGoodTabelView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([_killGoodTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_killGoodTabelView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
    return _killGoodTabelView;
}

- (void)timeFireMethod {
    [self.dataArray removeAllObjects];
    if (!self.hasScrol) {
        if (self.killViewModel.productPageResult.count >4) {
            NSArray *arr = [self.killViewModel.productPageResult subarrayWithRange:NSMakeRange(0, 4)];
            [self.dataArray addObjectsFromArray:arr];
        } else {
            if (self.killViewModel.productPageResult.count != 0) {
                [self.dataArray addObjectsFromArray:self.killViewModel.productPageResult];
            }
        }
        self.hasScrol = YES;
    } else {
        if (self.killViewModel.productPageResult.count >=8) {
            NSArray *arr = [self.killViewModel.productPageResult subarrayWithRange:NSMakeRange(4, 4)];
            [self.dataArray addObjectsFromArray:arr];
        } else {
            if (self.killViewModel.productPageResult.count >4) {
                NSArray *arr = [self.killViewModel.productPageResult subarrayWithRange:NSMakeRange(4, self.killViewModel.productPageResult.count - 4)];
                [self.dataArray addObjectsFromArray:arr];
            }
        }
        self.hasScrol = NO;
    }
    [self.killGoodTabelView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationTop];
}

- (void)titleDidClicked {
    if (self.updateKillActivityCell) {
        self.updateKillActivityCell(0, @"");
    }
}

- (void)countDownDidClicked {
    if (self.updateKillActivityCell) {
        self.updateKillActivityCell(1, @"");
    }
}

- (void)moreButtonDidClicked {
    if (self.updateKillActivityCell) {
        self.updateKillActivityCell(3, @"");
    }
}

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHNewStoreKillActivityGoodsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHNewStoreKillActivityGoodsInfoTableViewCell class])];
    if (!cell) {
        cell = [[JHNewStoreKillActivityGoodsInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHNewStoreKillActivityGoodsInfoTableViewCell class])];
    }
    [cell setViewModel:self.dataArray];
    @weakify(self);
    cell.cellGoodDidClickedBlock = ^(JHNewStoreHomeKillActivityPageItemModel *item) {
        @strongify(self);
        if (self.updateKillActivityCell) {
            self.updateKillActivityCell(2, NONNULL_STR(item.productId));
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.updateKillActivityCell) {
        self.updateKillActivityCell(999, @"");
    }
}

#pragma mark - viewModel
- (void)setViewModel:(JHNewStoreHomeKillActivityModel *)viewModel {
    self.killViewModel = viewModel;
    [self.countDown destoryTimer];
    self.needMinus = NO;
    
    self.countDownNameLabel.text  = [NSString stringWithFormat:@" %@",NONNULL_STR(viewModel.seckillCountdownDesc)];
    self.countDownValueLabel.text = @"";
        
    if (viewModel.seckillCountdown >1000) {
        [self countDownInfo:viewModel.seckillCountdown/1000];
    } else {
        self.countDownValueLabel.hidden = YES;
        @weakify(self);
        [JHDispatch after:1 execute:^{
            @strongify(self);
            [self.countDown destoryTimer];
            [self endingStatus];
        }];
    }
    
    [self.dataArray removeAllObjects];
    if (viewModel.productPageResult.count >4) {
        NSArray *arr = [viewModel.productPageResult subarrayWithRange:NSMakeRange(0, 4)];
        [self.dataArray addObjectsFromArray:arr];
    } else {
        [self.dataArray addObjectsFromArray:viewModel.productPageResult];
    }
    self.hasScrol = YES;
    [self.killGoodTabelView reloadData];
}


- (void)countDownInfo:(long)duration {
    @weakify(self);
    [self.countDown startWithFinishTimeStamp:duration completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        @strongify(self);
        self.countDownValueLabel.hidden = NO;
        self.countDownValueLabel.text = [NSString stringWithFormat:@" %02ld:%02ld:%02ld",(long)hour,(long)minute,(long)second];
        if (!self.needMinus) {
            self.needMinus = YES;
        } else {
            self.killViewModel.seckillCountdown = self.killViewModel.seckillCountdown - 1000;
        }
        if (day == 0 && hour==0 && minute == 0 && second == 0) {
            ///停止定时器
            self.countDownValueLabel.hidden = YES;
            [self.countDown destoryTimer];
            [self endingStatus];
        }
        [self setNeedsLayout];
    }];
}

- (UITableView *)tableView {
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

- (void)endingStatus {
    UITableViewCell *cell = (UITableViewCell *)[[self.backView superview] superview];
    NSIndexPath     *path = [[self tableView] indexPathForCell:cell];
    if (path) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWSTOREREREFRESHKILLACTIVITYCELL" object:path];
    }
}

@end
