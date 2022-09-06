//
//  JHMallGroupConditionView.h
//  TTjianbao
//
//  Created by apple on 2020/3/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMallGroupConditionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHMallGroupConditionView : UIView

@property (nonatomic, strong) JHMallGroupConditionModel *model;

+(CGSize)viewSize;

@end

NS_ASSUME_NONNULL_END
