//
//  NTESDataManager.h
//  NIM
//
//  Created by amao on 8/13/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESService.h"
#import "NIMSDK/NIMSDK.h"

@class NTESDataUser;

@interface NTESDataManager : NSObject

+ (instancetype)sharedInstance;

- (NTESDataUser *)infoByUser:(NSString *)userId
                 withMessage:(NIMMessage *)message;

@property (nonatomic,strong) UIImage *defaultUserAvatar;

@end


@interface NTESDataUser : NSObject

@property (nonatomic,copy) NSString *showName;

@property (nonatomic,copy) NSString *avatarUrlString;

@property (nonatomic,strong) UIImage *avatarImage;

@end
