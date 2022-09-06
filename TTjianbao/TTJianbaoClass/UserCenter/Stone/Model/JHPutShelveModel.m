//
//  JHPutShelveModel.m
//  TTjianbao
//
//  Created by yaoyao on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHPutShelveModel.h"
NSString *const JHNotificationShelveStatusChange = @"JHNotificationShelveStatusChange";
@implementation JHPutShelveModel

@end



//原石回血上架请求 {
//depositoryLocationCode (string): 存放货架 ,
//goodsDesc (string): 商品内容 ,
//goodsTitle (string): 商品标题 ,
//stoneRestoreId (integer): 原石回血ID ,
//urlList (Array[AttachmentRequest]): 附件列表
//}
//AttachmentRequest {
//coverUrl (string, optional): 如果是视频，封面地址 ,
//type (string, optional): 1-图片，2-视频 = ['NONE', 'PICTURE', 'VIDEO'],
//url (string, optional): 地址
//}



@implementation JHMediaModel
@end



@implementation JHPutawayModel

- (NSMutableArray<JHMediaModel *> *)urlList {
    if (!_urlList) {
        _urlList = [NSMutableArray array];
    }
    
    return _urlList;
}
@end
