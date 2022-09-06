//
//  JHB2CCommentHeaderViewModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/8/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCellBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHB2CCommentHeaderViewModel : JHStoreDetailCellBaseViewModel

/// tag
@property(nonatomic, copy) NSArray<NSString*> * tagArr;

/// 评价数量
@property(nonatomic, strong) NSString * countOfComment;

/// 好评
@property(nonatomic, strong) NSString * haoPing;

/// 数量和好评Att
@property(nonatomic, strong) NSAttributedString * countAndHaoPingAttStr;


@property (nonatomic, strong) RACSubject *moreBtnAction;

@end

NS_ASSUME_NONNULL_END
