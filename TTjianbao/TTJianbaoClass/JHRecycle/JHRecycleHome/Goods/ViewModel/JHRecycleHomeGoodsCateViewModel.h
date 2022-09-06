//
//  JHRecycleHomeGoodsCateViewModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleHomeGoodsCateViewModel : NSObject
@property (nonatomic, strong) RACCommand *goodsCateCommand;//商品分类
@property (nonatomic, strong) NSMutableArray *goodsCateDataArray;
@end

NS_ASSUME_NONNULL_END
