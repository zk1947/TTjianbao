//
//  NetManager.m
//  UnionClient
//
//  Created by jiangchao on 15/10/8.
//  Copyright © 2015年 jiangchao. All rights reserved.
//

#import "NetManager.h"
#import "AppDelegate.h"
@implementation NetManager
{
    
}
static NetManager *net;

+(NetManager*)sharedInstance{
    
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
           
        net=[[NetManager alloc]init];
        
        });
    
          return net;
    
}
-(void)POST:(NSString*)url Parameters:(id )parameters success:(void(^)( NSDictionary *jsonDic))success
    failure:(void(^) ( NSError      *error ))failure{
   
    NSString* token=[[NSUserDefaults standardUserDefaults] objectForKey:IDTOKEN];
    NSLog(@"token==%@",token);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic=[NSDictionary dictionaryWithDictionary:responseObject];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rootDic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        
        NSLog(@"post==%@",jsonString);
        if ([[rootDic objectForKey:@"code"] isEqualToString:@"K-000009"] ) {
            [[NSUserDefaults standardUserDefaults] setObject:OFFLINE forKey:LOGINSTATUS ];
            [[NSUserDefaults standardUserDefaults]synchronize];
         
        }
        success(rootDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"post%@",error);
       [ShowMessage showMessage:@"网络连接错误"];
        failure(error);
        
    }];

}
-(void)POST:(NSString*)url JsonParameters:(id)parameters success:(void(^)( NSDictionary *jsonDic))success
    failure:(void(^) ( NSError      *error ))failure{
    
    NSString* token=[[NSUserDefaults standardUserDefaults] objectForKey:IDTOKEN];
    NSLog(@"token==%@",token);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
  
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic=[NSDictionary dictionaryWithDictionary:responseObject];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rootDic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        
        NSLog(@"post==%@",jsonString);
        if ([[rootDic objectForKey:@"code"] isEqualToString:@"K-000009"] ) {
            [[NSUserDefaults standardUserDefaults] setObject:OFFLINE forKey:LOGINSTATUS ];
            [[NSUserDefaults standardUserDefaults]synchronize];
        
        }
             success(rootDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
    
}

-(void)GET:(NSString*)url Parameters:(id )parameters success:(void(^)( NSDictionary *jsonDic))success
   failure:(void(^) ( NSError      *error ))failure{
    
    NSString* token=[[NSUserDefaults standardUserDefaults] objectForKey:IDTOKEN];
    NSLog(@"token==%@",token);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
       [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic=[NSDictionary dictionaryWithDictionary:responseObject];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rootDic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];

        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        NSLog(@"get==%@",jsonString);
        
        if ([[rootDic objectForKey:@"code"] isEqualToString:@"K-000009"] ) {
            [[NSUserDefaults standardUserDefaults] setObject:OFFLINE forKey:LOGINSTATUS ];
            [[NSUserDefaults standardUserDefaults]synchronize];
          
        }
     
        success(rootDic);

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"get==%@",error);
       [ShowMessage showMessage:@"网络连接错误"];
        failure(error);
        
    }];
    
}
-(void)PUT:(NSString*)url Parameters:(id )parameters success:(void(^)( NSDictionary *jsonDic))success
            failure:(void(^) ( NSError      *error ))failure{
    
    NSString* token=[[NSUserDefaults standardUserDefaults] objectForKey:IDTOKEN];
    NSLog(@"token==%@",token);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic=[NSDictionary dictionaryWithDictionary:responseObject];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rootDic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        
        NSLog(@"put==%@",jsonString);
        if ([[rootDic objectForKey:@"code"] isEqualToString:@"K-000009"] ) {
            [[NSUserDefaults standardUserDefaults] setObject:OFFLINE forKey:LOGINSTATUS ];
            [[NSUserDefaults standardUserDefaults]synchronize];
           
            
        }
         success(rootDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"put==%@",error);
        [ShowMessage showMessage:@"网络连接错误"];
       failure(error);
    }];
    
}
-(void)PUT:(NSString*)url JsonParameters:(id )parameters success:(void(^)( NSDictionary *jsonDic))success
   failure:(void(^) ( NSError      *error ))failure{
    
    NSString* token=[[NSUserDefaults standardUserDefaults] objectForKey:IDTOKEN];
    NSLog(@"token==%@",token);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic=[NSDictionary dictionaryWithDictionary:responseObject];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rootDic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        
        NSLog(@"put==%@",jsonString);
        if ([[rootDic objectForKey:@"code"] isEqualToString:@"K-000009"] ) {
            [[NSUserDefaults standardUserDefaults] setObject:OFFLINE forKey:LOGINSTATUS ];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
        }
         success(rootDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"put==%@",error);
       [ShowMessage showMessage:@"网络连接错误"];
        failure(error);
    }];
    
}

-(void)DELETE:(NSString*)url Parameters:(id )parameters success:(void(^)( NSDictionary *jsonDic))success
   failure:(void(^) ( NSError      *error ))failure{
    
    NSString* token=[[NSUserDefaults standardUserDefaults] objectForKey:IDTOKEN];
    NSLog(@"token==%@",token);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [manager DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic=[NSDictionary dictionaryWithDictionary:responseObject];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rootDic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        NSLog(@"delete==%@",jsonString);
        if ([[rootDic objectForKey:@"code"] isEqualToString:@"K-000009"] ) {
            [[NSUserDefaults standardUserDefaults] setObject:OFFLINE forKey:LOGINSTATUS ];
            [[NSUserDefaults standardUserDefaults]synchronize];
        
            
        }
         success(rootDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"delete==%@",error);
       [ShowMessage showMessage:@"网络连接错误"];
        failure(error);
    }];
    
}
@end
