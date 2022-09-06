//
//  UMengShareView.h
//  TTjianbao
//
//  Created by wuyd on 2019/10/8.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMengManager.h"

NS_ASSUME_NONNULL_BEGIN

/** 更多操作选项 */
typedef NS_ENUM(NSInteger, UMShareMoreType) {
    UMShareMoreType_Report = 0, //举报
    UMShareMoreType_Delete, //删除
    UMShareMoreType_CopyLink //复制链接
};

@interface UMShareView : UIView

//- (instancetype)initWithFrame:(CGRect)frame showMore:(BOOL)showMore;
//- (instancetype)initWithFrame:(CGRect)frame showMore:(BOOL)showMore showReport:(BOOL)showReport;

- (instancetype)initWithFrame:(CGRect)frame showMore:(BOOL)showMore isMe:(BOOL)isMe;

@property (nonatomic, copy) void (^openShareBlock)(UMSocialPlatformType platformType);
@property (nonatomic, copy) void (^openMoreBlock)(UMShareMoreType moreType);

/** 显示 */
- (void)show;

@end

NS_ASSUME_NONNULL_END
