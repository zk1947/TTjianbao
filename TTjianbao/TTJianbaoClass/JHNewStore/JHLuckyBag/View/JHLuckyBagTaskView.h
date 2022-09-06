//
//  JHLuckyBagTaskView.h
//  TTjianbao
//
//  Created by zk on 2021/11/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLuckyBagBusiniss.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLuckyBagTaskView : UIView

@property(nonatomic,strong) JHLuckyBagTaskModel *taskModel;

@property (nonatomic, copy) void(^ruleBlock)(void);

@property (nonatomic, copy) void(^taskBlock)(int index);

-(void)show:(NSInteger)bagId secandStr:(NSString *)secandStr;

- (void)loadData:(NSInteger)bagId;

- (void)remove;

- (void)downLuckyBag;

@end

NS_ASSUME_NONNULL_END
