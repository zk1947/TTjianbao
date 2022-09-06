//
//  JHRecycleImageBrowserViewController.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/4/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAssetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleBrowserViewController : JHBaseViewController
@property (nonatomic, strong) JHAssetModel *assetModel;
@property (nonatomic, strong) RACSubject<JHAssetModel *> *assetSubject;
/// 是否允许裁剪
@property (nonatomic, assign) BOOL allowCrop;
@end

NS_ASSUME_NONNULL_END
