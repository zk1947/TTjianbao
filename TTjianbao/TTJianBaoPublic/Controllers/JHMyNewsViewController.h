//
//  JHMyNewsViewController.h
//  TTjianbao
//
//  Created by YJ on 2021/1/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListPlayerViewController.h"
#import "JXPagerView.h"
#import "JHUserInfoApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMyNewsViewController : JHBaseListPlayerViewController<JXPagerViewListViewDelegate>

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) JHPersonalInfoType infoType;

@property (nonatomic, copy) dispatch_block_t refreshBlock;

///刷新数据  主播id
- (void)refreshData:(NSString *)archorId;


@end

NS_ASSUME_NONNULL_END
