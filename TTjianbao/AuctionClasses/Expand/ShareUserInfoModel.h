//
//  ShareUserInfoModel.h
//  KGLibrary
//
//  Created by yaoyao on 2017/11/13.
//  Copyright © 2017年 yaoyao. All rights reserved.
//


extern NSString *const JHShareLivingText;
extern NSString *const JHSharePreviewLiveText;
extern NSString *const JHShareSaleLivingText;

@interface ShareUserInfoModel : NSObject


@property (nonatomic, copy) NSString  *uid;
@property (nonatomic, copy) NSString  *openid;

@property (nonatomic, copy) NSString  *name;
@property (nonatomic, copy) NSString  *iconurl;
@property (nonatomic, copy) NSString  *gender;
@property (nonatomic, copy) NSString  *token;


@end
