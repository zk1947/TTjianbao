//
//  NOSUpImageTool.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/6.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOSFormData:NSObject

@property (nonatomic, strong) UIImage *fileImage;

@property (nonatomic, copy) NSString *fileDir;

@property (nonatomic, copy) NSString *fileExt;

@property (nonatomic, copy)NSString  *imgUrl ;
@end

@interface NOSUpImageTool : NSObject

+ (instancetype)getInstance;
-(void)upImageWithformData:(NOSFormData *)data
       successBlock:(succeedBlock)success
       failureBlock:(failureBlock)failure;


@end





