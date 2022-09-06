//
//  JHMarketPublishViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketPublishViewController : JHBaseViewController <JXCategoryListContentViewDelegate>

//商品状态 0-上架 1-下架 2违规禁售 3预告中 4已售出 5流拍 6交易取消 （3，5，6是拍卖商品特有的状态)
@property (nonatomic, assign) NSInteger productStatus;
@end

NS_ASSUME_NONNULL_END
