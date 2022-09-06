//
//  JHRecycleTemplateImageModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void (^ ImageHandle)(UIImage *image);

@interface JHRecycleTemplateImageModel : NSObject
/// 缩略图
@property (nonatomic, strong) UIImage *thumbnailImage;
/// 模板-标题
@property (nonatomic, copy) NSString *titleText;
/// 资源
@property (nonatomic, strong) PHAsset *asset;
/// 资源本地标识
@property (nonatomic, copy) NSString *localIdentifier;
/// 是否选中-针对模板相关
@property (nonatomic, assign) BOOL isSelected;


/// 获取原图
- (void)getOriginalImageHandle : (ImageHandle) handle;
@end


