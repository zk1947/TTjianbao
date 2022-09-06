//
//  JHSearchAssociateModel.h
//  TTjianbao
//
//  Created by liuhai on 2021/10/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSearchHotWordModel : NSObject
@property (strong,nonatomic)NSString* id;
@property (strong,nonatomic)NSString* sort;
@property (strong,nonatomic)NSString * word;
@end

@interface JHSearchAssociateModel : NSObject
@property (strong,nonatomic)NSString* num;
@property (strong,nonatomic)NSString * word;
@end

NS_ASSUME_NONNULL_END
