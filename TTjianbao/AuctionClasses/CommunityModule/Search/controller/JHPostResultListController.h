//
//  JHPostResultListController.h
//  TTjianbao
//
//  Created by lihui on 2020/9/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListPlayerViewController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPostResultListController : JHBaseListPlayerViewController <JXCategoryListContentViewDelegate>

@property(nonatomic, strong) NSString *q;
@property(nonatomic, strong) NSString *type;
@property (nonatomic, copy) NSString *keywordSource;
@property(nonatomic, assign) BOOL hasTopic;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
