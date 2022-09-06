//
//  JHGuessAnchourAlertView.h
//  TTjianbao
//
//  Created by jiang on 2019/6/19.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^guessSureBlock)(NSString * _Nonnull price);

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGuessAnchourAlertView : BaseView
@property(strong,nonatomic)guessSureBlock compelteBlock;
@end

NS_ASSUME_NONNULL_END
