//
//  JHShopWindowPageController.h
//  TTjianbao
//
//  Created by wuyd on 2020/5/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHShopWindowPageController : YDBaseViewController

///橱窗id
@property (nonatomic, assign) NSInteger showcaseId;
/////橱窗名字
@property (nonatomic, copy) NSString *showcaseName;
@property (nonatomic,   copy) NSString* fromSource;

@end

NS_ASSUME_NONNULL_END
