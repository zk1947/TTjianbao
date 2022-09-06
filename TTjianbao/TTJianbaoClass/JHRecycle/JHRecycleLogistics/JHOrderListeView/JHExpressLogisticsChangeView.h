//
//  JHExpressLogisticsChangeView.h
//  TTjianbao
//
//  Created by user on 2021/6/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHExpressLogisticsChangeView : UIView
@property (nonatomic,   copy) void(^saveBlock)(NSString *com, NSString *num);
@property (nonatomic,   copy) dispatch_block_t cancleBlock;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

NS_ASSUME_NONNULL_END
