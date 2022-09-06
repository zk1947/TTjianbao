//
//  JHPersonalResellSubController.h
//  TTjianbao
//  Description:个人转售tab子controller
//  Created by jesee on 20/5/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHTableViewController.h"
#import "JHPersonalResellDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPersonalResellSubController : JHTableViewController

@property (nonatomic, copy) JHActionBlocks customAction;

- (instancetype)initWithPageType:(JHPersonalResellSubPageType)type;
//刷新数据
- (void)refreshPage;
@end

NS_ASSUME_NONNULL_END
