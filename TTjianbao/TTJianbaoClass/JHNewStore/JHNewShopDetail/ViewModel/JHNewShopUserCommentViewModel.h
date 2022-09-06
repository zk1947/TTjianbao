//
//  JHNewShopUserCommentViewModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopBaseViewModel.h"
#import "JHNewShopUserCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopUserCommentViewModel : JHNewShopBaseViewModel
@property (nonatomic, strong) JHNewShopUserCommentModel *userCommentModel;
@property (nonatomic, strong) NSMutableArray *commentDataArray;
@property (nonatomic, strong) RACCommand *shopUserCommentCommand;

@end

NS_ASSUME_NONNULL_END
