//
//  JHShopHomeConsultViewController.h
//  TTjianbao
//
//  Created by apple on 2019/11/28.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  询价商品列表
//

#import "JHBaseViewExtController.h"

typedef void(^JHShopScrollContentOffSetBlock)(CGFloat offsetY);


NS_ASSUME_NONNULL_BEGIN

@interface JHShopHomeConsultViewController : JHBaseViewExtController

@property (nonatomic, assign) NSInteger sellerId;
@property (nonatomic, copy) JHShopScrollContentOffSetBlock offsetBlock;



@end

NS_ASSUME_NONNULL_END
