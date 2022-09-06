//
//  JHRecycleSquareSelectMenuModel.h
//  TTjianbao
//
//  Created by hao on 2021/7/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///list
@interface JHRecycleSquareSelectMenuListModel : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL selected;
@end


@interface JHRecycleSquareSelectMenuModel : NSObject
///分类
@property(nonatomic, strong) NSArray<JHRecycleSquareSelectMenuListModel *> *categorys;
///高货
@property(nonatomic, strong) NSArray<JHRecycleSquareSelectMenuListModel *> *highQualityDicts;
///来源
@property(nonatomic, strong) NSArray<JHRecycleSquareSelectMenuListModel *> *sourceDicts;
@end

NS_ASSUME_NONNULL_END
