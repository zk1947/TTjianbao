//
//  JHCustomizeChooseViewController.h
//  TTjianbao
//
//  Created by user on 2020/11/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewExtController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeChooseViewController : JHBaseViewExtController<JXCategoryListContentViewDelegate>
@property(nonatomic, assign) NSInteger ID;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *img;
@property(nonatomic, assign) int       currentIndex;
@end

NS_ASSUME_NONNULL_END
