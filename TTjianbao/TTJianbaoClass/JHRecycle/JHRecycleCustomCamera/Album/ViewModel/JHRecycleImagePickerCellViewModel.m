//
//  JHRecycleImagePickerImageCellViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleImagePickerCellViewModel.h"

@implementation JHRecycleImagePickerCellViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}

- (void)setupData {
    CGFloat width = floor((ScreenW - ItemSpace * 4.f) / 3.f);
    self.itemSize = CGSizeMake(width, width);
}
- (void)setAssetModel:(JHAssetModel *)assetModel {
    _assetModel = assetModel;
    [assetModel setupThumbnailImage];
    self.localIdentifier = assetModel.localIdentifier;
    if (assetModel.asset.mediaType == PHAssetMediaTypeVideo && assetModel.asset.duration > 0) {
        NSTimeInterval duration = assetModel.asset.duration;
        
        int s = (int)(duration) % 60;
        int m = (int)(duration / 60.0);
    
        self.videoDuration = [NSString stringWithFormat:@"%02d:%02d", m, s];
    }
}

@end
