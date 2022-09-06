//
//  JHFoucsUserAndShopNumModel.h
//  TTjianbao
//
//  Created by apple on 2020/2/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHFoucsUserAndShopNumModel : NSObject

/// 普通用户数
@property (nonatomic, assign) NSInteger general_num;

///  店铺用户数
@property (nonatomic, assign) NSInteger shop_num;

///  板块数
@property (nonatomic, assign) NSInteger channel_num;
@end

NS_ASSUME_NONNULL_END
