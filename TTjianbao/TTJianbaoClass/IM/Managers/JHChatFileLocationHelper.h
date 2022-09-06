//
//  JHChatFileLocationHelper.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHChatFileLocationHelper : NSObject
+ (NSString *)getAppDocumentPath;

+ (NSString *)getAppTempPath;

+ (NSString *)userDirectory;

+ (NSString *)genFilenameWithExt:(NSString *)ext;

+ (NSString *)filepathForVideo:(NSString *)filename;

+ (NSString *)filepathForImage:(NSString *)filename;
@end

NS_ASSUME_NONNULL_END
