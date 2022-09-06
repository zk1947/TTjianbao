//
//  JHSearchRespModel.h
//  TTjianbao
//
//  Created by jiangchao on 2020/7/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSearchRespModel : NSObject
@property (nonatomic, assign) NSInteger section_id;
@property (nonatomic, assign) NSInteger topic_id;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *q;
@end

NS_ASSUME_NONNULL_END
