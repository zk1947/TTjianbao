//
//  JHSeckillPageTitleView.h
//  TTjianbao
//
//  Created by jiang on 2020/3/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSecKillTitleMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHSeckillPageTitleView : UIView
//@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) JHSecKillTitleMode *titleMode;
@property (nonatomic, strong) JHFinishBlock timeEndBlock;
@property (nonatomic, strong) JHFinishBlock  beginBlock;
@end

NS_ASSUME_NONNULL_END
