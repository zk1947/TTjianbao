//
//  JHRecycleImagePickerImageCellViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "JHAssetModel.h"
NS_ASSUME_NONNULL_BEGIN

static const CGFloat ItemSpace = 4.f;

@interface JHRecycleImagePickerCellViewModel : NSObject


@property (nonatomic, strong) JHAssetModel *assetModel;

@property (nonatomic, copy) NSString *localIdentifier;

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) NSString *videoDuration;

@property (nonatomic, assign) BOOL canSelected;

@end

NS_ASSUME_NONNULL_END
