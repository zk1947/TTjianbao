//
//  JHSQUploadModel.m
//  TTjianbao
//
//  Created by wangjianios on 2020/6/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHSQUploadModel.h"
#import "JHUploadManager.h"
#import "JHSQUploadManager.h"
#import "JHImagePickerPublishManager.h"
#import <SVProgressHUD.h>
#import "UserInfoRequestManager.h"
#import "JHGrowingIO.h"
#import "JHSQApiManager.h"
#import "JHPlateDetailController.h"
#import "JHTopicDetailController.h"
#import "JHAttributeStringTool.h"
#import "JHPublishTopicDetailModel.h"
#import "JHAuthorize.h"
@interface JHSQUploadModel ()

@property (nonatomic, assign) NSInteger currentUploadIndex;

@end


@implementation JHSQUploadModel

-(void)start
{
    if(_type == 1)
    {
        if(self.paramModel.content) {
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:@(1) forKey:@"type"];
            [params setObject:@{@"text":self.paramModel.content} forKey:@"data"];
            self.paramModel.resource_data = @[params];
        }
        self.paramModel.content = nil;
        if(self.photoArray && self.photoArray.count > 0)
        {
            JHAlbumPickerModel *obj = self.photoArray.firstObject;
            self.image = obj.image;
            if([obj.image isKindOfClass:[UIImage class]]) {
                UIImage *image = (UIImage *)obj.image;
                CGSize size = image.size;
                self.paramModel.cover_info.width = size.width;
                self.paramModel.cover_info.height = size.height;
            }
            else if([obj.image isKindOfClass:[NSString class]]) {
                self.paramModel.cover_info.width = (NSInteger)obj.width;
                self.paramModel.cover_info.height = (NSInteger)obj.height;
            }
            
            NSArray *imageArray = [self changePhotoArray];
            NSArray *imageUrlArray = imageArray[0];
            NSArray *imageLocalArray = imageArray[1];
            // 包含本地数据
            if(imageLocalArray.count > 0) {
                [[JHUploadManager shareInstance] uploadImage:imageLocalArray uploadProgress:^(CGFloat progress) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.progress = progress/100.f;
                    });
                } finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
                    if(isFinished)
                    {
                        NSMutableArray *urlArray = [NSMutableArray arrayWithArray:imageUrlArray];
                        [urlArray addObjectsFromArray:imgKeys];
                        self.paramModel.cover_info.url = urlArray.firstObject;
                        self.paramModel.images = urlArray;
                        [self uploadSelfServer];
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.status = JHSQUploadStatusUploadFail;
                            [JHSQUploadManager reload];
                        });
                    }
                }];
            }
            else {
                // 全部网络数据
                self.paramModel.images = imageUrlArray;
                self.paramModel.cover_info.url = imageUrlArray.firstObject;
                [self uploadSelfServer];
            }
        }
        else
        {
            [self uploadSelfServer];
        }
    }
    else if(_type == 2)
    {
        if(self.paramModel.content) {
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:@(1) forKey:@"type"];
            [params setObject:@{@"text":self.paramModel.content} forKey:@"data"];
            self.paramModel.resource_data = @[params];
        }
        self.paramModel.content = nil;
        
        self.image = self.videoModel.image;
        if([self.image isKindOfClass:[UIImage class]])
        {
            UIImage *image = (UIImage *)self.image;
            CGSize size = image.size;
            self.paramModel.cover_info.width = size.width;
            self.paramModel.cover_info.height = size.height;
            [[JHUploadManager shareInstance] uploadImage:@[self.image] uploadProgress:^(CGFloat progress) {
            } finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
                if(isFinished)
                {
                    self.paramModel.cover_info.url = imgKeys.firstObject;
                    [self uploadVideo];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.status = JHSQUploadStatusUploadFail;
                        [JHSQUploadManager reload];
                    });
                }
            }];
        }
        else {
            self.paramModel.cover_info.url = (NSString *)self.image;
            self.paramModel.video_url = self.videoModel.sourceUrl;
            [self uploadSelfServer];
        }
    }
    else
    {
        if([self.image isKindOfClass:[UIImage class]]) {
            [[JHUploadManager shareInstance] uploadImage:@[self.image] uploadProgress:^(CGFloat progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.progress = 0.1;
                });
            } finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
                if(isFinished)
                {
                    UIImage *coverImage = (UIImage *)self.image;
                    self.paramModel.cover_info.width = coverImage.size.width;
                    self.paramModel.cover_info.height = coverImage.size.height;
                    self.paramModel.cover_info.url = imgKeys.firstObject;
                    self.currentUploadIndex = 0;
                    [self uploadSourcesWithIndex:0];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.status = JHSQUploadStatusUploadFail;
                        [JHSQUploadManager reload];
                    });
                }
            }];
        }
        else {
            self.paramModel.cover_info = [JHSQPublishCoverModel new];
            self.paramModel.cover_info.width = (NSInteger)self.videoModel.width;
            self.paramModel.cover_info.height = (NSInteger)self.videoModel.height;
            self.paramModel.cover_info.url = (NSString *)self.image;
            self.currentUploadIndex = 0;
            [self uploadSourcesWithIndex:0];
        }
    }
}

/// 上传视频
-(void)uploadVideo
{
    [[JHUploadManager shareInstance] uploadVideoByPath:self.videoModel.videoPath uploadProgress:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progress = progress/100.f;
        });
    } finishBlock:^(BOOL isFinished, NSString * _Nonnull videoKey) {
        if(isFinished)
        {
            self.paramModel.video_url = videoKey;
            [self uploadSelfServer];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.status = JHSQUploadStatusUploadFail;
                [JHSQUploadManager reload];
            });
        }
    }];
}

- (void)uploadSourcesWithIndex:(NSInteger)index
{
    NSInteger totalSourceNum = 0;
    for (id obj in self.richTextArray) {
        if([obj isKindOfClass:[JHAlbumPickerModel class]])
        {
            totalSourceNum ++;
        }
    }
    
    if(index < self.richTextArray.count)
    {
        JHAlbumPickerModel *model = self.richTextArray[index];
        
        if([model isKindOfClass:[JHAlbumPickerModel class]])
        {
            ///仅仅是进度
            self.currentUploadIndex++;
            
            if(model.isVideo)
            {
                if([model.image isKindOfClass:[UIImage class]]) {
                    [self uploadVideoImageWithCoverImage:model.image videoPathUrl:model.videoPath totalSources:totalSourceNum coverImageBlock:^(NSArray *imgKeys) {
                        model.coverUrl = imgKeys.firstObject;
                    } videoBlock:^(NSString *pathUrl) {
                        model.sourceUrl = pathUrl;
                    } complete:^{
                        [self uploadSourcesWithIndex:(index + 1)];
                    }];
                }
                else {
                    [self uploadSourcesWithIndex:(index + 1)];
                }
                
            }
            else
            {
                if([model.image isKindOfClass:[UIImage class]]) {
                    [[JHUploadManager shareInstance] uploadImage:@[model.image] uploadProgress:^(CGFloat progress) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.progress = (progress * self.currentUploadIndex)/(100.f * totalSourceNum);
                        });
                        
                    } finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
                        if(isFinished)
                        {
                            model.sourceUrl = imgKeys.firstObject;
                            model.coverUrl = imgKeys.firstObject;
                            [self uploadSourcesWithIndex:(index + 1)];
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.status = JHSQUploadStatusUploadFail;
                                [JHSQUploadManager reload];
                            });
                        }
                    }];
                }
                else {
                    [self uploadSourcesWithIndex:(index + 1)];
                }
            }
        }
        else
        {
            [self uploadSourcesWithIndex:(index + 1)];
        }
    }
    else
    {
        [self sourceDataUploadComplete];
    }
}

- (void)sourceDataUploadComplete
{
    self.paramModel.content = [self getHtmlString:self.richTextArray];
    self.paramModel.resource_data = [self getResourceData:self.richTextArray];
    /** 封面*/
    NSMutableArray * images = [NSMutableArray array];
    //取第一张图片做封面 如果没有取视频封面
    for (id obj in self.richTextArray) {
        if ([obj isKindOfClass:[JHAlbumPickerModel class]]){
            JHAlbumPickerModel *model = (JHAlbumPickerModel*)obj;
            if (!model.isVideo) {
                [images addObject:model.sourceUrl];
            }
            else{
                self.paramModel.video_url = model.sourceUrl;
            }
        }
    }
    self.paramModel.images = [images copy];
    [self uploadSelfServer];
}

///提交自己服务器接口
-(void)uploadSelfServer
{
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/auth/user/content") Parameters:self.paramModel.mj_keyValues requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        NSDictionary *data = respondObject.data;
        NSString *itemId = self.paramModel.item_id;
        
        if(IS_DICTIONARY(data) && [data valueForKey:@"item_id"])
        {
            [self growingIOMethodWithItemId:[data valueForKey:@"item_id"]];
            ///发布成功后 根据itemid请求刚发布的帖子详情
            [self getPostDataPublishedByNow:data[@"item_id"]];
            itemId = [data valueForKey:@"item_id"];
        }
        
        ///365社区埋点::是否有@高亮的埋点 -- TODO lihui
        [self stasticCallUser:itemId];
        ///369神策埋点:内容发布_发布结果
        [self sa_trackPublishResult:YES failReasion:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ///通知社区推荐首页更新刚刚发布的帖子数据
            [JHSQUploadManager removeModel:self];
        });
        [JHAuthorize clickTriggerPushAuthorizetion:JHAuthorizeClickTypePostSendSuccess];
        
    } failureBlock:^(RequestModel *respondObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.status = JHSQUploadStatusUploadFail;
            [JHSQUploadManager reload];
            [SVProgressHUD showInfoWithStatus:respondObject.message];
            ///369神策埋点:内容发布_发布结果
            [self sa_trackPublishResult:NO failReasion:[respondObject.message isNotBlank]?respondObject.message:@"链接网络失败"];
        });
    }];
}

- (void)sa_trackPublishResult:(BOOL)isSuccess failReasion:(NSString *_Nullable)reason {
    NSString *type = @"";
    switch (self.paramModel.item_type) {
        case 20:
            type = @"动态";
            break;
        case 30:
            type = @"长文章";
            break;
        case 40:
            type = @"小视频";
            break;
        default:
            break;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(isSuccess) forKey:@"is_success"];
    [params setValue:type forKey:@"content_type"];
    [params setValue:self.paramModel.topic forKey:@"theme_name"];
    [params setValue:self.paramModel.channel_id forKey:@"section_id"];
    [params setValue:self.paramModel.channel_name forKey:@"section_name"];
    if ([reason isNotBlank]) {
        [params setValue:reason forKey:@"fail_reason"];
    }
    
    [JHTracking trackEvent:@"nrfbReleaseResult" property:params];
}

///365社区埋点::是否有@高亮的埋点 -- TODO lihui
- (void)stasticCallUser:(NSString *)itemId {
    BOOL hasCallUser = NO;
    NSArray *textArray = self.paramModel.resource_data;
    for (NSDictionary *dic in textArray) {
        NSString *str = [dic objectForKey:@"data"][@"text"];
        if ([str isNotBlank]) {
            hasCallUser = [JHAttributeStringTool hasCallUser:str];
            if (hasCallUser) break;
        }
    }
    if (hasCallUser) {
        [self statisticsMethodWithItemId:itemId itemType:@(self.paramModel.item_type).stringValue];
    }
}

- (void)statisticsMethodWithItemId:(NSString *)itemId itemType:(NSString *)itemType {
    
    NSInteger type = self.paramModel.item_type;
    
    switch (self.paramModel.item_type) {
        case 1:
            type = 20;
            break;
            
        case 2:
            type = 40;
            break;
            
        case 3:
            type = 30;
            break;
            
        default:
            break;
    }
    
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:user.customerId forKey:@"userId"];
    [params setValue:[CommHelp deviceIDFA] forKey:@"deviceId"];
    [params setValue:@"item_id" forKey:@"item_id"];
    [params setValue:@(type) forKey:@"item_type"];
    [JHAllStatistics jh_allStatisticsWithEventId:@"edit_click" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeSensors)];
}

///获取刚刚发布的审核中的帖子信息
- (void)getPostDataPublishedByNow:(NSString *)itemId {
    NSLog(@"itemId:---- %@", itemId);
    [JHSQApiManager getPostDetailInfoPublishByNow:^(JHPostData *postData, BOOL hasError) {
        if (!hasError) {
            ///将刚刚发布的帖子保存在发布单例中 方便后续展示使用
            postData.show_status = JHPostDataShowStatusChecking;
            [JHSQUploadManager shareInstance].localPostInfo = postData;
            ///记录帖子发布时间
            [JHSQUploadManager shareInstance].publishTime = [[CommHelp getCurrentTimeString] longLongValue];
            
            NSLog(@"currentViewController:----- %@", [JHRootController.currentViewController class]);
            if ([JHRootController.currentViewController isKindOfClass:[JHPlateDetailController class]]) {
                ///在板块主页发布的帖子
                [JHNotificationCenter postNotificationName:kUpdateSQPlateDetailDataNotification object:nil];
            }
            else if ([JHRootController.currentViewController isKindOfClass:[JHTopicDetailController class]]) {
                ///在话题主页发布的帖子
                [JHNotificationCenter postNotificationName:kUpdateSQTopicDetailDataNotification object:nil];
            }
            else if ([JHRootController.currentViewController isKindOfClass:[JHRootViewController class]]) {
                [JHNotificationCenter postNotificationName:kUpdateSQRecommendDataNotification object:nil];
            }
        }
    }];
}

- (void)growingIOMethodWithItemId:(NSString *)itemId
{
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@(self.paramModel.item_type) forKey:@"item_type"];
    [params setValue:itemId forKey:@"item_id"];
    [params setValue:user.customerId forKey:@"userId"];
    [params setValue:self.paramModel.topic.mj_JSONString forKey:@"topic_ids"];
    [params setValue:self.paramModel.channel_id forKey:@"channel_id"];
    
    [JHGrowingIO trackEventId:@"write_success" variables:params];
}

///获取图片 index0-网络  index1-相册模型
- (NSArray *)changePhotoArray
{
    NSMutableArray *array0 = [NSMutableArray new];
    NSMutableArray *array1 = [NSMutableArray new];
    for (JHAlbumPickerModel *obj in self.photoArray) {
        if([obj.image isKindOfClass:[UIImage class]])
        {
            [array1 addObject:obj.image];
        }
        else if([obj.image isKindOfClass:[NSString class]]){
            [array0 addObject:obj.image];
        }
    }
    return @[array0,array1];
}

///富文本混排 上传1
- (void)uploadVideoImageWithCoverImage:(UIImage *)coverImage videoPathUrl:(NSString *)videoPathUrl totalSources:(CGFloat)totalSources coverImageBlock:(void (^) (NSArray *imgKeys))coverImageBlock videoBlock:(void (^) (NSString *pathUrl))videoBlock complete:(dispatch_block_t)complete
{
    [[JHUploadManager shareInstance] uploadImage:@[coverImage] uploadProgress:^(CGFloat progress) {
    } finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
        if(isFinished && coverImageBlock)
        {
            coverImageBlock(imgKeys);
            [self uploadVideoPathUrl:videoPathUrl totalSources:totalSources videoBlock:videoBlock complete:complete];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.status = JHSQUploadStatusUploadFail;
                [JHSQUploadManager reload];
            });
        }
    }];
}

///富文本混排 上传2
- (void)uploadVideoPathUrl:(NSString *)videoPathUrl totalSources:(CGFloat)totalSources videoBlock:(void (^) (NSString *pathUrl))videoBlock complete:(dispatch_block_t)complete
{
    [[JHUploadManager shareInstance] uploadVideoByPath:videoPathUrl uploadProgress:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progress = (progress * self.currentUploadIndex)/(100.f * totalSources);
        });
    } finishBlock:^(BOOL isFinished, NSString * _Nonnull videoKey) {
        if(isFinished)
        {
            if(videoBlock && complete)
            {
                videoBlock(videoKey);
                complete();
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.status = JHSQUploadStatusUploadFail;
                [JHSQUploadManager reload];
            });
        }
    }];
}
//长文章数据转成html格式
-(NSString*)getHtmlString:(NSArray*)richTextArr{
    NSMutableString * htmlStr = [NSMutableString stringWithCapacity:10];
    [htmlStr appendString:@"<div class='comment_container'>"];
    for (id obj in richTextArr) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString * string =(NSString*)obj;
            [htmlStr appendString:[NSString stringWithFormat:@"<div class='content'>%@</div>",string] ];
        }
        else if ([obj isKindOfClass:[JHAlbumPickerModel class]]) {
            JHAlbumPickerModel * albumModel = (JHAlbumPickerModel*)obj;
            if (albumModel.isVideo) {
                [htmlStr appendString:[NSString stringWithFormat:@"<video src='%@' poster='%@' controls></video>",albumModel.sourceUrl,albumModel.coverUrl]];
            }
            else{
                [htmlStr appendString:[NSString stringWithFormat:@"<img src='%@' alt=''></img>",albumModel.sourceUrl]];
            }
        }
    }
    [htmlStr appendString:@"</div>"];
    return htmlStr;
    
}
//长文章数据转成数组格式
-(NSArray*)getResourceData:(NSArray*)richTextArr{
    NSMutableArray * resourceData = [NSMutableArray array];
    for (id obj in richTextArr) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if ([obj isKindOfClass:[NSString class]]) {
             [dic setObject:@(1) forKey:@"type"];
             [dic setObject:@{@"text":(NSString*)obj} forKey:@"data"];
           
        }
        else if ([obj isKindOfClass:[JHAlbumPickerModel class]]) {
            JHAlbumPickerModel * albumModel = (JHAlbumPickerModel*)obj;
            CGSize imageSize = CGSizeZero;
            if([albumModel.image isKindOfClass:[UIImage class]]) {
                UIImage * image = (UIImage*)albumModel.image;
                imageSize = image.size;
            }
            else {
                imageSize.width = (NSInteger)albumModel.width;
                imageSize.height = (NSInteger)albumModel.height;
            }
            if (albumModel.isVideo) {
                [dic setObject:@(3) forKey:@"type"];
                [dic setObject:@{@"video_url":albumModel.sourceUrl,
                                 @"video_duration":@(albumModel.videoDuration),
                                 @"video_cover_url":albumModel.coverUrl,
                                 @"width":@(imageSize.width),
                                 @"height":@(imageSize.height)} forKey:@"data"];
            }
            else{
                [dic setObject:@(2) forKey:@"type"];
                [dic setObject:@{@"image_url":albumModel.sourceUrl,
                                 @"width":@(imageSize.width),
                                 @"height":@(imageSize.height)} forKey:@"data"];
            }
        }
        [resourceData addObject:dic];
    }
    return resourceData;
    
}
#pragma mark -------- get set --------
/// 图片模型数组
-(NSMutableArray<JHAlbumPickerModel *> *)photoArray
{
    if(!_photoArray)
    {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

/// 自己服务器发布模型
-(JHSQPublishModel *)paramModel
{
    if(!_paramModel)
    {
        _paramModel = [JHSQPublishModel new];
    }
    return _paramModel;
}

/// 视频模型
-(JHAlbumPickerModel *)videoModel
{
    if(!_videoModel)
    {
        _videoModel = [JHAlbumPickerModel new];
    }
    return _videoModel;
}

- (NSMutableArray *)richTextArray
{
    if(!_richTextArray)
    {
        _richTextArray = [NSMutableArray new];
    }
    return _richTextArray;
}
@end
