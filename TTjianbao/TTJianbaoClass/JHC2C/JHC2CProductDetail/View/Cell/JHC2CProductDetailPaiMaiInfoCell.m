//
//  JHC2CProductDetailPaiMaiInfoCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailPaiMaiInfoCell.h"
#import "JHC2CProductDetailPaiMaiInfoTopView.h"
#import "JHC2CProductDetailPaiMaiInfoBottomListView.h"
#import "JHC2CProductDetailPaiMaiInfoMiddleView.h"
#import "JHC2CProductDetailBusiness.h"

#import <YYLabel.h>
#import "JHC2CProoductDetailModel.h"
#import "CommHelp.h"


@interface JHC2CProductDetailPaiMaiInfoCell()

@property(nonatomic, strong) UIView * backView;

@property(nonatomic, strong) JHC2CProductDetailPaiMaiInfoTopView * topView;
@property(nonatomic, strong) JHC2CProductDetailPaiMaiInfoMiddleView * midDetailView;
@property(nonatomic, strong) JHC2CProductDetailPaiMaiInfoBottomListView * bottomListView;

@property(nonatomic, strong) JHC2CJiangPaiListModel * listModel;

@property(nonatomic) CGFloat  listHeight;

@property(nonatomic, strong) NSDateFormatter * formatter;

@property(nonatomic, strong) NSTimer * refreshTimer;

@property(nonatomic) BOOL  hasSet;

@property(nonatomic) BOOL  inBeforeStart;
@property(nonatomic) BOOL  hasBeforeStartRefresh;

@property(nonatomic) BOOL  inBeforeEnd;
@property(nonatomic) BOOL  hasBeforeEndRefresh;


/// 距离开始秒
@property(nonatomic) NSInteger  startTimeSecond;

/// 距离结束秒
@property(nonatomic) NSInteger  endTimeSecond;

@end

@implementation JHC2CProductDetailPaiMaiInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setItems];
        [self layoutItems];
        [self refreshStatus:JHC2CJingPaiStatus_Type_WeiChuJia];
        @weakify(self);
        self.refreshTimer = [NSTimer timerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
            @strongify(self);
            [self refreshTime];
        } repeats:YES];
        [NSRunLoop.currentRunLoop addTimer:self.refreshTimer forMode:NSRunLoopCommonModes];
        [self.refreshTimer fire];

    }
    return self;
}

- (void)setItems{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backView];
    
    [self.backView addSubview:self.topView];
    [self.backView addSubview:self.midDetailView];
    [self.backView addSubview:self.bottomListView];
    
}


- (void)setModel:(JHC2CProoductDetailModel *)model{
    _model = model;
    if (self.hasSet) {return;}
    if (!model) {return;}
    self.hasSet = YES;
//    [self refreshTime];
    BOOL baoYou = model.needFreight.integerValue == 0;
    self.topView.postMoneyLbl.text =  baoYou ? @"包邮" : [NSString stringWithFormat:@"邮费%@元", model.freight];
    [self refreshPaiMai];
}

- (void)setAuModel:(JHC2CAuctionRefershModel *)auModel{
    _auModel = auModel;
    if (!auModel) {return;}
    self.startTimeSecond = auModel.startTime/1000;
    self.endTimeSecond = auModel.endTime/1000;
    
    if ([auModel.productStatus isEqualToString:@"4"]) {
        self.topView.timeHourLbl.hidden = true;
        self.topView.timeMiniLbl.hidden = true;
        self.topView.timeSecLbl.hidden = true;
        self.topView.endTimeTextLbl.hidden = true;
        self.topView.hourDianImageView.hidden = true;
        self.topView.secondDianImageView.hidden = true;
    }else{
        self.topView.endTimeTextLbl.hidden = NO;
        self.topView.hourDianImageView.hidden = NO;
        self.topView.secondDianImageView.hidden = NO;
        self.topView.timeHourLbl.hidden = NO;
        self.topView.timeMiniLbl.hidden = NO;
        self.topView.timeSecLbl.hidden = NO;
    }
    //未开始
    if ([auModel.flowStatus isEqualToString:@"0"]) {
        self.topView.statusLbl.text = @"起拍价";
        self.topView.endTimeTextLbl.text = @"距拍卖开始";
        self.topView.moneyValueLbl.text = [CommHelp getPriceWithInterFen: auModel.startPrice.integerValue];
    //竞拍中
    }else if ([auModel.flowStatus isEqualToString:@"1"]) {
        self.topView.statusLbl.text = @"当前价";
        self.topView.endTimeTextLbl.text = @"距拍卖结束";
        NSString *maxPrice = [auModel.buyerPrice isNotBlank] ? auModel.buyerPrice : auModel.startPrice;
        self.topView.moneyValueLbl.text = [CommHelp getPriceWithInterFen: maxPrice.integerValue];
        
    //已结束
    }else if ([auModel.flowStatus isEqualToString:@"2"]) {
        self.topView.statusLbl.text =  [auModel.productStatus isEqualToString:@"5"] ? @"起拍价" : @"成交价" ;
        self.topView.endTimeTextLbl.text = @"距拍卖结束";
        NSString *maxPrice = [auModel.buyerPrice isNotBlank] ? auModel.buyerPrice : auModel.startPrice;
        self.topView.moneyValueLbl.text = [CommHelp getPriceWithInterFen: maxPrice.integerValue];
        if (![auModel.productStatus isEqualToString:@"4"]) {
            self.topView.endTimeTextLbl.hidden = YES;
            self.topView.hourDianImageView.hidden = YES;
            self.topView.secondDianImageView.hidden = YES;
            self.topView.timeHourLbl.hidden = YES;
            self.topView.timeMiniLbl.hidden = YES;
            self.topView.timeSecLbl.hidden = YES;
        }
    }
    
    [self.midDetailView refrshStartMoney:[CommHelp getPriceWithInterFen: auModel.startPrice.integerValue]
                             andAddMoney:[CommHelp getPriceWithInterFen: auModel.bidIncrement.integerValue]
                                andCount:[NSString stringWithFormat:@"%@次", auModel.number]];
    
    
    
    [self refreshTime];
}


- (void)refreshPaiMai{
    JHC2CProoductDetailModel *model = self.model;
    [JHC2CProductDetailBusiness requestC2CProductDetailPaiMaiList:model.auctionFlow.auctionSn page:@1 completion:^(NSError * _Nullable error, JHC2CJiangPaiListModel * _Nullable model) {
        if (!error && model.records.count > 0) {
            self.listModel = model;
            [self refreshAll];
        }else{
            [self refreshStatus:JHC2CJingPaiStatus_Type_WeiChuJia];
        }
    }];
}


- (void)refreshTime{
    if (!self.model && !self.auModel) {return;}
    if (self.auModel) {
        if (self.startTimeSecond > 0) {
            NSInteger startSecond = self.startTimeSecond;
            self.startTimeSecond -= 1;
            if (self.startTimeSecond <= 0) {
                self.startTimeSecond = 0;
                [NSNotificationCenter.defaultCenter postNotificationName:@"JHC2CProductDetailControllerNeedRefreshData" object:nil];
            };
            self.topView.timeHourLbl.text = [NSString stringWithFormat:@"%.2ld", startSecond/3600];
            self.topView.timeMiniLbl.text = [NSString stringWithFormat:@"%.2ld", (startSecond%3600)/60];
            self.topView.timeSecLbl.text = [NSString stringWithFormat:@"%.2ld", (startSecond%60)];
        }else if(self.endTimeSecond > 0){
            NSInteger endSecond = self.endTimeSecond;
            self.endTimeSecond -= 1;
            if (self.endTimeSecond <= 0) {
                self.endTimeSecond = 0;
                [NSNotificationCenter.defaultCenter postNotificationName:@"JHC2CProductDetailControllerNeedRefreshData" object:nil];
            };

            self.topView.timeHourLbl.text = [NSString stringWithFormat:@"%.2ld", endSecond/3600];
            self.topView.timeMiniLbl.text = [NSString stringWithFormat:@"%.2ld", (endSecond%3600)/60];
            self.topView.timeSecLbl.text = [NSString stringWithFormat:@"%.2ld", (endSecond%60)];
        }else{
            self.topView.timeHourLbl.text = [NSString stringWithFormat:@"%.2d", 0];
            self.topView.timeMiniLbl.text = [NSString stringWithFormat:@"%.2d", 0];
            self.topView.timeSecLbl.text = [NSString stringWithFormat:@"%.2d", 0];
        }

    }else{
        NSDate *endDate = [self.formatter dateFromString:self.model.auctionFlow.auctionEndTime];
        NSDate *startDate = [self.formatter dateFromString:self.model.auctionFlow.auctionStartTime];

        NSInteger startSecond = [startDate timeIntervalSinceNow];
        NSInteger endSecond = [endDate timeIntervalSinceNow];
        if (startSecond == 0 || endSecond == 0) {
            [NSNotificationCenter.defaultCenter postNotificationName:@"JHC2CProductDetailControllerNeedRefreshData" object:nil];
        }
        if (startSecond > 0) {
            self.topView.timeHourLbl.text = [NSString stringWithFormat:@"%.2ld", startSecond/3600];
            self.topView.timeMiniLbl.text = [NSString stringWithFormat:@"%.2ld", (startSecond%3600)/60];
            self.topView.timeSecLbl.text = [NSString stringWithFormat:@"%.2ld", (startSecond%60)];
        }else if(endSecond > 0){
            self.topView.timeHourLbl.text = [NSString stringWithFormat:@"%.2ld", endSecond/3600];
            self.topView.timeMiniLbl.text = [NSString stringWithFormat:@"%.2ld", (endSecond%3600)/60];
            self.topView.timeSecLbl.text = [NSString stringWithFormat:@"%.2ld", (endSecond%60)];
        }else{
            self.topView.timeHourLbl.text = [NSString stringWithFormat:@"%.2d", 0];
            self.topView.timeMiniLbl.text = [NSString stringWithFormat:@"%.2d", 0];
            self.topView.timeSecLbl.text = [NSString stringWithFormat:@"%.2d", 0];
        }
    }
}

- (void)refreshAll{
    JHC2CProoductDetailModel *model = self.model;
    NSInteger status = model.auctionFlow.auctionStatus.integerValue;
    CGFloat appendFooter = 0.f;
    if (self.listModel.records.count > 3) {
        appendFooter = 43.f;
    }
    self.listHeight = 58.f * MIN(self.listModel.records.count, 3) + 41.f + appendFooter;
    JHC2CJingPaiStatus_Type type = JHC2CJingPaiStatus_Type_WeiChuJia;
    if (status == 1) {
        type = JHC2CJingPaiStatus_Type_YiChuJia;
    }else if(status == 2){
        type = JHC2CJingPaiStatus_Type_ChengJiao;
    }
    [self refreshStatus:type];
    self.bottomListView.model = self.listModel;
    [NSNotificationCenter.defaultCenter postNotificationName:@"JHC2CProductDetailControllerNeedReloadLoad" object:nil];
}



- (void)refreshStatus:(JHC2CJingPaiStatus_Type)status{
    switch (status) {
        case JHC2CJingPaiStatus_Type_WeiChuJia:
        {
            
        }
        case JHC2CJingPaiStatus_Type_LiuPai:
        {
            [self.bottomListView removeFromSuperview];
            [self.midDetailView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.mas_bottom);
                make.left.right.equalTo(@0);
//                make.height.mas_equalTo(48);
                make.bottom.equalTo(@0);
            }];
        }
            break;
        case JHC2CJingPaiStatus_Type_YiChuJia:
        {
            
        }
        case JHC2CJingPaiStatus_Type_ChengJiao:
        {
            [self.backView addSubview:self.bottomListView];
            [self.midDetailView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.mas_bottom);
                make.left.right.equalTo(@0);
//                make.height.mas_equalTo(48);
            }];
            [self.bottomListView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.midDetailView.mas_bottom);
                make.left.right.equalTo(@0);
                make.height.mas_equalTo(self.listHeight);
                make.bottom.equalTo(@0);
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(15);
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(56);
    }];
    [self.midDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(@0);
//        make.height.mas_equalTo(48);
    }];
    [self.bottomListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midDetailView.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(260);
        make.bottom.equalTo(@0);
    }];
    
}
- (void)tapActionWithSender:(UIGestureRecognizer*)sender{
    if (self.tapSeletedJingPai) {
        self.tapSeletedJingPai();
    }
}

#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        _backView = view;
    }
    return _backView;
}

- (JHC2CProductDetailPaiMaiInfoTopView *)topView{
    if (!_topView) {
        JHC2CProductDetailPaiMaiInfoTopView *view = [JHC2CProductDetailPaiMaiInfoTopView new];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionWithSender:)];
//        [view addGestureRecognizer:tap];
        _topView = view;
    }
    return _topView;
}
- (JHC2CProductDetailPaiMaiInfoMiddleView *)midDetailView{
    if (!_midDetailView) {
        JHC2CProductDetailPaiMaiInfoMiddleView *view = [JHC2CProductDetailPaiMaiInfoMiddleView new];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionWithSender:)];
//        [view addGestureRecognizer:tap];
        _midDetailView = view;
    }
    return _midDetailView;
}
- (JHC2CProductDetailPaiMaiInfoBottomListView *)bottomListView{
    if (!_bottomListView) {
        JHC2CProductDetailPaiMaiInfoBottomListView *view = [JHC2CProductDetailPaiMaiInfoBottomListView new];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionWithSender:)];
//        [view addGestureRecognizer:tap];
        @weakify(self);
        [view setTapBlock:^{
            @strongify(self);
            [self tapActionWithSender:nil];
        }];
        [view setRefreshPriceBlock:^{
            @strongify(self);
            [self refreshBtn];
        }];
        _bottomListView = view;
    }
    return _bottomListView;
}
- (void)refreshBtn{
    if (self.tapRefreshBlock) {
        self.tapRefreshBlock();
    }
}

- (NSDateFormatter *)formatter{
    if (!_formatter) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        _formatter = formatter;
    }
    return _formatter;
}

@end

