//
//  JHStoreDetailImageViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailImageViewModel.h"
#import "UIImage+ImgSize.h"
@interface JHStoreDetailImageViewModel()

@end
@implementation JHStoreDetailImageViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Private Functions
- (void)setupData {
    self.cellType = ImageCell;
}
#pragma mark - Action functions
#pragma mark - Lazy
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    self.height = ScreenW * 200 / 375;
}

@end
