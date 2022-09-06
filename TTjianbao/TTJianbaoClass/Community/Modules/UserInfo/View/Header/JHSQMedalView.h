//
//  JHSQMedalView.h
//  TTjianbao
//  Description:多icon排列,但是初始化时,最好给个高度
//                   不然首次可能不显示(内部高度约束导致,暂时不改控件内部)
//  Created by lihui on 2020/6/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///勋章标识展示界面

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSQMedalView : UIView

///勋章标识数组
@property (nonatomic, copy) NSArray <NSString *>*tagArray;

@end

NS_ASSUME_NONNULL_END
