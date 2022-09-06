//
//  JHRecycleSoldButtonView.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHRecycleSoldModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleSoldButtonView : BaseView
/** 按钮展示模型*/
@property (nonatomic, strong) JHRecycleButtonsModel *buttonModel;
/** 订单id*/
@property (nonatomic, copy) NSString *orderId;
/** 通知上层刷新数据*/
@property (nonatomic, copy) void(^reloadDataBlock)(BOOL iSdelete);
/** 个别点击事件的回调*/
@property (nonatomic, copy) void(^clickActionBlock)(RecycleOrderButtonType buttonTag);
/** 订单详情的model*/
@property (nonatomic, strong) JHRecycleSoldModel *soldModel;
@end

NS_ASSUME_NONNULL_END
