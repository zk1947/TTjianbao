//
//  JHRouters.h
//  TTjianbao
//  Description:页面透传,两种方式:json和model
//  Created by jesee on 02/02/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRouterModel.h"

@interface JHRouters : NSObject

///根据传入json,分解参数,跳转页面
+ (BOOL)gotoPageByJson:(id)aData;
///根据传入模型,参数赋值,跳转页面
+ (BOOL)gotoPageByModel:(JHRouterModel*)model;

@end

/**透传模型：Json结构
{
 "type" : "1",                                     //选填
 "presentType" : "1",                          //选填
 "vc" : "JHMyCouponViewController",   //&&必填**
 "params" : {                                    //&&必填**
     "mId" : "123",                              //参数动态加减
     "currentIndex" : "2",                     //参数动态加减
     "extend" : "透传扩展"                     //参数动态加减
 }\
}\
 */
