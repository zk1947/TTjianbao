//
//  JHUserInfoEvaluateModel.h
//  TTjianbao
//
//  Created by hao on 2021/6/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHUserInfoEvaluatImagesModel : NSObject
/** 大图 */
@property (nonatomic, copy) NSString *big;
/** 小图 */
@property (nonatomic, copy) NSString *medium;
/** 原图 */
@property (nonatomic, copy) NSString *origin;
/** 缩略图 */
@property (nonatomic, copy) NSString *small;
@property (nonatomic, copy) NSString *w;
@property (nonatomic, copy) NSString *h;
@end

@interface JHEvaluateresultListModel : NSObject
///名称
@property (nonatomic, copy) NSString *customerName;
///用户id
@property (nonatomic, copy) NSString *customerId;
///创建时间
@property (nonatomic, copy) NSString *createTime;
///头像
@property (nonatomic, strong) JHUserInfoEvaluatImagesModel *customerImg;
///评价内容
@property (nonatomic, copy) NSString *commentContent;
///评论图片
@property (nonatomic, copy) NSArray *commentImgs;
///是否展开
@property (nonatomic, assign) BOOL isOpen;
@end



@interface JHUserInfoEvaluateModel : NSObject
@property (nonatomic, copy) NSArray<JHEvaluateresultListModel *> *resultList;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, copy) NSString *cursor;

@end

NS_ASSUME_NONNULL_END
