//
//  JHCollectionCell.h
//  TTjianbao
//  Description:详情复用CollectionView之cell-image only
//  Created by jesee on 15/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, strong) UIImageView* imageView;

- (void)drawSubviews;
- (void)updateCellImage:(NSString*)image;
- (void)updateCellImage:(NSString*)image text:(NSString*)text;
@end

