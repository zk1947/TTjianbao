//
//  JHGoodsDetailPriceCell.m
//  TTjianbao
//
//  Created by lihui on 2020/3/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGoodsDetailPriceCell.h"
#import "UIView+CornerRadius.h"
#import "YDCountDownManager.h"
#import "YDCountDownView.h"
#import "TTjianbao.h"
#import "YDCountDown.h"
#import "JHStoreHelp.h"


NSString *const GoodsDetailTimerSource = @"GoodsDetailTimerSource";
NSString *const GoodsDetailPreTimerSource = @"GoodsDetailPreTimerSource";


@interface JHGoodsDetailPriceCell ()

@property (nonatomic, strong) UIView *priceContainer; //价格信息背景
@property (nonatomic, strong) UILabel *saleTagLabel; //限时购标签
@property (nonatomic, strong) UILabel *curPriceLabel; //商品当前价格(平台价)
@property (nonatomic, strong) UILabel *oriPriceLabel; //原价
@property (nonatomic, strong) UILabel *discountLabel; //打几折

///2.5新增
@property (nonatomic, strong) UILabel *goodsSaleTipLabel; //倒计时背景
@property (nonatomic, strong) YDCountDownView *countDownView; //倒计时视图
@property (nonatomic, strong) YDCountDown *countDown;


@property (nonatomic, strong) RACSignal *signal;
@property (nonatomic, copy) NSString *offlineTimeStr;


@end

@implementation JHGoodsDetailPriceCell

+ (CGFloat)cellHeight {
    return 48.0;
}

- (void)dealloc {
    NSLog(@"秒杀价格标签被释放！！！！！");
    ///退出界面需要销毁定时器
    [self.countDown destoryTimer];
    
//    [kCountDownManager removeTimerSourceWithId:GoodsDetailTimerSource];
//    [kCountDownManager removeTimerSourceWithId:GoodsDetailPreTimerSource];
//    [_signal subscribeCompleted:^{
//        NSLog(@"JHGoodsDetailHeaderPricePanel::通知被移除");
//    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        if (!_countDown) {
            _countDown = [[YDCountDown alloc] init];
        }
        [self configUI];
        
//        [self __addCountDownObserver];
        
        // 启动倒计时管理
//        [kCountDownManager startTimer];
//        [kCountDownManager addTimerSourceWithId:GoodsDetailPreTimerSource];  ///秒杀未开始的source
//        [kCountDownManager addTimerSourceWithId:GoodsDetailTimerSource];
    }
    return self;
}

- (instancetype)initWithOfflineTime:(NSString *)offlineTime {
    self = [super init];
    if (self) {
        _offlineTimeStr = offlineTime;
        [self configUI];
        
//        [self __addCountDownObserver];
        
        // 启动倒计时管理
//        [kCountDownManager startTimer];
//        [kCountDownManager addTimerSourceWithId:[NSString stringWithFormat:@"%@_%@", GoodsDetailTimerSource, _offlineTimeStr]];

    }
    return self;
}

- (void)configUI {
    
    //价格背景视图
    _priceContainer = [UIView new];
    _priceContainer.backgroundColor = [UIColor colorWithHexString:@"FF4200"];
    
    _saleTagLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:10] textColor:_priceContainer.backgroundColor];
    _saleTagLabel.backgroundColor = [UIColor whiteColor];
    _saleTagLabel.textAlignment = NSTextAlignmentCenter;
    [_priceContainer addSubview:_saleTagLabel];
    
    _curPriceLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontBoldDIN size:24] textColor:[UIColor whiteColor]];
    [_priceContainer addSubview:_curPriceLabel];
    
    _oriPriceLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12] textColor:[UIColor whiteColor]];
    [_priceContainer addSubview:_oriPriceLabel];
    
    _discountLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12] textColor:[UIColor whiteColor]];
    _discountLabel.textAlignment = NSTextAlignmentCenter;
    _discountLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _discountLabel.layer.borderWidth = 1.f;
    [_priceContainer addSubview:_discountLabel];
    
    //倒计时背景
    if (!_goodsSaleTipLabel) {
        _goodsSaleTipLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12] textColor:[UIColor blackColor]];
        _goodsSaleTipLabel.text = @"";
        _goodsSaleTipLabel.backgroundColor = kColorMain;
        _goodsSaleTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    //倒计时视图
    if (!_countDownView) {
        YDCountDownConfig *config = [[YDCountDownConfig alloc] init];
        _countDownView = [YDCountDownView countDownWithConfig:config endBlock:^{}];
    }
    
    [self.contentView sd_addSubviews:@[_priceContainer, _goodsSaleTipLabel, _countDownView]];
    
    //布局
    //倒计时视图
    _countDownView.sd_layout
    .topSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 10)
    .bottomSpaceToView(self.contentView, 0);
    
    _goodsSaleTipLabel.sd_layout
    .topSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0);
    
    //背景
    _priceContainer.sd_layout
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightSpaceToView(_goodsSaleTipLabel, 0);
    
    ///限时购标签
    _saleTagLabel.sd_layout
    .leftSpaceToView(_priceContainer, 15)
    .centerYEqualToView(_priceContainer)
    .widthIs(40)
    .heightIs(18);
    _saleTagLabel.sd_cornerRadiusFromHeightRatio = @(0.5);
    
    //价格
    _curPriceLabel.sd_layout
    .leftSpaceToView(_saleTagLabel, 5)
    .centerYEqualToView(_priceContainer);
    //.heightIs(45);
    _curPriceLabel.fixedHeight = @(45.0);
    
    _oriPriceLabel.sd_layout
    .leftSpaceToView(_curPriceLabel, 6)
    .centerYEqualToView(_priceContainer)
    .heightIs(45);
    
    _discountLabel.sd_layout
    .leftSpaceToView(_oriPriceLabel, 6)
    .centerYEqualToView(_oriPriceLabel)
    .heightIs(13);
    _discountLabel.sd_cornerRadius = @(2);
    
    _curPriceLabel.isAttributedContent = YES;
    [_curPriceLabel setSingleLineAutoResizeWithMaxWidth:120];
    [_oriPriceLabel setSingleLineAutoResizeWithMaxWidth:100];
}

- (void)setGoodsInfo:(CGoodsInfo *)goodsInfo {
    _goodsInfo = goodsInfo;
        
    //限时购标签
    _saleTagLabel.text = goodsInfo.flash_sale_tag;
    
    //_curPriceLabel.text = goodsInfo.market_price; //当前市场价
    [JHStoreHelp setPrice:goodsInfo.market_price prefixFont:[UIFont fontWithName:kFontBoldDIN size:16] prefixColor:[UIColor whiteColor] forLabel:_curPriceLabel];
    
    [self __setOrigPriceStr:goodsInfo.orig_price isNotSale:NO]; //原价 带删除线
    _discountLabel.text = goodsInfo.discount; //折扣

    //判断是否存在限时购标签，更新布局
    _saleTagLabel.hidden = ![goodsInfo.flash_sale_tag isNotBlank];
    if ([goodsInfo.flash_sale_tag isNotBlank]) {
        _saleTagLabel.sd_layout.leftSpaceToView(_priceContainer, 15);
        _curPriceLabel.sd_layout.leftSpaceToView(_saleTagLabel, 5);
    } else {
        _curPriceLabel.sd_layout.leftSpaceToView(_priceContainer, 15);
    }
    [_curPriceLabel updateLayout];
    _curPriceLabel.sd_layout.centerYEqualToView(_priceContainer); //必须设置，不然位置不对！
    
    CGFloat discountWidth = ceilf([_goodsInfo.discount getWidthWithFont:_discountLabel.font
                                                      constrainedToSize:CGSizeMake(100, 13)]);
    _discountLabel.sd_resetLayout
    .leftSpaceToView(_oriPriceLabel, 6)
    .centerYEqualToView(_oriPriceLabel)
    .widthIs(discountWidth + 5)
    .heightIs(13);
    [_discountLabel updateLayout];
    
    //倒计时相关
    [self handleCountDownEvent];
}

//倒计时相关 - 设置倒计时数据
- (void)handleCountDownEvent {
    //非特卖商品
    if (_goodsInfo.sell_type == 0) {
        //普通商品类型 || 不是已上架商品
        [self resetGoodPriceLayouts];
        return;
    }
    
    /// --------------- 下面是特卖商品的逻辑  ----------------------
    
    if (_goodsInfo.sell_type && (_goodsInfo.status == JHGoodsStatusSelled ||
    _goodsInfo.status == JHGoodsStatusSellEnd)) {
        ///已结缘 已售出商品
        [self setSeckillEndLayouts];
        return;
    }
    
    _goodsSaleTipLabel.text = [_goodsInfo.flash_sale_tips isNotBlank] ? _goodsInfo.flash_sale_tips:@"";
    ///秒杀开始时间 > 当前服务器时间：秒杀开始时间比当前服务器时间晚  秒杀未开始
    NSInteger seckillStartTime = _goodsInfo.online_at.integerValue;
    NSString *endTimeString = [CommHelp stringWithTimeInterval:@(seckillStartTime*1000).stringValue formatter:@"yyyy-MM-dd HH:mm:ss"];
    int second = [CommHelp dateRemaining:endTimeString];

    ///秒杀未开始 需要展示未开抢的UI并且倒计时
    if (second > 0) {
        _countDownView.hidden = YES;
        @weakify(self);
        [_countDown startWithFinishTimeStamp:second completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
            @strongify(self);
            [self.countDownView setDD:day hh:hour mm:minute ss:second];
            if (self.goodsSaleTipLabel) {
                self.goodsSaleTipLabel.sd_layout.widthIs(self.countDownView.width_sd + 20);
                [self.goodsSaleTipLabel updateLayout];
            }

            if (day == 0 && hour == 0 && minute == 0 && second == 0) {
                ///倒计时结束 秒杀开始
                [JHNotificationCenter postNotificationName:GoodsDetailShouldBeginSeckillNotification object:nil];
                [self beginSeckill];
            }
        }];
    }
    else {
        ///正在抢购 正在秒杀
        [self beginSeckill];
    }
}

///商品开始秒杀处理
- (void)beginSeckill {
    self.goodsSaleTipLabel.text = @"";
    self.countDownView.hidden = NO;
    
    NSInteger seckillEndTime = _goodsInfo.offline_at.integerValue;
    NSString *endTimeString = [CommHelp stringWithTimeInterval:@(seckillEndTime*1000).stringValue formatter:@"yyyy-MM-dd HH:mm:ss"];
    int second = [CommHelp dateRemaining:endTimeString];
    if (second > 0) {
        @weakify(self);
        [self.countDown startWithFinishTimeStamp:second completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
            @strongify(self);
            [self.countDownView setDD:day hh:hour mm:minute ss:second];
            if (self.goodsSaleTipLabel) {
                self.goodsSaleTipLabel.sd_layout.widthIs(self.countDownView.width_sd + 20);
                [self.goodsSaleTipLabel updateLayout];
            }
            if (day == 0 && hour == 0 && minute == 0 && second == 0) {
                [self showEndStyle];
            }
        }];
    }
    else {
        [self showEndStyle];
    }
}

- (void)showEndStyle {
    NSLog(@"<详情页>此商品倒计时结束");
    ///以前定时器的方法
    [JHNotificationCenter postNotificationName:GoodsDetailCountDownEndNotification object:nil];
    self.goodsInfo.status = JHGoodsStatusSellEnd;
    [self.countDownView showEndStyle];
    [self setSeckillEndLayouts];
}

///秒杀结束 || 已结缘时的UI
- (void)setSeckillEndLayouts {
    _countDownView.sd_resetLayout.widthIs(0);
    _countDownView.hidden = YES;
    _goodsSaleTipLabel.text = @"";
    _goodsSaleTipLabel.sd_layout.widthIs(0);
    _goodsSaleTipLabel.hidden = YES;
    _priceContainer.sd_layout.rightSpaceToView(self.contentView, 0);
    [self __setOrigPriceStr:_goodsInfo.orig_price isNotSale:NO]; //原价 带删除线
    ///已结束商品不显示限时购
    if (_goodsInfo.status == JHGoodsStatusSellEnd) {
        _saleTagLabel.hidden = YES;
        _curPriceLabel.sd_layout.leftSpaceToView(_priceContainer, 15);
        [_curPriceLabel updateLayout];
        _curPriceLabel.sd_layout.centerYEqualToView(_priceContainer); //必须设置，不然位置不对！
    }
}

///普通商品的UI
- (void)resetGoodPriceLayouts {
    ///修改 折扣边框 原价格颜色 划线价颜色
    _priceContainer.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    _discountLabel.layer.borderColor = kColorFF4200.CGColor;
    _discountLabel.textColor = kColorFF4200;
    _curPriceLabel.textColor = kColorFF4200;
    _oriPriceLabel.textColor = kColor666;
    [self __setOrigPriceStr:_goodsInfo.orig_price isNotSale:YES]; //原价 带删除线
    _discountLabel.hidden = YES;
    _oriPriceLabel.hidden = YES;
    
    _countDownView.sd_resetLayout.widthIs(0);
    _countDownView.hidden = YES;
    _goodsSaleTipLabel.text = @"";
    _goodsSaleTipLabel.sd_layout.widthIs(0);
    _goodsSaleTipLabel.hidden = YES;
    _priceContainer.sd_layout.rightSpaceToView(self.contentView, 0);
    
    //判断是否存在限时购标签，更新布局
    _saleTagLabel.hidden = YES;
    _curPriceLabel.sd_layout.leftSpaceToView(_priceContainer, 15);
    [_curPriceLabel updateLayout];
    _curPriceLabel.sd_layout.centerYEqualToView(_priceContainer); //必须设置，不然位置不对！
}

//设置带删除线的原价，isNotSale:bu不是特卖商品
- (void)__setOrigPriceStr:(NSString *)oriStr isNotSale:(BOOL)isNotSale {
    if (!oriStr) {return;}
    
    NSUInteger length = [oriStr length];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oriStr];
    
    [attri addAttribute:NSStrikethroughStyleAttributeName
                  value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)
                  range:NSMakeRange(0, length)];
    
    [attri addAttribute:NSStrikethroughColorAttributeName
                  value:isNotSale ? kColor666 : [UIColor whiteColor]
                  range:NSMakeRange(0, length)];
    
    [_oriPriceLabel setAttributedText:attri];
}


#pragma mark -
#pragma mark - 倒计时相关 - 添加通知   没用到 注释掉了 ----- lh
//- (void)__addCountDownObserver {
//    @weakify(self);
    /**
    [[[JHNotificationCenter rac_addObserverForName:YDCountDownNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self handleCountDownEvent];
    }];
     */
    
//    _signal = [[JHNotificationCenter rac_addObserverForName:YDCountDownNotification object:nil] takeUntil:self.rac_willDeallocSignal];
//
//    [_signal subscribeNext:^(NSNotification * _Nullable notification) {
//        @strongify(self);
//        [self handleCountDownEvent];
//    }];
//}



@end
