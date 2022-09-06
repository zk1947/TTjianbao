//
//  JHAddResourceCollectionView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/12/2.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHAddResourceCollectionView.h"
#import "JHPhotoCollectionViewCell.h"
#import "TTjianbaoHeader.h"

@implementation JHAddResourceCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat ww = self.itemSizeWidth > 0 ? self.itemSizeWidth : self.bounds.size.width/4.;
    return CGSizeMake(ww, ww);
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHPhotoCollectionViewCell" forIndexPath:indexPath];
    if ([self isAddBtn:indexPath]) {
        cell.photoImage.image = [UIImage imageNamed:self.addImage?: @"bg_add_pic_img"];
        cell.photoImage.contentMode = UIViewContentModeScaleAspectFit;
        cell.showVideoBt = NO;
        cell.deleteBtn.hidden = YES;
    }else {
        cell.photoImage.contentMode = UIViewContentModeScaleAspectFill;
        JHPhotoItemModel *model = self.array[indexPath.row];
        id url = model.image;
        if ([url isKindOfClass:[NSString class]]) {
            [cell.photoImage jhSetImageWithURL:[NSURL URLWithString:url]];
        }else if ([url isKindOfClass:[UIImage class]]) {
            cell.photoImage.image = (UIImage *)url;
        }
        cell.showVideoBt = model.isVideo;
        cell.deleteBtn.hidden = NO;
        JH_WEAK(self)
        cell.deleteBlock = ^(NSIndexPath *sender) {
            JH_STRONG(self)
            self.deleteBlock(indexPath);
        };

    }
    return cell;
    
}


- (BOOL)isAddBtn:(NSIndexPath *)indexPath {
    if (indexPath.row>=self.array.count) {
        return YES;
    }
    return NO;
    
}

@end
