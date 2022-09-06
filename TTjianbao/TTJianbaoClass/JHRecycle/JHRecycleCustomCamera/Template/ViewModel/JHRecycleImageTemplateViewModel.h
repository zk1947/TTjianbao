//
//  JHRecycleImageTemplateViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleImageTemplateCellViewModel.h"
#import "JHRecycleTemplateImageModel.h"
#import "JHAssetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleImageTemplateViewModel : NSObject
/// items
@property (nonatomic, strong) NSArray<JHRecycleImageTemplateCellViewModel *> *itemList;
/// 刷新
@property (nonatomic, strong) RACSubject *reloadData;
/// cell type
@property (nonatomic, assign) RecycleTemplateCellType type;
/// 进度-已完成数
@property (nonatomic, assign) NSInteger finishNum;
/// 进度-总数
@property (nonatomic, assign) NSInteger totalNum;
/// 显示重拍
@property (nonatomic, strong) RACSubject<NSNumber *> *showRemake;
/// 当前选中的下标
@property (nonatomic, assign) NSInteger currentIndex;
/// 当前选中的
@property (nonatomic, strong) JHRecycleImageTemplateCellViewModel *currentViewModel;

@property (nonatomic, strong) RACSubject<NSString *> *deleteAssetModelSubject;

- (instancetype)initWithType : (RecycleTemplateCellType)type;
/// 拍照后 将资源显示出来
- (BOOL)setupAssetModel : (JHAssetModel *)assetModel;
/// 删除选中资源
- (void)deleteImageWithAssetModel : (JHAssetModel *)assetModel;

@end

NS_ASSUME_NONNULL_END
