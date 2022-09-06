//
//  JHOrderPayListView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderPayListView : JHOrderSubBaseView
@property(strong,nonatomic)JHActionBlock buttonHandle;
-(void)initSellerPayListSubviews:(NSArray*)arr;
-(void)initBuyerPayListSubviews:(NSArray*)arr;
@end

NS_ASSUME_NONNULL_END
