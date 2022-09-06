//
//  JHMyCenterMerchantContentView.h
//  TTjianbao
//
//  Created by lihui on 2021/4/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JHMyCenterContentType) {
    ///全部
    JHMyCenterContentTypeAll = 0,
    ///直播
    JHMyCenterContentTypeLiving,
    ///商城
    JHMyCenterContentTypeStore,
};

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCenterMerchantContentView : UIView
@property (nonatomic, strong,readonly) UITableView *tableView;
- (instancetype)initWithContentData:(NSArray *)contentData;
///存放数据的数组
@property (nonatomic, copy) NSArray *contentData;
@property (nonatomic, copy) void (^changeHeightBlock)(CGFloat height);
/// 可提现金额
@property (nonatomic, copy) NSString *withDrawMoney;
/// 昨日成交金额
@property (nonatomic, copy) NSString *lastDayCompleteMoney;

///内容高度
@property (nonatomic, assign, readonly) CGFloat contentHeight;
@property (nonatomic, assign) JHMyCenterContentType type;

@end

NS_ASSUME_NONNULL_END
