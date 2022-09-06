//
//  JHRecycleOrderTemplateCameraViewController.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleNomalCameraViewController.h"
#import "JHRecycleTemplateImageModel.h"
#import "JHRecycleUploadProductBusiness.h"

NS_ASSUME_NONNULL_BEGIN


@interface JHRecycleTemplateCameraViewController : JHRecycleNomalCameraViewController
@property (nonatomic, strong) NSArray<JHRecycleTemplateImageModel *> *templateList;

/// 资源回调
@property (nonatomic, strong) RACSubject<NSArray<JHRecycleTemplateImageModel *> *> *assetHandle;

@property (nonatomic, assign) NSString *firstCategoryName;
@property (nonatomic, assign) NSInteger currentIndex;
@end

NS_ASSUME_NONNULL_END
