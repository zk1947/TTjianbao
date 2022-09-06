//
//  JHUpdateApp.h
//  TTjianbao
//
//  Created by mac on 2019/5/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHUpdateAppModel : NSObject
@property (nonatomic, copy) NSArray *content;// (Array[string], optional): 更新内容 ,
@property (nonatomic, assign) NSInteger isUpDate;// (integer, optional): 是否更新：0没有更新，1建议更新，2强制更新 ,
@property (nonatomic, copy) NSString *latestVersion;// (string, optional): 最新版本 ,
@property (nonatomic, copy) NSString *url;// (string, optional): 更新地址
@end

@interface JHUpdateApp : NSObject
- (void)checkUpdate;
@end
NS_ASSUME_NONNULL_END
