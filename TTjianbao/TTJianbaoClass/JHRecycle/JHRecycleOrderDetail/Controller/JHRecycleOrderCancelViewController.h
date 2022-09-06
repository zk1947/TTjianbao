//
//  JHRecycleOrderCancelViewController.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderCancelViewController : JHBaseViewController
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *selectedMsg;
/** 获取请求数据的type来确定调用哪个接口  1.ctc买家取消原因接口 2.ctc卖家取消接口*/
@property (nonatomic, assign) NSInteger requestType;
@property (nonatomic, strong) NSArray *datas;
//@property (nonatomic, copy) void(^selectCompleteBlock)(NSString *message);
@property (nonatomic, assign) Boolean isShowCancel;
- (void)setTitleText:(NSString *)text;
/** 使用外部数据,直接传数组*/
@property (nonatomic, strong) NSArray *dataArray;
/** 标题数据*/
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) void(^selectCompleteBlock)(NSString *message, NSString *code);

//- (void)showCancelButton;
@end

NS_ASSUME_NONNULL_END
