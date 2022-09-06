//
//  JHRecycleOrderDetailProductViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-商品信息ViewModel

#import "JHRecycleOrderDetailBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailProductViewModel : JHRecycleOrderDetailBaseViewModel
/// 商家名
@property (nonatomic, copy) NSString *titleText;
/// 商品图片链接
@property (nonatomic, copy) NSString *productUrl;
/// 商品描述
@property (nonatomic, copy) NSString *detailText;
/// 商品分类
@property (nonatomic, copy) NSString *sortText;
/// 商品价格
@property (nonatomic, copy) NSAttributedString *priceText;

- (void)setupPrice : (NSString *)price;
@end

NS_ASSUME_NONNULL_END
