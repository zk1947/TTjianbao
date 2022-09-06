//
//  JHSearchBarNaviView.h
//  TTjianbao
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^JHSearchBarNaviViewBackBlock)(void);
typedef void(^JHSearchBarNaviViewJumpBlock)(void);

@interface JHSearchBarNaviView : BaseView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeHoder;
@property (nonatomic, copy) JHSearchBarNaviViewBackBlock backBlock;
@property (nonatomic, copy) JHSearchBarNaviViewJumpBlock jumpBlock;

@end

NS_ASSUME_NONNULL_END
