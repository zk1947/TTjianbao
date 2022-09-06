//
//  JHOnlineAppraiseHeader.h
//  TTjianbao
//
//  Created by lihui on 2020/12/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#ifndef JHOnlineAppraiseHeader_h
#define JHOnlineAppraiseHeader_h

#define pagesize                10
#define cellRate (float)        1334.f/750.f //240/170
///顶部大的鉴定师的宽高比
#define topImageRate (float)      198.f/351.f
///鉴定师小视图的宽高比
#define smallImageRate (float)       125./117.5
///广告位宽高比
#define bannerrate (float)      72/351
#define kTopicIconWidth   50.

///顶部大图高度
#define topImageHeight      ((ScreenW-24)*topImageRate)
//#define smallImageWidth     117.5
#define smallImageWidth     (ScreenW-12+7.5-9*2)/3
///小图的高度
#define smallImageHeight    (125.*smallImageRate+10)
///免费鉴定的高度
#define kFreeAppraisseHeight    105.5f
///话题列表的高度
#define headerSegmentHeight     99.5f

#define kGradientHeight   ScreenW*(107./375)
///广告位高度
#define bannerHeight        ((ScreenW-24)*bannerrate)
/// 回收高度
#define recycleHeight 120.0f
///顶部视图的总高度 = 大图高度 + 小图高度 + 免费鉴定 + 广告位 + 话题列表 + 5(大图距上)+9(小图距上)+ 24(banner的上下margin)
#define kDefaultHeaderHeight topImageHeight + smallImageHeight + kFreeAppraisseHeight +5+9+24 + recycleHeight + 12


///写入数据相关
#define kOnlineAppraiserListDataKey  @"kOnlineAppraiserListDataKey"


#endif /* JHOnlineAppraiseHeader_h */
