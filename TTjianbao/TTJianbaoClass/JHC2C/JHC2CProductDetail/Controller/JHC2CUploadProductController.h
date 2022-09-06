//
//  JHC2CUploadProductController.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHIssueGoodsEditModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CUploadProductController : JHBaseViewController

/// 是否需要继续发布未完成
@property(nonatomic) BOOL needUnFinishReStart;

/// 后台一级分类id
@property(nonatomic, copy) NSString * firstCategoryId;

/// 后台二级分类id
@property(nonatomic, copy) NSString * secondCategoryId;

/// 后台三级分类id
@property(nonatomic, copy) NSString * thirdCategoryId;

/// 后台一级分类Name
@property(nonatomic, copy) NSString * firstCategoryName;

/// 后台二级分类Name
@property(nonatomic, copy) NSString * secondCategoryName;

/// 后台三级分类Name
@property(nonatomic, copy) NSString * thirdCategoryName;

@property (nonatomic, strong) JHIssueGoodsEditModel *editModel;

@end

NS_ASSUME_NONNULL_END
