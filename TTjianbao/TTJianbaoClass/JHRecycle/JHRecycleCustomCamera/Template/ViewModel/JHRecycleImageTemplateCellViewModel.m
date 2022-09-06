//
//  JHRecycleImageTemplateBaseViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleImageTemplateCellViewModel.h"

@implementation JHRecycleImageTemplateCellViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"picker-%@ 释放", [self class]);
}
- (void)addImageWithAssetModel : (JHAssetModel *)assetModel {
    self.templateModel.asset = assetModel.asset;
    self.templateModel.thumbnailImage = assetModel.thumbnailImage;
    self.templateModel.localIdentifier = assetModel.localIdentifier;
    self.isSelected = false;
}
- (void)deleteImage {
    self.isSelected = true;
    self.templateModel.thumbnailImage = nil;
    self.templateModel.asset = nil;
//    self.templateModel.localIdentifier = nil;
}
#pragma mark - Private Functions
- (void)setupData {
    
}
#pragma mark - Action functions
#pragma mark - Lazy

- (RACSubject *)selectedEvent {
    if (!_selectedEvent) {
        _selectedEvent = [RACSubject subject];
    }
    return _selectedEvent;
}
- (RACSubject *)deleteEvent {
    if (!_deleteEvent) {
        _deleteEvent = [RACSubject subject];
    }
    return _deleteEvent;
}
@end
