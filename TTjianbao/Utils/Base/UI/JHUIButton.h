//
//  JHUIButton.h
//  TTjianbao
//
//  Created by Jesse on 2019/12/12.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTjianbaoMarcoUI.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUIButton : UIButton

//异步获取网络图片, 且设置background image(铺平整个button)
- (void)asynSetBackgroundImage:(NSString*)imgUrl;
@end

NS_ASSUME_NONNULL_END
