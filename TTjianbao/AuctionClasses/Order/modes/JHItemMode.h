//
//  JHItemMode.h
//  TTjianbao
//
//  Created by jiang on 2019/11/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHItemMode : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *desc;
@property (nonatomic, copy)NSString * value;
@property (nonatomic, assign)BOOL mediumFont;
@property (nonatomic, strong)UIColor *valueColor;
@end

NS_ASSUME_NONNULL_END
