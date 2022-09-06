//
//  JHRightArrowBtn.h
//  TTjianbao
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JHRightArrowStyle)
{
    JHRightArrowStyleDefault,    //默认
    JHRightArrowStyleLight,    //直播间第一行（源头好货|平台鉴定|退换无忧）等新样式,颜色偏暗
    JHRightArrowStyleMediumFont,    //直播间第二行新样式,字体加粗，加图
};


NS_ASSUME_NONNULL_BEGIN

@interface JHRightArrowBtn : UIButton
@property (nonatomic, assign) BOOL isRoughStone;
@property (nonatomic, strong) UIImageView *arrowImage;

//重置展示样式
- (void)resetRightArrowStyle:(JHRightArrowStyle)style;
@end

NS_ASSUME_NONNULL_END
