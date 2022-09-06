//
//  JHPublishSourceItemModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/5/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPhotoCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPublishSourceItemModel : JHPhotoItemModel

@property (nonatomic, copy) NSString *sourceUrl;

@property (nonatomic, copy) NSString *coverUrl;

@property (nonatomic, copy) NSString *videoPath;

@property (nonatomic, assign) BOOL isNetwork;

@end

NS_ASSUME_NONNULL_END
