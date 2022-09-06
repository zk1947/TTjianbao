//
//  NTESPresent.h
//  TTjianbao
//
//  Created by chris on 16/3/29.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTESPresent : NSObject

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *icon;

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger orderNum;


@end
