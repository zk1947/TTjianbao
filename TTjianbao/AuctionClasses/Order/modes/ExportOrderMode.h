//
//  ExportOrderMode.h
//  TTjianbao
//
//  Created by jiang on 2019/8/28.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExportOrderMode : NSObject
@property (strong,nonatomic)NSString * createTime;
@property (strong,nonatomic)NSString * docUrl;
@property (strong,nonatomic)NSString * startDate;
@property (strong,nonatomic)NSString * endDate;
@property (strong,nonatomic)NSString * exportDate;
@property (strong,nonatomic)NSString * orderTime;
@property (strong,nonatomic)NSString * sellerCustomerId;
@end

NS_ASSUME_NONNULL_END
