//
//  JHRequestModel.h
//  TTjianbao
//  Description:网络请求基类之灵活扩展
//  Created by Jesse on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRequestModel : JHReqModel

@property (nonatomic, assign) NSUInteger pageIndex; //第几页
@property (nonatomic, assign) NSUInteger pageSize; //每页几条

/**设置请求URI:url
 **当request比较简单,参数很少时,
 **可以直接set一下,减少创建model的过程
 **/
- (void)setRequestPath:(NSString*)url;

@end

NS_ASSUME_NONNULL_END
