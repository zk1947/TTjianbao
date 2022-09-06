//
//  NSArray+JHExtension.h
//  TTjianbao
//
//  Created by user on 2020/11/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSArray<ObjectType>(Operations)
- (NSArray*)jh_unique;
/**
 *  将数组映射为另外一个数组
 *
 *  @param block 映射函数 <br/>
 *         The block takes two arguments:
 *
 *  obj The element in the array.
 *
 *  idx The index of the element in the array.
 *
 *  @return 映射后的数组
 */
- (NSMutableArray*)jh_map:(id (^)(ObjectType obj, NSUInteger idx))block;

- (NSMutableArray*)jh_filter:(BOOL (^)(ObjectType obj, NSUInteger idx))block;

/**
 *  将数组分割成若干个小数组，
 *
 *  @param count 每个小数组的最大包含元素数
 *  @param remindObjects 是否将不满足个数剩余元素也收集起来
 *
 *  @return 返回分割后的若干个小数组组成的数组
 */
- (NSMutableArray*)jh_split:(NSUInteger)count remindObjects:(BOOL)remindObjects;

/**
 *  用seperator把数组内容连接成一个字符串
 *
 *  @param seperator 分割符
 *
 *  @return 连接好的字符串
 */
- (NSString*)jh_joinedString:(NSString*)seperator;

- (void)jh_each:(void (^)(ObjectType item, NSUInteger index))block;
- (void)jh_each:(NSArray<NSNumber*>*)indexes executor:(void (^)(ObjectType item, NSUInteger index))block;

- (void)jh_foreach:(void (^)(id item, NSUInteger index, BOOL*stop))block;

/**
 *  把数组简化成一个对象
 *
 *  @param initial 初始值
 *  @param block 计算代码
 *
 *  @return 简化后的结果
 *  @code
 *  NSArray<NSString*>*names = @[@"ab", @"bc", @"cdx"];
 *  NSUInteger characters = [[names jh_reduce:@"0" executor:^id (NSString *item, NSUInteger index, id prev) {
 *      return @([prev unsignedIntegerValue] + [item length]);
 *  }] unsignedIntegerValue];
 *  @endcode
 */
- (id)jh_reduce:(id)initial executor:(id (^)(ObjectType item, NSUInteger index, id prev))block;

- (NSMutableArray*)jh_joined:(NSArray*)array;

- (id)jh_firstObjectPassingTest:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL*stop))predicate;
@end

@interface NSArrayOperations <InputType, OutputType> : NSObject
+ (NSMutableArray<OutputType>*)map:(NSArray<InputType>*)input with:(OutputType (^)(InputType item, NSUInteger index))block;
@end

NS_ASSUME_NONNULL_END
