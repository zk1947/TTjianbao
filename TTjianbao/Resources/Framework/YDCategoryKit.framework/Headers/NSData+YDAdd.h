//
//  NSData+YDAdd.h
//  YDCategoryKit
//
//  Created by WU on 16/4/15.
//  Copyright © 2016年 WU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (YDAdd)

/*! GB2312转换为UTF8格式 */
- (NSData *)convertGB2312ToUTF8Data;

/*! NSData转NSString */
- (NSString *)convertToString;

//通过图片Data数据第一个字节来获取图片扩展名
+ (NSString *)contentTypeForImageData:(NSData *)data;

@end
