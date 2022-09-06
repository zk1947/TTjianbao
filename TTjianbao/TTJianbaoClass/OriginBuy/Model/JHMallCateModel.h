//
//  JHMallCateModel.h
//  TTjianbao
//
//  Created by jiangchao on 2020/7/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMallCateModel : NSObject <NSCoding>
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *notSelectedIcon;
@property (nonatomic, strong) NSString  *selectedIcon;
@property (nonatomic, strong) NSString  *Id;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
