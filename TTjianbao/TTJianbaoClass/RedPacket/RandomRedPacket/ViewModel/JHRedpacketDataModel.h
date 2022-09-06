//
//  JHRedpacketDataModel.h
//  TTjianbao
//  Description:红包请求
//  Created by Jesse on 2020/1/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHMakeRedpacketModel.h"
#import "JHGetRedpacketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRedpacketDataModel : NSObject

//请求“创建红包页”需要条件数据
- (void)requestMakeRedpacketPageData:(NSString*)channelId resp:(JHResponse)response;
//“塞钱进红包”请求
- (void)makeRedpacketRequest:(JHMakeRedpacketReqModel*)reqModel respone:(JHResponse)response;

///请求红包分页
- (void)requestGetRedpacketDetailWithModel:(JHGetRedpacketDetailPageModel *)paramModel PageData:(JHResponse)response;

@end

NS_ASSUME_NONNULL_END
