
#import <Foundation/Foundation.h>
#import "HttpUpImageTool.h"

@interface HttpUpImageTool : NSObject

/**
 *  发送一个POST请求(上传文件数据)
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param formDataArray  文件参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url
             params:(NSDictionary *)params
      formDataArray:(NSArray *)formDataArray
       successBlock:(succeedBlock)success
       failureBlock:(failureBlock)failure;
@end


/**
 *  用来封装文件数据的模型
 */
@interface KGFormData : NSObject
/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;
@end
