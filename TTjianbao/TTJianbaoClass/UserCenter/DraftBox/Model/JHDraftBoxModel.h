//
//  JHDraftBoxModel.h
//  TTjianbao
//  Description:社区-草稿箱Model
//  Created by jesee on 28/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "JHRichTextImage.h"

typedef NS_ENUM(NSUInteger, JHDraftBoxStyle)
{
    JHDraftBoxStyleDefault,
    JHDraftBoxStyleImageText = JHDraftBoxStyleDefault,
    JHDraftBoxStyleIcons,
    JHDraftBoxStyleVideo
};

@interface JHDraftBoxModel : NSObject <NSCoding>

@property (nonatomic, assign) BOOL editSelected;

@property (nonatomic, assign) JHDraftBoxStyle style;
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, copy)  NSString* title;
@property (nonatomic, copy)  NSString* content;
@property (nonatomic, copy) NSString* durationStr;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, copy) NSString* imageCount;

///图片数组
@property (nonatomic, strong) NSMutableArray <NSData *> *imageDataArray;
///句柄标识
@property (nonatomic, strong) NSMutableArray *localIdentifierArray;
///单个图片
@property (nonatomic, copy) NSData *imageData;
/// 视频路径
@property (nonatomic, copy) NSString *outPutUrl;
///已经选择话题数组
@property (nonatomic, copy) NSArray *topicArray;
///版块title
@property (nonatomic, copy) NSString *plateTitle;
///版块ID
@property (nonatomic, copy) NSString *channel_id;
///封面
@property (nonatomic, strong) NSData *coverImageData;

///非持久化，临时属性
@property (nonatomic, strong) NSMutableArray *imageAssetArray;

//富文本数据
@property (nonatomic, strong) NSMutableArray *richTextArray;
//保存model
+ (void)saveDataModel:(JHDraftBoxModel*)model;
//删除时,调用,保存剩下的Array
+ (void)saveDataArray:(NSArray*)arr;
//获取数据array
+ (NSArray*)dataArray;
@end

