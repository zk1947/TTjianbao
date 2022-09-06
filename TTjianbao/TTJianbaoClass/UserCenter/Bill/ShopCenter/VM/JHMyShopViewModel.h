//
//  JHMyShopViewModel.h
//  TTjianbao
//
//  Created by apple on 2019/12/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseViewModel.h"
#import "JHMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHMyShopViewModel : JHBaseViewModel

@property (nonatomic, strong) JHMyShopModel *dataSource;

- (void)setLabel:(UILabel *)label toNum:(CGFloat)number timeInterval:(NSTimeInterval)timeInterval;

@end

NS_ASSUME_NONNULL_END
