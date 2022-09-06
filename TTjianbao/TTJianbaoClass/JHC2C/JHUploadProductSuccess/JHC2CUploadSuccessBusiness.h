//
//  JHC2CUploadSuccessBusiness.h
//  TTjianbao
//
//  Created by jiangchao on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CUploadSuccessBusiness : NSObject
///获取推荐列表
+ (void)getProdutListRecommend:(NSDictionary *)params completion:(JHApiRequestHandler)completion;

+ (void)getC2CGuessLike:(NSDictionary *)params completion:(JHApiRequestHandler)completion;
@end

NS_ASSUME_NONNULL_END
