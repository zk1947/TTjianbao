//
//  JHPayProtocolView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHPayProtocolView : JHOrderSubBaseView
@property (strong, nonatomic)   UIButton * protocolBtn;
@property(copy,nonatomic) JHFinishBlock protocalBlock;

@end

NS_ASSUME_NONNULL_END
