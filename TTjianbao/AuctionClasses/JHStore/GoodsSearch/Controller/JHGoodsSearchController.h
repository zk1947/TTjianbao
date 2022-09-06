//
//  JHGoodsSearchController.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/19.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  商城首页 -- 商品搜索页面
//

#import "YDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodsSearchController : YDBaseViewController

///提交热搜词
@property (nonatomic, copy) NSString *keyword;
//展示热搜词
@property (nonatomic, copy) NSString *showKeyword;
 
@property (nonatomic, assign) BOOL isSort;  ///标记是否是分类

///一级分类名称
@property (nonatomic, copy) NSString *category1_name;
///一级分类id
@property (nonatomic, copy) NSString *category1_id;


@property (nonatomic, copy) NSString *category2_name;

@property (nonatomic, copy) NSString *category2_id;




@end

NS_ASSUME_NONNULL_END
