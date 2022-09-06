//
//  JHDiscoverSearchModel.h
//  TTjianbao
//
//  Created by mac on 2019/5/28.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHDiscoverSearchModel : NSObject

@property(nonatomic, assign) NSInteger searchKeyId;//标签唯一标示
@property(nonatomic, strong) NSString *name;//标签名称
@property (nonatomic, assign) NSInteger type;//0-默认标签 1-热搜
@end

NS_ASSUME_NONNULL_END
