//
//  JHRecycleUploadProductBottomView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecycleSureButton.h"

NS_ASSUME_NONNULL_BEGIN
/// 回收商品上传信息底部悬浮视图
@interface JHRecycleUploadProductBottomView : UIView

@property(nonatomic, strong) JHRecycleSureButton * publishBtn;

@property(nonatomic, copy) void (^jumpRulerBlock)(void);

@end

NS_ASSUME_NONNULL_END
