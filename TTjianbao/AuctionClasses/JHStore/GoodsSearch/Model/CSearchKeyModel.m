//
//  CSearchKeyModel.m
//  Cooking-Home
//
//  Created by Wuyd on 2018/7/15.
//  Copyright © 2018 Wuyd. All rights reserved.
//

#import "CSearchKeyModel.h"
#import "YDFileManager.h"
#import <YYKit/YYKit.h>
#import "JHHotWordModel.h"

#define kHistoryDirName     @"TTjianbao/SearchHistory"
#define kHistoryFileName    @"SearchHistory.plist"

@implementation CSearchKeyModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"hotList" : @"data",
             @"historyList" : @"historyList"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"hotList" : [JHHotWordModel class],
             @"historyList" : [CSearchKeyData class]};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _hotList = [NSMutableArray array];
        _historyList = [NSMutableArray arrayWithArray:[CSearchKeyModel loadHistoryList]];
//        [self loadHotList];
    }
    return self;
}

- (void)loadHotList {
    NSMutableArray *hotKeys = [[NSMutableArray alloc] init];
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/shop/hot_words");
    @weakify(self);
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [hotKeys addObjectsFromArray:[JHHotWordModel mj_objectArrayWithKeyValuesArray:respondObject.data].copy];
        self.hotList = hotKeys;
        
    } failureBlock:^(RequestModel *respondObject) {
        NSLog(@"请求失败");
        
    }];
}

/** 读取历史搜索 */
+ (NSArray *)loadHistoryList {
    //json数组转模型数组
    NSArray *dataList = [NSArray modelArrayWithClass:[CSearchKeyData class] json:[self p_readHistoryList]];
    if (dataList.count > 10) {
        dataList = [dataList subarrayWithRange:NSMakeRange(0, 10)];
    }
    return dataList;
}

/** 保存历史搜索 */
+ (void)saveHistoryData:(CSearchKeyData *)data {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *dataList = [self p_readHistoryList];
        
        [dataList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CSearchKeyData *keyData = [CSearchKeyData modelWithJSON:obj];
            if ([keyData.keyword isEqualToString:data.keyword]) {
                [dataList removeObject:obj];
                *stop = YES;
            }
        }];
        
        //模型转字典
        NSDictionary *dicData = [data modelToJSONObject];
        [dataList insertObject:dicData atIndex:0];
        [dataList writeToFile:[self p_historyListPath] atomically:YES];
    });
}

/** 删除所有历史搜索 */
+ (void)removeAllHistory {
    [YDFileManager removeItemAtPath:[self p_historyListPath]];
}


#pragma mark -
#pragma mark - Private Methods

//读取收藏数据
+ (NSMutableArray *)p_readHistoryList {
    NSMutableArray *dataList = [NSMutableArray arrayWithContentsOfFile:[self p_historyListPath]];
    if (!dataList) {
        dataList = [NSMutableArray new];
    }
    return dataList;
}

//文件路径
+ (NSString *)p_historyListPath {
    static NSString *filePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //文件目录
        NSString *dirPath = [[YDFileManager getDocumentsPath] stringByAppendingPathComponent:kHistoryDirName];
        [YDFileManager createDirectory:dirPath];
        //文件名（带路径）
        filePath = [YDFileManager createFile:dirPath fileName:kHistoryFileName];
    });
    NSLog(@"historyFilePath = %@", filePath);
    return filePath;
    
    /**
     //文件目录
     NSString *dirPath = [[YDFileManager getDocumentsPath] stringByAppendingPathComponent:kCollectDirName];
     [YDFileManager createDirectory:dirPath];
     
     //文件名（带路径）
     NSString *filePath = [YDFileManager createFile:dirPath fileName:kCollectFileName];
     return filePath;
     */
}

@end


@implementation CSearchKeyData

@end

