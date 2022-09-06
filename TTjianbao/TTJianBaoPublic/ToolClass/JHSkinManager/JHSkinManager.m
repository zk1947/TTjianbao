//
//  JHSkinManager.m
//  test
//
//  Created by YJ on 2020/12/17.
//  Copyright © 2020 YJ. All rights reserved.
//
#import "UIImage+WebP.h"
#import "JHSkinManager.h"
#import "SSZipArchive.h"
#import "JHConst.h"
#import "UIColor+ColorChange.h"

#define USER_DEFAULTS   [NSUserDefaults standardUserDefaults]

#define SKIN_DATA_KEY    @"JH_SKIN_DATA_KEY" //皮肤
#define SKIN_VERSION_KEY @"SKIN_VERSION_KEY" //皮肤版本号
#define SKIN_CHANGE_KEY  @"SKIN_CHANGE_KEY" //换肤指令
#define JIANBAO_SKIN_PATH  @"JIANBAO_SKIN_PATH" //沙盒路径
#define SKIN_STORE_SUCCESS @"SKIN_STORE_SUCCESS"
#define SKIN_FILE_URL   @"SKIN_FILE_URL" //压缩包下载url



static JHSkinManager *manager = nil;

@interface JHSkinManager ()
/// 换肤开关
@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, strong) NSDictionary *params;

@end

@implementation JHSkinManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
        
        NSString *instruction = [USER_DEFAULTS valueForKey:SKIN_CHANGE_KEY];
        manager.isOpen = [instruction boolValue];
    });
    
    return manager;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupKeys];
    }
    return self;
}
/* 请求皮肤data */
+ (void)requeastSkinData
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    NSString *version = [JHSkinManager getSkinVersion];
    if (version.length <= 0 )
    {
        version = @"0";
    }
    
    //NSLog(@"本地的皮肤版本号：%@",version);
    [parameters setValue:version forKey:@"skinVersion"];
    
    NSString *url = FILE_BASE_STRING(@"/app/opt/operation/homePageChangeSkin");
    //NSLog(@"url皮肤版本号---%@",url);
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel * _Nullable respondObject)
    {
        NSDictionary *skinData = respondObject.data;
        //压缩包下载url
        NSString *resourceDataUrl = [skinData valueForKey:@"resourceDataUrl"];
        
        //换肤指令
        NSString *skinStatus = [NSString stringWithFormat:@"%@",[skinData valueForKey:@"skinStatus"]];
        [JHSkinManager storeChangeSkinInstruction:skinStatus];
        
        //皮肤版本号
        NSString *skinVersion = [NSString stringWithFormat:@"%@",[skinData valueForKey:@"skinVersion"]];
        //NSLog(@"返回的皮肤版本号：%@",version);
        //skinStatus判断为1时，皮肤版本号才有值，否则皮肤版本号为nil
        if ([skinStatus intValue] == 1)
        {
            [JHSkinManager storeSkinVersion:skinVersion];
            
            if (resourceDataUrl.length > 0 && ![resourceDataUrl isKindOfClass:[NSNull class]] && resourceDataUrl != nil)
            {
                //存储皮肤data
                [JHSkinManager storeSkinData:skinData[@"skinBody"]];
                [JHSkinManager storeFileURL:resourceDataUrl];
                //下载压缩包并解压
                [JHSkinManager downLoadSkinResourcePack:resourceDataUrl];
            }
        }else {
            if ([JHSkinManager shareManager].downloadSuccessHandler) {
                [JHSkinManager shareManager].downloadSuccessHandler();
            }
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject)
    {
        if ([JHSkinManager shareManager].downloadSuccessHandler) {
            [JHSkinManager shareManager].downloadSuccessHandler();
        }
    }];
}
/// 获取 换肤数据
+ (JHSkinModel *)getSkinInfoWithType : (JHSkinType)type {
    JHSkinModel *model = nil;
    NSString *key = [[JHSkinManager shareManager] getSkinKeyWithType:type];
    model = [JHSkinManager getSkinModel: key];
    return model;
}
+ (UIImage *)getImageWithName : (NSString *)name{
    return [JHSkinManager getImageWithName:name scaleSize:CGSizeMake(0, 0)];
}
+ (UIImage *)getImageWithPath : (NSString *)path{
    
    return [JHSkinManager getImageWithPath:path scaleSize:CGSizeMake(0, 0)];
}
+ (UIImage *)getImageWithName : (NSString *)name scaleSize : (CGSize)size{
    NSData *data = [NSData dataNamed:name];
    
    UIImage *image = nil;
    
    if ([name hasSuffix:@".webp"]) {
        image = [self getImageWebpWithData: data];
    }else if ([name hasSuffix:@".gif"]) {
        image = [self getImageGifWithData: data];
    }else {
        image = [UIImage imageNamed: name];
        if (size.height > 0) {
            image = [self scaleToSize:image size:size];
        }
    }
    return image;
}
+ (UIImage *)getImageWithPath : (NSString *)path scaleSize : (CGSize)size{
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    UIImage *image = nil;
    
    if ([path hasSuffix:@".webp"]) {
        image = [self getImageWebpWithData: data];
    }else if ([path hasSuffix:@".gif"]) {
        image = [self getImageGifWithData: data];
    }else {
        image = [UIImage imageWithContentsOfFile :path];
        if (size.height > 0) {
            image = [self scaleToSize:image size:size];
        }
    }
    
    return image;
}
+ (UIImage *)getImageWebpWithData : (NSData *)data {
    UIImage *image = [UIImage sd_imageWithWebPData:data];
    return image;
}
+ (UIImage *)getImageGifWithData : (NSData *)data {
    UIImage *image = [UIImage sd_imageWithGIFData:data];
    return image;
}
- (NSString *)getSkinKeyWithType : (JHSkinType)type {
    NSString *key = nil;
    
    NSString *k = [NSString stringWithFormat:@"%lu",(unsigned long)type];
    
    key = [self.params stringValueForKey:k default:nil];
    return key;
}
// 设置皮肤KEY 字典
- (void)setupKeys {
    self.params = @{
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeTitle] : @"liveShopping",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeNavi] : @"entiretyHead",
        
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeSign] : @"signIcon",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeCategory] : @"cateIcon",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeBGHome] : @"entiretyBody",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeLiveIcon] : @"liveBottom",
        
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeMessage] : @"message",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeMessageNumBg] : @"redBottom",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeMessageNumTitle] : @"numColor",
    
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeBarTitle] : @"bottomNavigation",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeBarIndex0] : @"oneDefini",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeBarIndex1] : @"twoDefini",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeBarIndex2] : @"newThreeDefini",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeBarIndex3] : @"fourDefini",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeBarIndex4] : @"fiveDefini",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeBarGoTop] : @"top",
        
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypePlatformTitle] : @"platformFont",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypePlatformBg] : @"platformBottom",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypePlatformRight] : @"platformRight",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypePlatform0] : @"sourceLive",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypePlatform1] : @"experts",
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypePlatform2] : @"exchange",
        
        [NSString stringWithFormat:@"%lu",(unsigned long)JHSkinTypeVajraTitle] : @"kimFont",
    };
}


/* 皮肤data存储 */
+ (void)storeSkinData:(NSDictionary *)data
{
    [USER_DEFAULTS setObject:data forKey:SKIN_DATA_KEY];
    [USER_DEFAULTS synchronize];
}
/* 读取皮肤data */
+ (NSDictionary *)getSkinData
{
    NSDictionary *dic = [NSDictionary new];
    dic = [USER_DEFAULTS valueForKey:SKIN_DATA_KEY];
    return dic;
}

+ (NSString *)getSkinVersion
{
    //获取本地存储的版本号
    NSString *version = [USER_DEFAULTS valueForKey:SKIN_VERSION_KEY];
    return version;
}

+ (void)storeSkinVersion:(NSString *)version
{
    [USER_DEFAULTS setObject:version forKey:SKIN_VERSION_KEY];
    [USER_DEFAULTS synchronize];
}

/* clear皮肤data以及相关标识 */
+ (void)clearSkinData
{
    //清除皮肤data
    NSDictionary *dic = [NSDictionary new];
    [USER_DEFAULTS setObject:dic forKey:SKIN_DATA_KEY];
    [USER_DEFAULTS synchronize];
    
    //清除换肤指令
    [USER_DEFAULTS setObject:store_type forKey:SKIN_CHANGE_KEY];
    [USER_DEFAULTS synchronize];
    
    //清除皮肤版本号
    [USER_DEFAULTS setObject:store_type forKey:SKIN_VERSION_KEY];
    [USER_DEFAULTS synchronize];
}

+ (JHSkinModel *)getSkinModel:(NSString *)key
{
    NSDictionary *dic = [JHSkinManager skinValueForKey:key];
    JHSkinModel *model = [JHSkinModel mj_objectWithKeyValues:dic];
    model.isChange = [JHSkinManager isChangeSkin];
    return model;
}

+ (NSDictionary *)skinValueForKey:(NSString *)key
{
    NSDictionary *data = [JHSkinManager getSkinData];
    NSDictionary *dic = [data valueForKey:key];
    return dic;
}


+ (BOOL)isChangeSkin
{
    return [JHSkinManager shareManager].isOpen;
}

/* 存储换肤指令 */
+ (void)storeChangeSkinInstruction:(NSString *)instruction
{
    [USER_DEFAULTS setObject:instruction forKey:SKIN_CHANGE_KEY];
    [USER_DEFAULTS synchronize];
    
    [JHSkinManager shareManager].isOpen = [instruction boolValue];
}

/* 下载皮肤资源包，解压，本地存储 */
+ (void)downLoadSkinResourcePack:(NSString *)url
{
    NSURL *URL = [NSURL URLWithString:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSURLSessionTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress)
    {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response)
    {
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
       //NSLog(@"文件路径:%@", cachePath);
        NSString *path = [cachePath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error)
    {
        NSString *zipPath = [filePath path];
        NSLog(@"压缩包路径：%@",zipPath);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *documentsDirectory = [path objectAtIndex:0];
        NSString *skinPath = [documentsDirectory stringByAppendingPathComponent:JIANBAO_SKIN_PATH];
        
        //先删除删除旧有路径，创建新路径
//        BOOL exist = [fileManager fileExistsAtPath:skinPath];
//        if (exist)
//        {
//            [fileManager removeItemAtPath:skinPath error:nil];
//        }
        
        [fileManager createDirectoryAtPath:skinPath withIntermediateDirectories:YES attributes:nil error:nil];
        [SSZipArchive unzipFileAtPath:zipPath toDestination:skinPath];
        //NSLog(@"压缩包解压后路径：%@",skinPath);
        if (!error && [JHSkinManager shareManager].downloadSuccessHandler) {
            [JHSkinManager shareManager].downloadSuccessHandler();
        }
    }];
    
    [downloadTask resume];
}

/* 获取解压后所有图片文件路径 */
+ (NSMutableArray *)getImagesPathWithSkinPath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *skinPath = [documentsDirectory stringByAppendingPathComponent:JIANBAO_SKIN_PATH];
    
    NSString *newSkinPath = [NSString stringWithFormat:@"%@/%@",skinPath,[JHSkinManager getFileName]];
    //NSLog(@"图片路径：%@",skinPath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *imagesName = [fileManager contentsOfDirectoryAtPath:newSkinPath error:nil];
    
    NSMutableArray *imagesPathArray = [NSMutableArray new];
    
    if (imagesName.count > 0)
    {
        for (int i = 0 ; i < imagesName.count; i++)
        {
            NSString *imageName = imagesName[i];
            NSString *imagePath = [skinPath stringByAppendingString:[NSString stringWithFormat:@"/%@/%@",[JHSkinManager getFileName],imageName]];
            [imagesPathArray addObject:imagePath];
        }
    }

    return imagesPathArray;
}

/* 根据图片name获取图片路径 */
+ (NSString *)getImageFilePath:(NSString *)imageNamed
{
    NSString *path = @"";
    NSMutableArray *imagesPath = [JHSkinManager getImagesPathWithSkinPath];
    for (int i = 0; i<imagesPath.count; i++)
    {
        NSString *imagePath = imagesPath[i];
        NSString *name = [imagePath lastPathComponent];
        if ([name isEqualToString:imageNamed])
        {
            path = imagePath;
        }
    }
    
    return path;
}

/* 解压完毕并存储是否成功 */
+ (BOOL)isStoreSuccess
{
    NSString *skin_store_success = [USER_DEFAULTS valueForKey:SKIN_STORE_SUCCESS];
    if ([skin_store_success intValue] == 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (void)storeSkinImagePath:(NSString *)imagePath forKey:(NSString *)imageName
{
    [USER_DEFAULTS setObject:imagePath forKey:imageName];
    [USER_DEFAULTS synchronize];
}

+ (NSString *)getSkinImagePath:(NSString *)imageName
{
    NSString *imagePath = [USER_DEFAULTS valueForKey:imageName];
    return imagePath;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [JHSkinManager shareManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [JHSkinManager shareManager];
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [JHSkinManager shareManager];
}

- (BOOL)isDictionary:(NSDictionary *)dic
{
   if (dic != nil && ![dic isKindOfClass:[NSNull class]] && ![dic isEqual:[NSNull null]])
   {
       return YES;
   }
   else
   {
       return NO;
   }
}

/* 获取压缩包包名 */
+ (NSString *)getFileName
{
    NSString *url = [JHSkinManager getFileURL];
    //要判断url是否是有效
    NSString *fileName = [[url lastPathComponent] stringByDeletingPathExtension];
    return fileName;
}

+ (void)storeFileURL:(NSString *)url
{
    [USER_DEFAULTS setObject:url forKey:SKIN_FILE_URL];
    [USER_DEFAULTS synchronize];
}

+ (NSString *)getFileURL
{
    return [USER_DEFAULTS valueForKey:SKIN_FILE_URL];
}
+ (BOOL)getImagePathExtension:(NSString *)imageName
{
    NSString *str = [imageName pathExtension];
    if ([str isEqualToString:@"gif"] || [str isEqualToString:@"webp"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    //UIGraphicsBeginImageContext(size);
    //UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//
///* 文玩社区tabBar未选中image */
//+ (UIImage *)getCommunityUnselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"home_newtable_nomal"];
//
//    JHSkinModel *model = [JHSkinManager oneDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            //image = [UIImage imageWithContentsOfFile:imagePath];
//            //image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//            image = [UIImage sd_imageWithWebPData:[NSData dataWithContentsOfFile:imagePath]];
//        }
//    }
//    return image;
//}
//
///* 文玩社区tabBar选中image */
//+ (UIImage *)getCommunityselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"home_newtable_select"];
//
//    JHSkinModel *model = [JHSkinManager oneDefini];
//
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.useName;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            //image = [UIImage imageWithContentsOfFile:imagePath];
//            //image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//            image = [UIImage sd_imageWithWebPData:[NSData dataWithContentsOfFile:imagePath]];
//        }
//    }
//    return image;
//}
//
///* 文玩社区tabBar未选中字色 */
//+ (UIColor *)getCommunityUnselectedColor
//{
//    UIColor *color = [UIColor colorWithHexString:@"kColor222"];
//
//    JHSkinModel *model = [JHSkinManager oneDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 1)
//        {
//            color = [UIColor colorWithHexString:model.name];
//        }
//    }
//    return color;
//}
//
///* 文玩社区tabBar选中字色 */
//+ (UIColor *)getCommunityselectedColor
//{
//    UIColor *color = [UIColor colorWithHexString:@"kColor222"];
//
//    JHSkinModel *model = [JHSkinManager oneDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 1)
//        {
//            color = [UIColor colorWithHexString:model.useName];
//        }
//    }
//    return color;
//}
//
///* 源头直购tabBar未选中image */
//+ (UIImage *)getLiveBroadcastUnselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"mall_newtable_nomal"];
//
//    JHSkinModel *model = [JHSkinManager twoDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            //image = [UIImage imageWithContentsOfFile:imagePath];
//            //image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//            image = [UIImage sd_imageWithWebPData:[NSData dataWithContentsOfFile:imagePath]];
//        }
//    }
//    return image;
//}
//
///* 源头直购tabBar选中image */
//+ (UIImage *)getLiveBroadcastselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"mall_newtable_select"];
//
//    JHSkinModel *model = [JHSkinManager twoDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.useName;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//        }
//    }
//
//    return image;
//}
//
///* 在线鉴定tabBar未选中image */
//+ (UIImage *)getOnlineIdentificationUnselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"appraisal_newtable_nomal"];
//
//    JHSkinModel *model = [JHSkinManager fourDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//        }
//    }
//
//    return image;
//}
//
///* 在线鉴定tabBar选中image */
//+ (UIImage *)getOnlineIdentificationselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"appraisal_newtable_select"];
//
//    JHSkinModel *model = [JHSkinManager fourDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.useName;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//        }
//    }
//
//    return image;
//}
//
///* 个人中心tabBar未选中image */
//+ (UIImage *)getPersonalCenterUnselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"my_newtable_nomal"];
//
//    JHSkinModel *model = [JHSkinManager fiveDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//        }
//    }
//    return image;
//}
//
///* 个人中心tabBar选中image */
//+ (UIImage *)getPersonalCenterselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"my_newtable_select"];
//
//    JHSkinModel *model = [JHSkinManager fiveDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.useName;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//        }
//    }
//    return image;
//}
//
///* 搜索 */
//+ (UIImage *)getSearchImage
//{
//    UIImage *image = [UIImage imageNamed:@"navi_icon_search"];
//
//    JHSkinModel *model = [JHSkinManager search];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(23, 23)];
//        }
//    }
//    return image;
//}
//
///* 签到未签时图片 */
//+ (UIImage *)getSignBeforeImage
//{
//    UIImage *image = [UIImage imageNamed:@"navi_icon_sign"];
//
//    JHSkinModel *model = [JHSkinManager sign];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
//            image = [UIImage sd_imageWithGIFData:imageData];
//        }
//    }
//    return image;
//}
//
///* 签到已签时图片 */
//+ (UIImage *)getSignAfterImage
//{
//    UIImage *image = [UIImage imageNamed:@"navi_icon_sign"];
//
//    JHSkinModel *model = [JHSkinManager sign];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.useName;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(23, 23)];
//        }
//    }
//    return image;
//}



///* 文玩社区tabBar未选中image */
//+ (UIImage *)getCommunityUnselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"home_newtable_nomal"];
//
//    JHSkinModel *model = [JHSkinManager oneDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            //image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//            image = [UIImage sd_imageWithWebPData:[NSData dataWithContentsOfFile:imagePath]];
//        }
//    }
//    return image;
//}
//
///* 文玩社区tabBar选中image */
//+ (UIImage *)getCommunityselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"home_newtable_select"];
//
//    JHSkinModel *model = [JHSkinManager oneDefini];
//
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.useName;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            //image = [UIImage imageWithContentsOfFile:imagePath];
//            //image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//            image = [UIImage sd_imageWithWebPData:[NSData dataWithContentsOfFile:imagePath]];
//        }
//    }
//    return image;
//}
//
///* 文玩社区tabBar未选中字色 */
//+ (UIColor *)getCommunityUnselectedColor
//{
//    UIColor *color = [UIColor colorWithHexString:@"kColor222"];
//
//    JHSkinModel *model = [JHSkinManager oneDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 1)
//        {
//            color = [UIColor colorWithHexString:model.name];
//        }
//    }
//    return color;
//}
//
///* 文玩社区tabBar选中字色 */
//+ (UIColor *)getCommunityselectedColor
//{
//    UIColor *color = [UIColor colorWithHexString:@"kColor222"];
//
//    JHSkinModel *model = [JHSkinManager oneDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 1)
//        {
//            color = [UIColor colorWithHexString:model.useName];
//        }
//    }
//    return color;
//}
//
///* 源头直购tabBar未选中image */
//+ (UIImage *)getLiveBroadcastUnselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"mall_newtable_nomal"];
//
//    JHSkinModel *model = [JHSkinManager twoDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            //image = [UIImage imageWithContentsOfFile:imagePath];
//            //image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//            image = [UIImage sd_imageWithWebPData:[NSData dataWithContentsOfFile:imagePath]];
//        }
//    }
//    return image;
//}
//
///* 源头直购tabBar选中image */
//+ (UIImage *)getLiveBroadcastselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"mall_newtable_select"];
//
//    JHSkinModel *model = [JHSkinManager twoDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.useName;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//        }
//    }
//
//    return image;
//}
//
///* 在线鉴定tabBar未选中image */
//+ (UIImage *)getOnlineIdentificationUnselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"appraisal_newtable_nomal"];
//
//    JHSkinModel *model = [JHSkinManager fourDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//        }
//    }
//
//    return image;
//}
//
///* 在线鉴定tabBar选中image */
//+ (UIImage *)getOnlineIdentificationselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"appraisal_newtable_select"];
//
//    JHSkinModel *model = [JHSkinManager fourDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.useName;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//        }
//    }
//
//    return image;
//}
//
///* 个人中心tabBar未选中image */
//+ (UIImage *)getPersonalCenterUnselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"my_newtable_nomal"];
//
//    JHSkinModel *model = [JHSkinManager fiveDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//        }
//    }
//    return image;
//}
//
///* 个人中心tabBar选中image */
//+ (UIImage *)getPersonalCenterselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"my_newtable_select"];
//
//    JHSkinModel *model = [JHSkinManager fiveDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.useName;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//        }
//    }
//    return image;
//}
//
///* 搜索 */
//+ (UIImage *)getSearchImage
//{
//    UIImage *image = [UIImage imageNamed:@"navi_icon_search"];
//
//    JHSkinModel *model = [JHSkinManager search];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(23, 23)];
//        }
//    }
//    return image;
//}
//
///* 签到未签时图片 */
//+ (UIImage *)getSignBeforeImage
//{
//    UIImage *image = [UIImage imageNamed:@"navi_icon_sign"];
//
//    JHSkinModel *model = [JHSkinManager sign];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//
//            NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
//            image = [UIImage sd_imageWithGIFData:imageData];
//
//        }
//    }
//    return image;
//}
//
///* 签到已签时图片 */
//+ (UIImage *)getSignAfterImage
//{
//    UIImage *image = [UIImage imageNamed:@"navi_icon_sign"];
//
//    JHSkinModel *model = [JHSkinManager sign];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.useName;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(23, 23)];
//        }
//    }
//    return image;
//}
//+ (UIImage *)getCategoryImage {
//    UIImage *image = [UIImage imageNamed:@"search_class_icon"];
//
//    JHSkinModel *model = [JHSkinManager category];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//        }
//    }
//    return image;
//}
///* 消息 */
//+ (UIImage *)getMessageImage
//{
//    UIImage *image = [UIImage imageNamed:@"navi_icon_message"];
//
//    JHSkinModel *model = [JHSkinManager message];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(22, 22)];
//        }
//    }
//    return image;
//}
//
///* 源头直播低价购image  */
//+ (UIImage *)getSourceLiveImage
//{
//    UIImage *image = [UIImage imageNamed:@"mall_home_address"];
//
//    JHSkinModel *model = [JHSkinManager sourceLive];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//        }
//    }
//    return image;
//}
//
///* 专家逐件把关image  */
//+ (UIImage *)getExpertsImage
//{
//    UIImage *image = [UIImage imageNamed:@"mall_home_door"];
//
//    JHSkinModel *model = [JHSkinManager experts];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//        }
//    }
//    return image;
//}
//
///* 7天无理由退换image  */
//+ (UIImage *)getExchangeImage
//{
//    UIImage *image = [UIImage imageNamed:@"mall_home_seven"];
//
//    JHSkinModel *model = [JHSkinManager exchange];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//        }
//    }
//    return image;
//}
//
///* 平台保障右箭头image  */
//+ (UIImage *)getPlatformRightImage
//{
//    UIImage *image = [UIImage imageNamed:@"mall_home_enter"];
//
//    JHSkinModel *model = [JHSkinManager platformRight];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//            image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//        }
//    }
//    return image;
//}
//
///* 直播图标image */
//+ (YYImage *)getLiveBottomImage;
//{
//    YYImage *image = [YYImage imageNamed:@"mall_home_bannar_living.webp"];
//
//    JHSkinModel *model = [JHSkinManager liveBottom];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [YYImage imageWithContentsOfFile:imagePath];
//            //image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//
//            CGSize size = CGSizeMake(SIZE_WIDTH, SIZE_WIDTH);
//            //UIGraphicsBeginImageContext(size);
//            UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
//            [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//            YYImage *scaledImage = (YYImage *)UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            image = scaledImage;
//        }
//    }
//    return image;
//}
//
//
///* 直播购物未选中image */
//+ (UIImage *)getLiveShoppingUnselectedImage
//{
//    UIImage *image = nil;
//    JHSkinModel *model = [JHSkinManager liveShopping];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//        }
//    }
//    return image;
//}
//
///* 直播购物选中image */
//+ (UIImage *)getLiveShoppingselectedImage
//{
//    UIImage *image = nil;
//    JHSkinModel *model = [JHSkinManager liveShopping];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.useName;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//        }
//    }
//    return image;
//}
//
///* 背景body */
//+ (UIImage *)getEntiretyBodyImage
//{
//    UIImage *image = nil;
//    JHSkinModel *model = [JHSkinManager entiretyBody];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//        }
//    }
//    return image;
//}
//
///* 背景head */
//+ (UIImage *)getEntiretyHeadImage
//{
//    UIImage *image = nil;
//    JHSkinModel *model = [JHSkinManager entiretyHead];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//        }
//    }
//    return image;
//}
//
///* 天天定制未选中image */
//+ (YYImage *)getTtCustomizeUnselectedImage
//{
//    YYImage *image = [YYImage imageNamed:@"mall_home_dayday.webp"];
//    JHSkinModel *model = [JHSkinManager ttCustomize];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [YYImage imageWithContentsOfFile:imagePath];
//        }
//    }
//    return image;
//
//}
//
///* 天天定制选中image */
//+ (YYImage *)getTtCustomizeselectedImage
//{
//    YYImage *image = [YYImage imageNamed:@"mall_home_dayday.webp"];
//    JHSkinModel *model = [JHSkinManager ttCustomize];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.useName;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [YYImage imageWithContentsOfFile:imagePath];
//        }
//    }
//    return image;
//
//}
//+ (UIImage *)getLiveTitleImage {
//    UIImage *image = [UIImage imageNamed:@"mall_home_dayday.webp"];
//    JHSkinModel *model = [JHSkinManager liveShopping];
//    if ([JHSkinManager getImagePathExtension:model.name])
//    {
//        NSString *live_path = [JHSkinManager getImageFilePath:model.name];
//        UIImage *live_image = [UIImage sd_imageWithWebPData:[NSData dataWithContentsOfFile:live_path]];
//        image = live_image;
//    }
//    else
//    {
//        UIImage *live_image = [JHSkinManager getTtCustomizeUnselectedImage];
//        image = live_image;
//    }
//    return image;
//}
///* 特卖商城未选中image */
//+ (UIImage *)getSaleStoreUnselectedImage
//{
//    UIImage *image = nil;
//    JHSkinModel *model = [JHSkinManager saleStore];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//        }
//    }
//    return image;
//}
//
///* 特卖商城选中image */
//+ (UIImage *)getSaleStoreselectedImage
//{
//    UIImage *image = nil;
//    JHSkinModel *model = [JHSkinManager saleStore];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.useName;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//        }
//    }
//    return image;
//}
//
//
//
///* 发布tabBar未选中image */
//+ (UIImage *)getPublishUnselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"tablebar_publish"];
//
//    JHSkinModel *model = [JHSkinManager threeDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//        }
//    }
//    return image;
//}
//
///* 发布tabBar选中image */
//+ (UIImage *)getPublishselectedImage
//{
//    UIImage *image = [UIImage imageNamed:@"tablebar_publish"];
//
//    JHSkinModel *model = [JHSkinManager threeDefini];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.useName;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            image = [UIImage imageWithContentsOfFile:imagePath];
//        }
//    }
//    return image;
//}
//
///* 返回顶部image*/
//+ (UIImage *)getTopImage
//{
//    UIImage *image = [UIImage imageNamed:@"my_newtable_totop"];
//
//    JHSkinModel *model = [JHSkinManager top];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 0)
//        {
//            NSString *imageName = model.name;
//            NSString *imagePath = [JHSkinManager getImageFilePath:imageName];
//            if (imagePath.length > 0)
//            {
//                image = [UIImage imageWithContentsOfFile:imagePath];
//                image = [JHSkinManager scaleToSize:image size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
//            }
//            else
//            {
//                image = [UIImage imageNamed:@"my_newtable_totop"];
//            }
//        }
//    }
//    return image;
//}

///* 直播购物 */
//+ (JHSkinModel *)liveShopping
//{
//    return [JHSkinManager getSkinModel:liveShopping];
//}
//
///* 天天定制 */
//+ (JHSkinModel *)ttCustomize
//{
//    return [JHSkinManager getSkinModel:ttCustomize];
//}
//
///* 特卖商城 */
//+ (JHSkinModel *)saleStore
//{
//    return [JHSkinManager getSkinModel:saleStore];
//}
//
///* 文玩社区 */
//+ (JHSkinModel *)oneDefini
//{
//    return [JHSkinManager getSkinModel:oneDefini];
//}
//
///* 源头直购 */
//+ (JHSkinModel *)twoDefini
//{
//    return [JHSkinManager getSkinModel:twoDefini];
//}
//
///* + */
//+ (JHSkinModel *)threeDefini
//{
//    return [JHSkinManager getSkinModel:threeDefini];
//}
//
///* 在线鉴定 */
//+ (JHSkinModel *)fourDefini
//{
//    return [JHSkinManager getSkinModel:fourDefini];
//}
//
///* 个人中心 */
//+ (JHSkinModel *)fiveDefini
//{
//    return [JHSkinManager getSkinModel:fiveDefini];
//}
//
///* 搜索 */
//+ (JHSkinModel *)search
//{
//    return [JHSkinManager getSkinModel:search];
//}
//
///* 签到 */
//+ (JHSkinModel *)sign
//{
//    return [JHSkinManager getSkinModel:sign];
//}
///* 分类 */
//+ (JHSkinModel *)category
//{
//    return [JHSkinManager getSkinModel:category];
//}
///* 消息 */
//+ (JHSkinModel *)message
//{
//    return [JHSkinManager getSkinModel:message];
//}
//
///* 红点底色 */
//+ (JHSkinModel *)redBottom
//{
//    return [JHSkinManager getSkinModel:redBottom];
//}
//
///* 红点数字颜色 */
//+ (JHSkinModel *)numColor
//{
//    return [JHSkinManager getSkinModel:numColor];
//}
//
///* 金刚位 */
//+ (JHSkinModel *)kimFont
//{
//    return [JHSkinManager getSkinModel:kimFont];
//}
//
///* 一级导航选择器 */
//+ (JHSkinModel *)navigation
//{
//    return [JHSkinManager getSkinModel:navigation];
//}
///* 平台保底色 */
//+ (JHSkinModel *)platformBottom
//{
//    return [JHSkinManager getSkinModel:platformBottom];
//}
///* 平台保障字色 */
//+ (JHSkinModel *)platformFont
//{
//    return [JHSkinManager getSkinModel:platformFont];
//}
//
///* 背景body */
//+ (JHSkinModel *)entiretyBody
//{
//    return [JHSkinManager getSkinModel:entiretyBody];
//}
//
///* 背景head */
//+ (JHSkinModel *)entiretyHead
//{
//    return [JHSkinManager getSkinModel:entiretyHead];
//}
//
///* 源头直播低价购image  */
//+ (JHSkinModel *)sourceLive
//{
//    return [JHSkinManager getSkinModel:sourceLive];
//}
///* 专家逐件把关image  */
//+ (JHSkinModel *)experts
//{
//    return [JHSkinManager getSkinModel:experts];
//}
///* 7天无理由退换image  */
//+ (JHSkinModel *)exchange
//{
//    return [JHSkinManager getSkinModel:exchange];
//}
//
///* 直播图标image */
//+ (JHSkinModel *)liveBottom
//{
//    return [JHSkinManager getSkinModel:liveBottom];
//}
//
//+ (JHSkinModel *)platformRight
//{
//    return [JHSkinManager getSkinModel:platformRight];
//}
//
///* 底部导航字色 */
//+ (JHSkinModel *)bottomNavigation
//{
//    return [JHSkinManager getSkinModel:bottomNavigation];
//}
//
///* 返回顶部image*/
//+ (JHSkinModel *)top
//{
//    return [JHSkinManager getSkinModel:top];
//}
@end
