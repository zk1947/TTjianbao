//
//  JHBaseOperationModel.h
//  TTjianbao
//
//  Created by apple on 2020/4/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JHOperationType)
{
    /// 无
    JHOperationTypeNone           = 0,
    ///微信聊天
    JHOperationTypeWechatSession  = 1 << 0,
    ///微信朋友圈
    JHOperationTypeWechatTimeLine = 1 << 1,
    /// 复制链接
    JHOperationTypeCopyUrl       = 1 << 2,
    /// 收藏
    JHOperationTypeColloct      = 1 << 3,
    /// 取消收藏
    JHOperationTypeCancleColloct      = 1 << 4,
    ///  返回首页
    JHOperationTypeBack       = 1 << 5,
    ///  设为精华
    JHOperationTypeSetGood      = 1 << 6,
    /// 取消精华
    JHOperationTypeCancleSetGood      = 1 << 7,
    ///  置顶
    JHOperationTypeSetTop      = 1 << 8,
    /// 取消置顶
    JHOperationTypeCancleSetTop      = 1 << 9,
    ///  公告
    JHOperationTypeNoice      = 1 << 10,
    
    /// 取消公告
    JHOperationTypeCancleNotice      = 1 << 11,
    ///  删除
    JHOperationTypeDelete     = 1 << 12,
    ///  警告
    JHOperationTypeWaring     = 1 << 13,
    ///  禁言
    JHOperationTypeMute     = 1 << 14,
    ///  封号
    JHOperationTypeSealAccount      = 1 << 15,
    ///  举报
     JHOperationTypeReport      = 1 << 16,
    /// 编辑
    JHOperationTypeEdit      = 1 << 17,
    /// 生成长图
    JHOperationTypeMakeLongImage  = 1 << 18,
};

NS_ASSUME_NONNULL_BEGIN

@interface JHBaseOperationModel : NSObject

@property (nonatomic, assign) JHOperationType operationType;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *title;

+(NSMutableArray <JHBaseOperationModel *>*)getOperationTypeArrayWith:(JHOperationType)operationType;

@end

NS_ASSUME_NONNULL_END
