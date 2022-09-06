//
//  JHRecyclePhotoInfoModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePhotoInfoModel.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>


@implementation JHRecyclePhotoInfoModel


+ (instancetype)photoInfoModelWithImage:(nullable UIImage *)image andAsset:(PHAsset *)asset{
    JHRecyclePhotoInfoModel *model = [JHRecyclePhotoInfoModel new];
    model.asset = asset;
    model.originalImage = image;
    model.mediaType = asset.mediaType;
    return model;
}

+ (instancetype)photoInfoModelWithTempModel:(JHRecycleTemplateImageModel *)model{
    JHRecyclePhotoInfoModel *photoModel = [JHRecyclePhotoInfoModel new];
    photoModel.mediaType = model.asset.mediaType;
    photoModel.asset = model.asset;
    return photoModel;
}

- (void)dealloc{
    NSLog(@"dealloc");
}

@end
