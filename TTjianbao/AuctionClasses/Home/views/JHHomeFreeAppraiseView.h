//
//  JHHomeFreeAppraiseView.h
//  TTjianbao
//
//  Created by lihui on 2020/7/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHHomeFreeAppraiseView : UIView

///进入鉴定说明界面
@property (nonatomic, copy) void(^introduceBlock)(void);
///进入鉴定师选择界面
@property (nonatomic, copy) void(^enterAppraiseBlock)(void);

///累计鉴定的宝贝个数
@property (nonatomic, assign) NSInteger appraiseCount;

- (void)updateAppraiseData;

@end

NS_ASSUME_NONNULL_END
