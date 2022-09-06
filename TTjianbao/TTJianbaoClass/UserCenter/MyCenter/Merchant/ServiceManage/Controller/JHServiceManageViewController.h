//
//  JHServiceManageViewController.h
//  TTjianbao
//
//  Created by zk on 2021/7/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHServiceManageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHServiceManageViewController : JHBaseViewController

@property (nonatomic, copy) NSString *anchorId;

@property (nonatomic, assign) int pageType; // 0-编辑 1-添加

@property (nonatomic, assign) int pageIndex; // 0-一级页 1-二级页

@property (nonatomic, strong) NSMutableArray  *dataSourceArray;

@property (nonatomic, strong) JHServiceManageModel *headModel;

@end

NS_ASSUME_NONNULL_END
