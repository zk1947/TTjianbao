//
//  JHSpecialAreaSection.h
//  TTjianbao
//
//  Created by jiangchao on 2020/7/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMallOperationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSpecialAreaSection : UIView
+ (CGFloat)cellHeight;
@property(nonatomic,strong)JHOperationDetailModel  *detailMode;
@property(nonatomic,assign)NSInteger sectionsOfArea; //记录第几行,仅仅为埋点,以后这类埋点不要加,侵入代码太严重
@end

NS_ASSUME_NONNULL_END
