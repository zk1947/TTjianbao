//
//  JHOrderSearchResultViewController.h
//  TTjianbao
//
//  Created by jiang on 2019/11/4.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderSearchResultViewController : JHBaseViewExtController
@property(assign,nonatomic) BOOL  isSeller;
@property(assign,nonatomic)int currentIndex;
@property(strong,nonatomic)NSDictionary * params;
@end

NS_ASSUME_NONNULL_END
