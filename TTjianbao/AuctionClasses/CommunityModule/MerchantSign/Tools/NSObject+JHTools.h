//
//  NSObject+JHTools.h
//  TTjianbao
//
//  Created by apple on 2019/11/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JHTools)

///字典转json
+(NSString *)convertJSONWithDic:(NSDictionary *)dic;

///首行缩进
- (NSAttributedString *)paraStyleTextRetract:(NSString *)paraString FontSize:(CGFloat)size;



@end

NS_ASSUME_NONNULL_END
