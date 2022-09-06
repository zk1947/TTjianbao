//
//  JHGraphicalBottomModel.h
//  TTjianbao
//
//  Created by miao on 2021/7/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHGraphicalBottomModel : NSObject

/// 标识的
@property (nonatomic, copy) NSString *kindName;
/// 是否展示
@property (nonatomic, assign) BOOL isShow;
/// 展示的文字
@property (nonatomic, copy) NSString *titleName;
///展示的文字宽度
@property (nonatomic, assign) CGFloat titleSizeWidth;
/// 特殊UI
@property (nonatomic, assign) BOOL isShowUISpecial;
/// button需要执行的方法名
@property (nonatomic, copy) NSString *selName;

@end

NS_ASSUME_NONNULL_END
