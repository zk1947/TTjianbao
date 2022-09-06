//
//  JHStoneSearchConditionFooterView.h
//  TTjianbao
//
//  Created by apple on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneSearchConditionFooterView : UIView

@property (nonatomic, copy) dispatch_block_t cancleBlock;

@property (nonatomic, copy) dispatch_block_t makeSureBlock;

@end

NS_ASSUME_NONNULL_END
