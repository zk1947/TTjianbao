//
//  JHPersonalResellDataModel.h
//  TTjianbao
//  Description:组织个人转售数据
//  Created by jesee on 20/5/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHPersonalResellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPersonalResellDataModel : NSObject

///原石转售-上架-操作
- (void)asynReqPersonalResellShelve:(NSString*)stoneId response:(JHResponse)resp;

///原石转售-下架-操作
- (void)asynReqPersonalResellUnshelve:(NSString*)stoneId response:(JHResponse)resp;

///原石转售-个人中心-删除
- (void)asynReqPersonalResellDelete:(NSString*)stoneId response:(JHResponse)resp;

///原石转售-个人中心-list item
- (void)asynReqPersonalResellListItem:(NSString*)stoneId response:(JHResponse)resp;

//待上架(删除)和在售(下架)使用lastStoneId,已售忽略此字段
- (void)asynReqPersonalResellListPageType:(JHPersonalResellSubPageType)pageType lastStoneId:(NSString*)lastStoneId response:(JHResponse)resp;
@end

NS_ASSUME_NONNULL_END
