//
//  JHStoreDetailPriceViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailPriceViewModel.h"
#import "NSString+AttributedString.h"
@interface JHStoreDetailPriceViewModel()
{
    BOOL isStartCountDown;
}


@end

@implementation JHStoreDetailPriceViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        isStartCountDown = false;
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions


#pragma mark - Private Functions
- (void)setupDataWithSalePrice : (NSString *)salePrice
                         price : (NSString *)price
                         isAuction : (BOOL)auction
                      discount : (NSString *)discount{
    self.cellType = PriceCell;
    [self setupPriceWithSalePrice:salePrice
                            price:price
                       isAuction:auction
                         discount:discount];
    
}
/// 设置金额
- (void)setupPriceWithSalePrice : (NSString *)salePrice
                          price : (NSString *)price
                      isAuction : (BOOL)auction
                       discount : (NSString *)discount {
    if (salePrice) {
        NSMutableAttributedString *attPrice = [[NSMutableAttributedString alloc] initWithString:salePrice attributes:@{NSFontAttributeName : JHDINBoldFont(30), NSBaselineOffsetAttributeName : @-2}];
        
        NSAttributedString *xx = [[NSAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName : JHMediumFont(12)}];
        
        [ attPrice insertAttributedString:xx atIndex:0];
        
        self.salePriceText = attPrice;
    }
    if (price && !auction) {
        NSMutableAttributedString *attPrice = [[NSMutableAttributedString alloc] initWithString:price attributes:@{
            NSFontAttributeName : [UIFont systemFontOfSize:16]}];
        
        NSAttributedString *xx = [[NSAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName : JHFont(16)}];
        
        [attPrice insertAttributedString:xx atIndex:0];
        [attPrice addAttributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlinePatternSolid | NSUnderlineStyleSingle)} range:NSMakeRange(0, attPrice.length)];
        self.priceText = attPrice;
        
    }else if(price && auction && ![price isEqualToString:salePrice] && salePrice.length < 7){
        NSMutableAttributedString *attPrice = [[NSMutableAttributedString alloc] initWithString:price attributes:@{
            NSFontAttributeName : JHFont(16)}];
        
        NSAttributedString *xx = [[NSAttributedString alloc] initWithString:@"起拍价¥" attributes:@{NSFontAttributeName : JHFont(16)}];
        [attPrice insertAttributedString:xx atIndex:0];
        self.priceText = attPrice;

    }else{
        self.priceText = nil;
    }
    if (discount && ![discount isEqualToString:@"0"]) {
//        CGFloat xx = salePrice.floatValue / price.floatValue;
//        NSNumberFormatter *formatter = [NSNumberFormatter new];
//        formatter.numberStyle = NSNumberFormatterDecimalStyle;
//        formatter.multiplier = @10;
//        formatter.positivePrefix = @"  ";
//        formatter.positiveSuffix = @"折  ";
//        formatter.minimumFractionDigits = 1;
//        formatter.maximumFractionDigits = 2;
//        formatter.groupingSize = 4;
//        NSNumber *num = [NSNumber numberWithFloat:xx];
//        [formatter stringFromNumber:num]
        self.saleText = [NSString stringWithFormat:@" %@折 ",discount];
    }else {
        self.saleText = nil;
    }
}
/// 开始倒计时
- (void)startCountdown {
    if (self.countdownTime < 0) { return; }
    isStartCountDown = true;
    RACSignal *timerSignal = [RACSignal interval:1.0f onScheduler:[RACScheduler mainThreadScheduler]];
    //定时器总时间3秒
    timerSignal = [timerSignal take:self.countdownTime];
    @weakify(self)
    [timerSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.countdownTime--;
    } completed:^{
        @strongify(self)
        if (self.type != Auction) {
            self.type = Normal;
            [self.reloadCellSubject sendNext:nil];
        }
    }];
}
#pragma mark - Action functions

#pragma mark - Lazy
- (void)setType:(StoreDetailType)type {
    _type = type;
    if (type == Normal) {
        self.height = 42;
    }else {
        self.height = 60;
    }
}
- (RACReplaySubject<NSString *> *)bgColorSubject {
    if (_bgColorSubject) {
        _bgColorSubject = [RACReplaySubject subject];
    }
    return _bgColorSubject;
}
- (void)setPreviewSaleDateText:(NSString *)previewSaleDateText {
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    NSTimeZone *timeZone =[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    NSDate * currentDate = [NSDate dateWithTimeIntervalSince1970:[previewSaleDateText longLongValue]/1000.0];
    NSString * formDateStr = [formatter stringFromDate:currentDate];

    _previewSaleDateText = [NSString stringWithFormat:@"%@ 开抢" ,formDateStr];
}
- (void)setPreviewNumText:(NSString *)previewNumText {
    if (previewNumText != nil && ![previewNumText isEqualToString:@"0"]) {
        _previewNumText = [NSString stringWithFormat:@"%@人已设置提醒", previewNumText];
    }
    
}
- (void)setCountdownTime:(NSInteger)countdownTime {
    _countdownTime = countdownTime;
    if (isStartCountDown) { return; }
    [self startCountdown];
}

- (NSString *)remindCount{
    NSString* str = @"";
    NSString *value = _remindCount;
    if (value.length && value.integerValue != 0) {
//        if (value.integerValue > 9999) {
//            value = @"9999";
//        }
        str = [NSString stringWithFormat:@"%@人已设置提醒", value];
    }
    return str;
}

- (NSString *)auStartTime{
    NSString* str = @"";
    if (_auStartTime.length) {
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate * date = [formatter dateFromString:_auStartTime];
//        12月07日 14:00 开拍
        formatter.dateFormat = @"MM月dd日HH:mm";
        NSString *dateStr  = [formatter stringFromDate:date];
        str = [NSString stringWithFormat:@"%@开拍", dateStr];
    }
    return str;
}
@end
