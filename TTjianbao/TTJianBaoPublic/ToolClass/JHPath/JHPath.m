//
//  JHPath.m
//  TTjianbao
//
//  Created by user on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPath.h"

@implementation JHPath
+ (NSString*)bundle {
    return [[NSBundle mainBundle] resourcePath];
}
+ (NSString*)document {
    NSArray  *directoryArr      = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = directoryArr.firstObject;

    return documentDirectory;
}

+ (NSString*)cache {
    NSArray  *directoryArr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

    NSString *cacheDirectory = directoryArr.firstObject;

    return cacheDirectory;
}

+ (NSString*)library {
    NSArray  *directoryArr     = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = directoryArr.firstObject;

    return libraryDirectory;
}

+ (NSString*)temp {
    NSString *tempDirectory = NSTemporaryDirectory();

    return tempDirectory;
}

+ (NSString*)download {
    NSString *documentDirectory = [self document];
    NSString *directory         = [documentDirectory stringByAppendingPathComponent:@"DQVideoDownloadCache"];

    return directory;
}

+ (BOOL)exists:(NSString*)path isDirectory:(BOOL*)isDirectory {
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:isDirectory];

    return exist;
}

+ (BOOL)exists:(NSString*)path {
    BOOL isDirectory = NO;
    BOOL exist       = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];

    return exist;
}

+ (BOOL)mkdir:(NSString*)path {
    @try {
        NSError *error;
        BOOL     result = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result && error) {
            NSLog(@"%@",error);
        }
        return result;
    } @catch (NSException *exception) {
        NSLog(@"exception == %@", [exception description]);
    } @finally {
    }
}

+ (BOOL)rm:(NSString*)path {
    NSFileManager *manager = [NSFileManager defaultManager];

    @try {
        NSError *error;
        BOOL     result = [manager removeItemAtPath:path error:&error];
        if (!result && error) {
            NSLog(@"remove failed. %@",error);
        }
        return result;
    } @catch (NSException *exception) {
        NSLog(@"exception == %@", [exception description]);
    } @finally {
    }
}

+ (BOOL)rm:(NSString*)path error:(NSError**)error {
    NSFileManager *manager = [NSFileManager defaultManager];

    @try {
        BOOL result = [manager removeItemAtPath:path error:error];
        if (!result && error && *error) {
            NSLog(@"remove failed. %@",*error);
        }
        return result;
    } @catch (NSException *exception) {
        NSLog(@"exception == %@", [exception description]);
    } @finally {
    }
}

+ (BOOL)touch:(NSString*)path {
    [self rm:path];
    NSFileManager *manager = [NSFileManager defaultManager];

    BOOL           success = [manager createFileAtPath:path contents:nil attributes:nil];
    if (!success) {
        NSLog(@"create %@ failed", path);
    }

    return success;
}

+ (NSString*)pathForResource:(NSString*)resource {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path       = [mainBundle pathForResource:resource ofType:nil];

    if (!path) {
        NSLog(@"%@ not exsit in mainBundle", resource);
    }

    return path;
}

+ (long long)folderSize:(NSString*)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![self exists:path]) {
        NSLog(@"文件路径 不存在");
        return 0;
    }

    long long fileSize = 0;
    NSArray  *subPaths = [fileManager subpathsAtPath:path];
    if (subPaths) {
        for (NSString*item in subPaths) {
            NSString *fullPath = [path stringByAppendingPathComponent:item];
            fileSize += [self fileSize:fullPath];
        }
    }

    return fileSize;
}

+ (long long)fileSize:(NSString*)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![self exists:path]) {
        return 0;
    }

    NSError      *error;
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:&error];
    if (!fileAttributes && error) {
        NSLog(@"remove failed. %@",error);
    }
    unsigned long long size = fileAttributes.fileSize;

    return size;
}

+ (long long)fileSize:(NSString*)path error:(NSError**)error {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![self exists:path]) {
        return 0;
    }

    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:error];
    if (!fileAttributes && error && *error) {
        NSLog(@"remove failed. %@", *error);
    }

    unsigned long long size = fileAttributes.fileSize;
    return size;
}

@end
