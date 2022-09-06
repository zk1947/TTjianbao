//
//  JHRecorderModel.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/13.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecorderModel : NSObject
/*accid = 4ca70ef793434f4c8bb6d4baf96b7fbb;
 anchorDesc = "\U5e73\U53f0\U8ba4\U8bc1\U9274\U5b9a\U5e08";
 anchorIcon = "http://thirdwx.qlogo.cn/mmopen/vi_32/mPcOufbpy71ePaicHMv4iaFIChC0VBYNgK6BokPosJ3T0ibXqibwnfQCENNevtaNIn2Lic5URV5kjalLh3RnXcfpEfQ/132";
 anchorId = 12;
 anchorName = "\U5927\U98de\U54e5";
 appraisePrice = 50088;
 chartlet = "https://jianhuo-test.nos-eastchina1.126.net/user_dir/apply_appraisal/15473665967275737.jpg";
 content = "\U7ecf\U9274\U5b9a\Uff0c\U6b64\U5b9d\U8d1d\U4e8e\U6b63\U54c1\U76f8\U4f3c\U5ea6\U8f83\U9ad8\Uff0c\U81ea\U52a8\U673a\U68b0\U673a\U82af\Uff0c\U914d\U4ef6\U9f50\U5168\Uff0c\U4e14\U6027\U4ef7\U6bd4\U8d85\U9ad8\Uff0c\U5347\U503c\U6f5c\U529b\U5de8\U5927\U3002";
 icon = "http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83eq9LcCI2rmwibbNBFTF2KiajR2kpNDhyX3qagloXL8jS3Mge3dkMmcEGWFMy8zeMVicBKB24UibOFQic5w/132";
 id = 10;
 name = "\U9eef&\U97f5";
 
*/
@property (nonatomic, copy) NSString *accid;
@property (nonatomic, copy) NSString *anchorDesc;
@property (nonatomic, copy) NSString *anchorIcon;
@property (nonatomic, copy) NSString *anchorId;
@property (nonatomic, copy) NSString *anchorName;
@property (nonatomic, copy) NSString *appraisePrice;
@property (nonatomic, copy) NSString *appraisePriceStr;
@property (nonatomic, copy) NSString *chartlet;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *appraiseRecordId;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, assign) NSInteger result;

@end

NS_ASSUME_NONNULL_END
