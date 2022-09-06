//
//  JHSkinModel.h
//  TTjianbao
//
//  Created by YJ on 2020/12/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSkinModel : NSObject

@property (copy, nonatomic) NSString *name;
/// 0 - 图片 1 - 其它
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *corner;
@property (copy, nonatomic) NSString *useName;
@property (assign, nonatomic) BOOL isChange;

@end

NS_ASSUME_NONNULL_END
