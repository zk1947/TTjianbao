//
//  JHPostDetailEventManager.m
//  TTjianbao
//
//  Created by lihui on 2020/9/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPostDetailEventManager.h"
#import "JHPostDetailModel.h"
#import "JHUserInfoApiManager.h"
#import "JHPhotoBrowserManager.h"
#import "JHPostMainCommentHeader.h"
#import "JHSubCommentTableCell.h"
#import "JHUserInfoViewController.h"
#import "JHSQApiManager.h"
#import "JHSQModel.h"

NSString * const kUpdateCommentInfoNotification = @"kUpdateCommentInfoNotification";


@implementation JHPostDetailEventManager

+ (instancetype)shareManager {
    static JHPostDetailEventManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[JHPostDetailEventManager alloc] init];
    });
    return shareManager;
}

///查看大图的方法
+ (void)browseBigImage:(NSArray <UIImageView *>*)sourceViews
           thumbImages:(NSArray <NSString *>*)thumbImages
          mediumImages:(NSArray <NSString *>*)mediumImages
          originImages:(NSArray <NSString *>*)originImages
           selectIndex:(NSInteger)index
{
    [JHPhotoBrowserManager showPhotoBrowserThumbImages:thumbImages mediumImages:mediumImages origImages:originImages sources:sourceViews currentIndex:index canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleZoom];
}


- (void)toLikePost {
    
}

- (void)toFollow {
    
}

- (void)backBtnClick {
    
    
    
}

#pragma mark - 分享

- (void)toShare {
//    BOOL isMe = (self.articalModel.publisher.user_id == [[UserInfoRequestManager sharedInstance].user.customerId integerValue]);
//
//    [[UMengManager shareInstance] showCustomShareTitle:self.articalModel.share_info.title
//                                                  text:self.articalModel.share_info.desc
//                                              thumbUrl:self.articalModel.share_info.img
//                                                webURL:self.articalModel.share_info.url
//                                                  type:ShareObjectTypeSocialArticial
//                                                object:self.articalModel.item_id
//                                            isShowMore:YES
//                                                  isMe:isMe];
//
//    @weakify(self);
//    [UMengManager shareInstance].sharePlatformBlock = ^(NSInteger toType) {
//        @strongify(self);
//        //埋点：分享完成
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self growingBaseParams]];
//        [params setValue:@(toType) forKey:@"to_type"];
//        [GrowingManager articleDetailShareComplete:params];
//    };
}

#pragma mark - 点赞

- (void)likeAction:(JHCommentModel *)comment contentView:(id)contentView {
    if (!IS_LOGIN) {
        [JHRootController presentLoginVC];
        return;
    }
    
    NSInteger itemType = comment.publisher ? 4 : 3;
    if (comment.is_like) {
        ///当前状态是已赞状态 需要取消点赞
        [JHUserInfoApiManager sendCommentUnLikeRequest:itemType itemId:comment.comment_id likeNum:comment.like_num block:^(RequestModel *respObj, BOOL hasError) {
            if (!hasError) {
                [UITipView showTipStr:@"取消点赞成功"];
                comment.like_num = [respObj.data[@"like_num_int"] integerValue];
                comment.is_like = 0;
                
                [[JHPostDetailEventManager shareManager] __updateContentViewData:contentView comment:comment];
            }
        }];
    }
    else {
        [JHUserInfoApiManager sendCommentLikeRequest:itemType itemId:comment.comment_id likeNum:comment.like_num block:^(RequestModel *respObj, BOOL hasError) {
            if (!hasError) {
                [UITipView showTipStr:@"点赞成功"];
                comment.like_num = [respObj.data[@"like_num_int"] integerValue];
                comment.is_like = 1;
                [[JHPostDetailEventManager shareManager] __updateContentViewData:contentView comment:comment];
            }
        }];
    }
}

#pragma mark -
#pragma mark - private method

- (void)__updateContentViewData:(id)contentView comment:(JHCommentModel *)comment {
    if ([contentView isMemberOfClass:[JHPostMainCommentHeader class]]) {
        JHPostMainCommentHeader *header = (JHPostMainCommentHeader *)contentView;
        [header updateLikeButtonStatus:comment];
    }
    else if ([contentView isMemberOfClass:[JHSubCommentTableCell class]]) {
        JHSubCommentTableCell *cell = (JHSubCommentTableCell *)contentView;
        [cell updateLikeButtonStatus:comment];
    }
}

#pragma mark - 弹出弹窗

@end
