//
//  JHDraftBoxModel.m
//  TTjianbao
//
//  Created by jesee on 28/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "TZImageManager.h"
#import "JHDraftBoxModel.h"
#import "JHPersistData.h"
#import "JHImagePickerPublishManager.h"

#define kDraftboxRecordArrayPath @"JHDraftboxRecordArrayPath"

@implementation JHDraftBoxModel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if(self = [super init])
    {
        _editSelected = [coder decodeBoolForKey:@"draft_editSelected"];
        _style = [coder decodeIntegerForKey:@"draft_style"];
        _time = [coder decodeDoubleForKey:@"draft_time"];
        _title = [coder decodeObjectForKey:@"draft_title"];
        _content = [coder decodeObjectForKey:@"draft_content"];
        _imageCount = [coder decodeObjectForKey:@"draft_imageCount"];
        _duration = [coder decodeIntegerForKey:@"draft_duration"];
        _durationStr = [coder decodeObjectForKey:@"draft_durationStr"];
        _imageDataArray = [coder decodeObjectForKey:@"draft_imageDataArr"];
        _localIdentifierArray = [coder decodeObjectForKey:@"draft_localIdentifierArray"];
        _imageData = [coder decodeObjectForKey:@"draft_imageData"];
        _outPutUrl = [coder decodeObjectForKey:@"draft_outPutUrl"];
        _topicArray = [coder decodeObjectForKey:@"draft_topicArray"];
        _plateTitle = [coder decodeObjectForKey:@"draft_plateTitle"];
        _channel_id = [coder decodeObjectForKey:@"draft_channel_id"];
        _richTextArray = [coder decodeObjectForKey:@"draft_richArray"];
        _coverImageData = [coder decodeObjectForKey:@"draft_coverImageData"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeBool:_editSelected forKey:@"draft_editSelected"];
    [coder encodeInteger:_style forKey:@"draft_style"];
    [coder encodeDouble:_time forKey:@"draft_time"];
    [coder encodeObject:_title forKey:@"draft_title"];
    [coder encodeObject:_content forKey:@"draft_content"];
    [coder encodeObject:_imageCount forKey:@"draft_imageCount"];
    [coder encodeObject:_durationStr forKey:@"draft_durationStr"];
    [coder encodeInteger:_duration forKey:@"draft_duration"];
    [coder encodeObject:_imageDataArray forKey:@"draft_imageDataArr"];
    [coder encodeObject:_localIdentifierArray forKey:@"draft_localIdentifierArray"];
    [coder encodeObject:_imageData forKey:@"draft_imageData"];
    [coder encodeObject:_outPutUrl forKey:@"draft_outPutUrl"];
    [coder encodeObject:_topicArray forKey:@"draft_topicArray"];
    [coder encodeObject:_plateTitle forKey:@"draft_plateTitle"];
    [coder encodeObject:_channel_id forKey:@"draft_channel_id"];
    [coder encodeObject:_richTextArray forKey:@"draft_richArray"];
    [coder encodeObject:_coverImageData forKey:@"draft_coverImageData"];
}

+ (void)saveDataModel:(JHDraftBoxModel*)model
{
    if(model)
    {
        NSMutableArray* existArr = [NSMutableArray arrayWithArray:[self dataArray]];
        if(!existArr || [existArr count] == 0)
        {
            existArr = [NSMutableArray array];
        }
        //保存当前时间
        model.time = [[NSDate date] timeIntervalSince1970];
        [existArr insertObject:model atIndex:0];
        [JHPersistData savePersistData:existArr savePath:kDraftboxRecordArrayPath];
    }
}

+ (void)saveDataArray:(NSArray*)arr
{
    if(arr)
    {
        [JHPersistData savePersistData:arr savePath:kDraftboxRecordArrayPath];
    }
}

+ (NSArray*)dataArray
{
    NSArray* existArr = [JHPersistData persistDataByPath:kDraftboxRecordArrayPath];
    for (JHDraftBoxModel *m in existArr) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:m.localIdentifierArray options:nil];
        if(fetchResult)
        {
            for(int i = 0; i < fetchResult.count; i++)
            {
                [m.imageAssetArray addObject:[fetchResult objectAtIndex:i]];
            }
        }
    }
    return existArr;
}

- (NSMutableArray *)imageAssetArray
{
    if(!_imageAssetArray)
    {
        _imageAssetArray = [NSMutableArray new];
    }
    return _imageAssetArray;
}

- (NSMutableArray<NSData *> *)imageDataArray
{
    if(!_imageDataArray)
    {
        _imageDataArray = [NSMutableArray new];
    }
    return _imageDataArray;
}

- (NSMutableArray *)localIdentifierArray
{
    if(!_localIdentifierArray)
    {
        _localIdentifierArray = [NSMutableArray new];
    }
    return _localIdentifierArray;
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
