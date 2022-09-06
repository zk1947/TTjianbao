//
//  ZQSearchNormalCell.h
//  ZQSearchController
//
//  Created by zzq on 2018/9/25.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQSearchNormalCell : UICollectionViewCell

+ (CGFloat)cellHeight;

//@property (nonatomic, copy) NSString *title;
/// 火热图片
@property (weak, nonatomic) IBOutlet UIImageView *hotImagV;
/// 文字
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@end
