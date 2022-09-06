//
//  JHStoneDetailViewModel.h
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseViewModel.h"
#import "CStoneDetailModel.h"
#import "JHGoodResaleListModel.h"
#import "JHMainLiveSmartModel.h"
#import "JHStoneDetailTabelViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoneDetailViewModel : JHBaseViewModel

/// 0:原石回血    1:个人回血
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSDictionary *returnData;

@property (nonatomic, strong) CStoneDetailModel *dataModel;

@property (nonatomic, strong) NSMutableArray<JHStoneDetailTabelViewModel *> *sectionArray;

@property (nonatomic, copy) NSString *stoneId;

/// 求解状态，只有 第一次 网络请求
@property (nonatomic, assign) BOOL isExplained;

-(void)explainAction:(void(^)(void))block;

-(void)buyMethod:(void(^)(id data))block;

@end

NS_ASSUME_NONNULL_END
