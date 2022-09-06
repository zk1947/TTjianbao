//
//  NetManager.h
//  UnionClient
//
//  Created by jiangchao on 15/10/8.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject
+(NetManager*)sharedInstance;

-(void)POST:(NSString*)url Parameters:(id )parameters success:(void(^)( NSDictionary *jsonDic))success
    failure:(void(^) ( NSError      *error ))failure;

//json 格式
-(void)POST:(NSString*)url JsonParameters:(id)parameters success:(void(^)( NSDictionary *jsonDic))success
    failure:(void(^) ( NSError      *error ))failure;



-(void)GET:(NSString*)url Parameters:(id )parameters success:(void(^)( NSDictionary *jsonDic))success
   failure:(void(^) ( NSError      *error ))failure;

-(void)PUT:(NSString*)url Parameters:(id )parameters success:(void(^)( NSDictionary *jsonDic))success
   failure:(void(^) ( NSError      *error ))failure;

-(void)PUT:(NSString*)url JsonParameters:(id )parameters success:(void(^)( NSDictionary *jsonDic))success
   failure:(void(^) ( NSError      *error ))failure;


-(void)DELETE:(NSString*)url Parameters:(NSDictionary* )parameters success:(void(^)( NSDictionary *jsonDic))success
      failure:(void(^) ( NSError      *error ))failure;

@end
