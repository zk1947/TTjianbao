//
//  JHSkinSceneModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/10/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHSkinSceneModel : NSObject
/// 标题
@property (nonatomic, copy) NSString *titleNor;
@property (nonatomic, copy) NSString *titleSel;
/// 颜色
@property (nonatomic, strong) UIColor *colorNor;
@property (nonatomic, strong) UIColor *colorSel;
/// 背景颜色
@property (nonatomic, strong) UIColor *colorBGNor;
@property (nonatomic, strong) UIColor *colorBGSel;
/// 边框颜色
@property (nonatomic, strong) UIColor *colorBorderNor;
@property (nonatomic, strong) UIColor *colorBorderSel;
/// 图片
@property (nonatomic, strong) UIImage *imageNor;
@property (nonatomic, strong) UIImage *imageSel;
/// 角标图
@property (nonatomic, strong) UIImage *imageCornerNor;
@property (nonatomic, strong) UIImage *imageCornerSel;
@end

