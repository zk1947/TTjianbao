//
//  JHGoodsDetailBottomToolBar.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CGoodsInfo;

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodsDetailBottomToolBar : UIView

@property (nonatomic, copy) dispatch_block_t clickServiceBlock;
@property (nonatomic, copy) dispatch_block_t clickShopBlock;

///添加收藏 YES       取消收藏为 NO
@property (nonatomic, copy) void (^clickCollectBlock) (BOOL isCollected);
@property (nonatomic, copy) dispatch_block_t clickBuyBlock;

@property (nonatomic, strong, readonly) UIButton *buyBtn;

@property (nonatomic, strong) CGoodsInfo *goodsInfo;

@end

NS_ASSUME_NONNULL_END
