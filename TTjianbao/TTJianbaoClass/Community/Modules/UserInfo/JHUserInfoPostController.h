//
//  JHUserInfoPostController.h
//  TTjianbao
//
//  Created by lihui on 2020/7/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListPlayerViewController.h"
#import "JXPagerView.h"
#import "JHUserInfoApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUserInfoPostController : JHBaseListPlayerViewController <JXPagerViewListViewDelegate>

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) JHPersonalInfoType infoType;

@property (nonatomic, copy) dispatch_block_t refreshBlock;

///刷新数据  主播id
- (void)refreshData:(NSString *)archorId;


@end

NS_ASSUME_NONNULL_END
