//
//  JHChatEvaluationModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHChatEvaluationModel : NSObject
@property (nonatomic, copy) NSString *evaluationId;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *nonIcon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isSelected;

- (instancetype)initWithId : (NSString *)evaluationId
                      icon : (NSString *)icon
                     title : (NSString *)title;

+ (NSArray<JHChatEvaluationModel *> *)getEvaluationList;
@end


NS_ASSUME_NONNULL_END
