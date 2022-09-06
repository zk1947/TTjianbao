//
//  JHBasePageModel.h
//  TTjianbao
//
//  Created by liuhai on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBasePageModel : NSObject
@property(nonatomic, assign) BOOL hasMore;
@property(nonatomic, assign) NSInteger pageNo;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, assign) NSInteger pages;//总页数
@end

NS_ASSUME_NONNULL_END
