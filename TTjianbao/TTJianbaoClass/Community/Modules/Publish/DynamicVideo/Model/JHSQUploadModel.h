//
//  JHSQUploadModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/6/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHSQPublishModel.h"
#import "JHDraftBoxModel.h"

@class JHAlbumPickerModel;

typedef NS_ENUM(NSInteger, JHSQUploadStatus)
{
    JHSQUploadStatusUploading = 0,
    JHSQUploadStatusUploadFail,
    JHSQUploadStatusUploadSuccess,
};

NS_ASSUME_NONNULL_BEGIN

@interface JHSQUploadModel : NSObject

@property (nonatomic, strong) JHSQPublishModel *paramModel;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) JHSQUploadStatus status;

@property (nonatomic, copy) NSString *tipString;

/// 1:image（动态）     2:video(小视频)     3:长文章（视频和图片）
@property (nonatomic, assign) NSInteger type;

/// 上传中显示图 / 封面
@property (nonatomic, strong) id image;

/// 待上传的图片
@property (nonatomic, strong) NSMutableArray <JHAlbumPickerModel *> *photoArray;

/// 富文本数组(视频 图片 文字)
@property (nonatomic, strong) NSMutableArray  *richTextArray;

/// 待上传的视频
@property (nonatomic, strong) JHAlbumPickerModel *videoModel;

-(void)start;

@end

NS_ASSUME_NONNULL_END
