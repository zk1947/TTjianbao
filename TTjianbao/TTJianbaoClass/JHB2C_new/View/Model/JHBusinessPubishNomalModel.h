//
//  JHBusinessPubishNomalModel.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHGoodManagerFilterModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface JHPublishTimeListModel : NSObject
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *timeDesc;
@end


@interface JHBusinessPubishNomalModel : NSObject
@property (nonatomic,strong)NSMutableArray *backCateList;
@property (nonatomic,strong)NSMutableArray *publishLastTimeList;
@property (nonatomic,strong)NSMutableArray *publishStartTimeList;
@end

NS_ASSUME_NONNULL_END
