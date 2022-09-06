//
//  JHMallSpecialAreaModel.h
//  TTjianbao
//  专提模型
//  Created by jiang on 2020/4/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerMode.h"
#import "JHMessageTargetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMallSpecialAreaModel : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *memo;

@property (nonatomic, copy) NSString *operationAreaItemId;

@property (nonatomic, copy) NSString *title;

@property (strong, nonatomic)TargetModel *target;


@end

NS_ASSUME_NONNULL_END
