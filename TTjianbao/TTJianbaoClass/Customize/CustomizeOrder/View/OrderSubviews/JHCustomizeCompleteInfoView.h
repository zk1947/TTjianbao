//
//  JHCustomizeCompleteInfoView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeCompleteInfoView : JHOrderSubBaseView
@property(strong,nonatomic)JHCustomizeOrderModel * orderMode;
-(void)initCustomizeCompleteInfoViews;
@end

NS_ASSUME_NONNULL_END
