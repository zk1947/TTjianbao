//
//  JHOrderPayMaterialAlert.h
//  TTjianbao
//
//  Created by jiangchao on 2021/1/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderPayMaterialAlert : UIView
@property(strong,nonatomic)UIImageView *titleImage;
@property(strong,nonatomic)JHFinishBlock cancleHandle;
@property(strong,nonatomic)JHFinishBlock handle;
@end

NS_ASSUME_NONNULL_END
