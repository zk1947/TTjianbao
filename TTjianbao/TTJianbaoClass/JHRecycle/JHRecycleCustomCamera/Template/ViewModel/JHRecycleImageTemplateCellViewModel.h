//
//  JHRecycleImageTemplateBaseViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleTemplateImageModel.h"
#import "JHAssetModel.h"

typedef NS_ENUM(NSInteger, RecycleTemplateCellType){
    RecycleTemplateCellTypeNomal,
    RecycleTemplateCellTypeAdd,
};


@interface JHRecycleImageTemplateCellViewModel : NSObject

@property (nonatomic, strong) JHRecycleTemplateImageModel *templateModel;

@property (nonatomic, assign) RecycleTemplateCellType cellType;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) RACSubject *deleteEvent;
@property (nonatomic, strong) RACSubject *selectedEvent;

- (void)addImageWithAssetModel : (JHAssetModel *)assetModel;
- (void)deleteImage;
@end
