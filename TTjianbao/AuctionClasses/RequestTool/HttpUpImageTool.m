

#import "HttpUpImageTool.h"
#import <AFNetworking.h>
#import "TTjianbaoMarcoKeyword.h"

@implementation HttpUpImageTool


+ (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
      formDataArray:(NSArray *)formDataArray
       successBlock:(succeedBlock)success
       failureBlock:(failureBlock)failure {
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = 60;
    mgr.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSString* token=[[NSUserDefaults standardUserDefaults] objectForKey:IDTOKEN];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];

    NSString *finalURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    // 2.发送请求
    [mgr POST:finalURL parameters:params headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (KGFormData *tempFormData in formDataArray) {
            [formData appendPartWithFileData:tempFormData.data name:tempFormData.name fileName:tempFormData.filename mimeType:tempFormData.mimeType];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (success) {
            success([self getResponseObjcWithTask:responseObject]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

+ (id)getResponseObjcWithTask:(id )responseObect{
    id json;
    NSError *error;
    json = [NSJSONSerialization JSONObjectWithData:responseObect options:0 error:&error];
    if (error) {
        json = [[NSString alloc] initWithData:responseObect encoding:NSUTF8StringEncoding];
    }
    return json;
}
@end

/**
 *  用来封装文件数据的模型
 */
@implementation KGFormData

@end
