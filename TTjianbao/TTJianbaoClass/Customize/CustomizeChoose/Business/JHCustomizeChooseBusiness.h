//
//  JHCustomizeChooseBusiness.h
//  TTjianbao
//
//  Created by user on 2020/12/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHCustomizeChooseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeChooseBusiness : NSObject

/*
 * 定制师分类列表
 */
+ (void)getChooseCustomizeListCompletion:(void(^)(NSError *_Nullable error, JHCustomizeChooseListModel *_Nullable model))completion;



/*
 * 定制师列表
 * JHCustomizeChooseRequestModel : 请求模型
 */
+ (void)getChooseCustomize:(JHCustomizeChooseRequestModel *)model
                Completion:(void(^)(NSError *_Nullable error, NSArray<JHCustomizeChooseModel *> *_Nullable array))completion;
@end

NS_ASSUME_NONNULL_END
