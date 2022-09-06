//
//  JHRecycleImagePickerViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleImagePickerCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RecycleImagePickerType){
    /// 包括视频，图片
    RecycleImagePickerTypeNomal = 1,
    ///
    RecycleImagePickerTypeImage,
    RecycleImagePickerTypeVideo,
};



@interface JHRecycleImagePickerViewModel : NSObject
@property (nonatomic, strong) NSMutableArray<JHRecycleImagePickerCellViewModel *> *itemList;

@property (nonatomic, strong) RACReplaySubject *reloadData;

@property (nonatomic, assign) RecycleImagePickerType pickerType;

/// 视频最大长度
@property (nonatomic, assign) NSUInteger maxVideoDuration;

- (void)setupSelectedWithList : (NSArray<PHAsset *> *) list;


- (void)getAssetData;
@end

NS_ASSUME_NONNULL_END
