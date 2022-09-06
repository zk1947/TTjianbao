//
//  JHCustomizePayInfoView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizePayInfoView : JHOrderSubBaseView
@property(strong,nonatomic)JHActionBlock buttonHandle;
-(void)initCustomizePayListSubviews:(NSArray<JHCustomizeOrderpayRecordVosModel*>*)arr;
@end

NS_ASSUME_NONNULL_END
