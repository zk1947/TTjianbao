//
//  NTESPresentAttachment.h
//  TTjianbao
//
//  Created by chris on 16/3/30.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMSDK/NIMSDK.h"

@interface NTESPresentAttachment : NSObject<NIMCustomAttachment>

@property (nonatomic,assign) NSInteger presentType; //此类型请在 Presents.plist 中定义,为各礼物的 key 值。

@property (nonatomic,assign) NSInteger count;


@property (nonatomic, copy) NSDictionary *giftInfo;
@property (nonatomic, copy) NSDictionary *receiver;

@property (nonatomic, copy) NSDictionary *sender;

//
//giftInfo =     {
//    giftId = 2;
//    giftImg = "https://huifeideyu2.b0.upaiyun.com//20190104/1546599302720.png";
//    giftName = "\U68d2\U68d2\U54d2";
//    giftNum = 1;
//};
//receiver =     {
//    anchorId = 17;
//    icon = "";
//    nick = "\U592a\U968f\U4fbf";
//    userAccount = de70026f8d4147149762770743930b1b;
//};
//sender =     {
//    icon = "http://thirdwx.qlogo.cn/mmopen/vi_32/mPcOufbpy71ePaicHMv4iaFIChC0VBYNgK6BokPosJ3T0ibXqibwnfQCENNevtaNIn2Lic5URV5kjalLh3RnXcfpEfQ/132";
//    nick = "\U5566\U5566\U5566";
//    userAccount = 0dedc7292fc5407ba659c7d5d2604e67;
//    viewerId = 8;
//};


@end
