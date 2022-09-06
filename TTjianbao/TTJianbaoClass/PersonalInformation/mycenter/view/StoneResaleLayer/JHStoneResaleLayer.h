//
//  JHStoneResaleLayer.h
//  TTjianbao
//
//  Created by 张坤 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHMySectionModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^StoneResaleLayerBlock)(JHMyCellModel *myCellModel);

@interface JHStoneResaleLayer : BaseView

/**
 显示弹层
 */
- (void)showStoneResaleLayerWithDataSource:(NSArray *)dataSource didClickItem:(StoneResaleLayerBlock)stoneResaleLayerBlock;
@end

NS_ASSUME_NONNULL_END
