//
//  JHCommMenuView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/10/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCommMenuView : JHOrderSubBaseView
@property(nonatomic,strong)NSArray *dataArr;
@property(strong,nonatomic)JHActionBlock buttonHandle;
@end

NS_ASSUME_NONNULL_END
