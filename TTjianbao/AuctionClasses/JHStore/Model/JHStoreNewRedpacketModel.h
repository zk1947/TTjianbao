//
//  JHStoreNewRedpacketModel.h
//  TTjianbao
//
//  Created by apple on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreNewRedpacketModel : NSObject
@property (nonatomic, copy) NSString *channelLocalId;
@property (nonatomic, assign) BOOL isHasChannel;
@property (nonatomic, copy) NSString *firstImg;
@property (nonatomic, copy) NSString *secondImg;

@end

NS_ASSUME_NONNULL_END
