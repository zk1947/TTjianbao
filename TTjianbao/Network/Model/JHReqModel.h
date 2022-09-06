//
//  JHReqModel.h
//  TTjianbao
//  Description:网络请求基类,子类重写具体uriPath
//  Created by Jesse on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kListPageSize 10

typedef NS_ENUM(NSUInteger, JHRequestHostType)
{
    JHRequestHostTypeDefault, //默认 通用 请求URL域名
    JHRequestHostTypeCommon = JHRequestHostTypeDefault, //通用域名,无需设置
    JHRequestHostTypeSocial, //社区 请求URL域名
    JHRequestHostTypeHtml5, //H5 请求URL域名
    JHRequestHostTypeDevDebuging, //开发debug 请求URL域名
};

NS_ASSUME_NONNULL_BEGIN

@interface JHReqModel : NSObject

- (void)setRequestSourceType:(JHRequestHostType)type;
//网络请求时,直接读取fullUrl
- (NSString*)fullUrl;
//子类重写,赋值具体请求url后半部分
- (NSString*)uriPath;
//使用RequestSerializerTypeJson类型时,param传字典
- (NSDictionary*)paramsDict;
//字符串
- (NSString*)paramString;

@end

NS_ASSUME_NONNULL_END
