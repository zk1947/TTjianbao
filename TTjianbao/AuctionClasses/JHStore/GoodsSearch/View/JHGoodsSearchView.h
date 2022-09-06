//
//  JHGoodsSearchView.h
//  TTjianbao
//
//  Created by LiHui on 2020/2/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSearchKeyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodsSearchView : UIView


@property (nonatomic, copy) void (^didSelectKeywordBlock)(NSString *vcName, NSDictionary *params, NSString* searchFrom);
@property (nonatomic, strong) CSearchKeyModel *curModel;

///保存搜索历史
- (void)saveSearchHistory:(CSearchKeyData *)data;

//删除搜索历史
- (void)removeSearchHistory;

///更新搜索
- (void)updateHistoryList;


@end

NS_ASSUME_NONNULL_END
