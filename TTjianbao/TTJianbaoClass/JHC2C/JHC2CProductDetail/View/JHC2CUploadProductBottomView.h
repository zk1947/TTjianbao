//
//  JHC2CUploadProductBottomView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecycleSureButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CUploadProductBottomView : UIView


@property(nonatomic, strong) JHRecycleSureButton * publishBtn;

@property(nonatomic, copy) void (^jumpRulerBlock)(void);

@end

NS_ASSUME_NONNULL_END
