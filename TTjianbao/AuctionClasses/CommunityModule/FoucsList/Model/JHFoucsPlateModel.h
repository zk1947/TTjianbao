//
//  JHFoucsPlateModel.h
//  TTjianbao
//
//  Created by apple on 2020/9/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHFoucsPlateModel : NSObject
@property (nonatomic, copy) NSString *bg_image;
@property (nonatomic, copy) NSString *channel_id;
@property (nonatomic, copy) NSString *channel_name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *follow_id;
@property (nonatomic, assign) BOOL is_follow;
///浏览量
@property (nonatomic, copy) NSString *scan_num;

///评论数
@property (nonatomic, copy) NSString *comment_num;

///分享数
@property (nonatomic, copy) NSString *share_num;

///帖子总数
@property (nonatomic, copy) NSString *content_num;


+ (void)requestFoucsPlateWithId:(NSString *)last_id
                         userId:(NSString *)userId
                   successBlock:(void(^)(NSMutableArray * array))succBlock
                      failBlock:(void(^)(RequestModel * _Nonnull reqModel))failBlock;

+ (void)foucsPlateWithModel:(JHFoucsPlateModel *)model isCancel:(BOOL)isCancel
              completeBlock:(dispatch_block_t)completeBlock failBlock:(dispatch_block_t)failBlock;
@end

NS_ASSUME_NONNULL_END
