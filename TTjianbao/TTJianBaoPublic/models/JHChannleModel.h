//
//  JHChannleModel.h
//  TTjianbao
//
//  Created by YJ on 2020/12/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHChannleModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *isDefault;
@property (nonatomic, copy) NSString *notSelectedIcon;
@property (nonatomic, copy) NSString *selectedIcon;
@property (nonatomic, copy) NSString *ID;
@property (assign, nonatomic) BOOL isSelected;


@end

NS_ASSUME_NONNULL_END
