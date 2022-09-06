//
//  AdressMode.h
//  TaoDangPuMall
//
//  Created by jiangchao on 2017/1/20.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdressMode : NSObject
@property (strong,nonatomic)NSString * ID;
@property (strong,nonatomic)NSString * province;
@property (strong,nonatomic)NSString * city;
@property (strong,nonatomic)NSString * county;
@property (strong,nonatomic)NSString * detail;
@property (strong,nonatomic)NSString * phone;
@property (strong,nonatomic)NSString * receiverName;
@property (assign,nonatomic)BOOL  isDefault;
@end
