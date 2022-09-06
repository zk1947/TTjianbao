//
//  JHB2CCommentViewModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/7/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHB2CCommentViewModel.h"
#import "JHStoreDetailBusiness.h"

@interface JHB2CCommentViewModel()

@end

@implementation JHB2CCommentViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        self.cellType = CommentCell;
        
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}

- (void)setCommentMode:(JHAudienceCommentMode *)commentMode{
    _commentMode = commentMode;
    self.imgUrl = commentMode.customerImg;
    self.dateTime = commentMode.createTime;
    self.name = commentMode.customerName;
    self.desString = commentMode.commentContent;
    self.imageArr = commentMode.commentImgsList;
    self.hasShopReply = commentMode.shopReply.length;
    self.shopReplyString = commentMode.shopReply;
    self.pass = commentMode.pass;
}

- (void)delComment{
    [JHStoreDetailBusiness requestDelComment:self.commentMode.Id completion:^(NSError * _Nullable error) {
        if (error) {
            JHTOAST(error.localizedDescription);
        }else{
            [NSNotificationCenter.defaultCenter postNotificationName:@"JHStoreDetailViewController_refershData" object:nil];
        }
    }];
}

@end
