//
//  JHStoreDetailCountdownView.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoreDetailCountdownViewModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, JHStoreDetailCountdownView_Type) {
    JHStoreDetailCountdownView_Type_Defalut = 0,
    JHStoreDetailCountdownView_Type_MiaoSha,
};
@interface JHStoreDetailCountdownView : UIView

@property (nonatomic, assign) NSInteger timeStamp;

@property(nonatomic, assign, readonly) JHStoreDetailCountdownView_Type  type;

- (instancetype)initCountDownViewWithType:(JHStoreDetailCountdownView_Type)type;
@end

NS_ASSUME_NONNULL_END
