//
//  JHCustomizeDetailInfoView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeDetailInfoView : JHOrderSubBaseView
@property(strong,nonatomic)JHCustomizeOrderModel * orderMode;
-(void)initCustomizeDetailViews;
@end

NS_ASSUME_NONNULL_END
