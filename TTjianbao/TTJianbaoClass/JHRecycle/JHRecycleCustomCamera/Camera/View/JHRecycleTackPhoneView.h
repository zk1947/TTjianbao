//
//  JHRecycleTackPhoneView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN




typedef  void (^TakePhoneEvent)(void);
typedef  void (^StartRecordEvent)(void);
typedef  void (^StopRecordEvent)(void);

@interface JHRecycleTackPhoneView : UIView
/// 拍照
@property (nonatomic, copy) TakePhoneEvent takePhone;
/// 重拍照
@property (nonatomic, copy) TakePhoneEvent remakePhone;
/// 录制
@property (nonatomic, copy) StartRecordEvent startRecord;

@property (nonatomic, copy) StopRecordEvent stopRecord;

/// 是否允许拍照
@property (nonatomic, assign) BOOL allowTakePhone;
/// 是否允许录像
@property (nonatomic, assign) BOOL allowRecordVideo;
/// 是否重拍
@property (nonatomic, assign) BOOL isRemake;
@end

NS_ASSUME_NONNULL_END
