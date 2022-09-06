//
//  JHMallCateViewModel.h
//  TTjianbao
//
//  Created by apple on 2020/7/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JHMallCateModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHMallCateViewModel : NSObject
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *Id;
@property (nonatomic, assign) CGFloat  cellWidth;
@property (nonatomic, assign) CGFloat  cellHeight;
@property (nonatomic, strong) UIFont  *titleFont;
+(JHMallCateViewModel *)setViewModelWithModel:(JHMallCateModel *)model;
@end

NS_ASSUME_NONNULL_END
