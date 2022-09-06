//
//  JHLuckyBagView.h
//  TTjianbao
//
//  Created by zk on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHLuckyBagShowType) {
    JHLuckyBagShowTypeSet         = 0, //设置
    JHLuckyBagShowTypeShow        = 1, //展示
};

@interface JHLuckyBagView : UIView

-(void)show;

@end

NS_ASSUME_NONNULL_END
