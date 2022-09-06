//
//  JHCustomizeProgramView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeProgramView : JHOrderSubBaseView
@property(assign,nonatomic) BOOL  isSeller;
@property(strong,nonatomic)JHCustomizeOrderModel * orderMode;
-(void)initCustomizeProgramViews;
 @property(strong,nonatomic)JHFinishBlock viewHeightChangeBlock;
@end

NS_ASSUME_NONNULL_END
