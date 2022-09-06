//
//  VideoCateMode.h
//  TTjianbao
//
//  Created by jiangchao on 2019/4/15.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VideoCateMode : NSObject
@property (strong,nonatomic)NSString*ID;
@property (strong,nonatomic)NSString * name;
@property (strong,nonatomic)NSString* sort;
@property (assign,nonatomic)NSInteger type;
@property (strong,nonatomic)NSString  *hotIcon;
@property (assign,nonatomic)BOOL  isDefault;
@end


