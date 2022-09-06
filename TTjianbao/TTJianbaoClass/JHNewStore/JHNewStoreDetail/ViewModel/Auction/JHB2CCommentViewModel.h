//
//  JHB2CCommentViewModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/7/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCellBaseViewModel.h"
#import "JHC2CJiangPaiListModel.h"
#import "JHAudienceCommentMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHB2CCommentViewModel : JHStoreDetailCellBaseViewModel

/// 展开评论
@property(nonatomic ) BOOL  openFold;

///展开商家回复
@property(nonatomic ) BOOL  openFoldShopReply;

/// 商家回复
@property(nonatomic ) BOOL  hasShopReply;

/// 头像url
@property(nonatomic, copy) NSString * imgUrl;

/// 日期
@property(nonatomic, copy) NSString * dateTime;

/// 用户名
@property(nonatomic, copy) NSString * name;

/// 描述文字
@property(nonatomic, copy) NSString * desString;

/// 商家回复文本
@property(nonatomic, copy) NSString * shopReplyString;

/// 星星数目
@property(nonatomic) NSInteger  pass;

/// 图片 url
@property(nonatomic, copy) NSArray<NSString*> * imageArr;

@property(nonatomic, strong) JHAudienceCommentMode * commentMode;


/// 删除评论
- (void)delComment;
@end

NS_ASSUME_NONNULL_END
