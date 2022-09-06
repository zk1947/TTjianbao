//
//  JHRecyclePhotoLibraryViewController.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHRecycleImagePickerViewController.h"
#import "JHRecycleImageTemplateCellViewModel.h"
#import "JHRecycleImageTemplateViewModel.h"
#import "JHRecycleImageTemplateView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleImagePickerTempViewController : JHRecycleImagePickerViewController

@property (nonatomic, strong) NSArray<JHRecycleImageTemplateCellViewModel *> *itemList;

@property (nonatomic, strong) JHRecycleImageTemplateView *templateView;

/// 资源回调
@property (nonatomic, strong) RACSubject<NSArray<JHRecycleTemplateImageModel *> *> *assetHandle;

@end

NS_ASSUME_NONNULL_END
