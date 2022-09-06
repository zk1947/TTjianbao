//
//  JHPhotoCollectionView.m
//  TTjianbao
//
//  Created by mac on 2019/6/3.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHPhotoCollectionView.h"
#import "JHPhotoCollectionViewCell.h"
#import "TTjianbaoHeader.h"

@implementation JHPhotoItemModel

@end

@interface JHPhotoCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UILongPressGestureRecognizer *longpress;
@end

@implementation JHPhotoCollectionView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self makeUI];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self makeUI];
    }
    return self;
}
- (void)makeUI {
    self.isShowAddCell = YES;
    self.delegate = self;
    self.dataSource = self;
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longpress.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longpress];
    self.longpress = longpress;
    
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([JHPhotoCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"JHPhotoCollectionViewCell"];
    
}
 - (void)longPress:(UILongPressGestureRecognizer*)longPress{
     if(self.forbidLongPress){
         return;
     }
     NSIndexPath *selectIndexPath = [self indexPathForItemAtPoint:[self.longpress locationInView:self]];

     if ([self isAddBtn:selectIndexPath]) {
         [self cancelInteractiveMovement];
         return;
     }

    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *indexPath = [self indexPathForItemAtPoint:[longPress locationInView:self]];
            
            if (@available(iOS 9.0, *)) {
                [self beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
            if (@available(iOS 9.0, *)) {
                if (self.array.count<6) {
                    CGPoint point = [longPress locationInView:longPress.view];
                    CGFloat x = (self.height+10)*self.array.count;
                    if (point.x>x) {
                        point.x = x;
                    }
                    [self updateInteractiveMovementTargetPosition:point];

                }else {
                    [self updateInteractiveMovementTargetPosition:[longPress locationInView:longPress.view]];

                }
            } else {
                // Fallback on earlier versions
            }
            break;
        case UIGestureRecognizerStateEnded:
            if (@available(iOS 9.0, *)) {
                [self endInteractiveMovement];
            } else {
                // Fallback on earlier versions
            }
            break;
            
        default:if (@available(iOS 9.0, *)) {
            [self cancelInteractiveMovement];
        } else {
            // Fallback on earlier versions
        }
            break;
    }
    
}
 - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
     if (self.isShowAddCell) {
         return self.array.count+1;
     } else {
         return self.array.count;
     }
}

 - (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.bounds.size.height, self.bounds.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{

//   NSIndexPath *selectIndexPath = [collectionView indexPathForItemAtPoint:[self.longpress locationInView:self]];
//
////    JHPhotoCollectionViewCell *cell = (JHPhotoCollectionViewCell*)[self cellForItemAtIndexPath:selectIndexPath];
    if ([self isAddBtn:destinationIndexPath]){
        return;
    }
    if ([self isAddBtn:sourceIndexPath]) {
        return;
    }
    
    [self.array exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    [self reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHPhotoCollectionViewCell" forIndexPath:indexPath];
    if ([self isAddBtn:indexPath]) {
        cell.photoImage.image = [UIImage imageNamed:self.addImage?: @"bg_add_pic_img"];
        cell.photoImage.contentMode = UIViewContentModeScaleAspectFit;
        cell.showVideoBt = NO;
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
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item>=self.array.count) {
        if (self.addPicAction) {
            self.addPicAction(indexPath);
        }
    }else {
        if (self.didSelectedCell) {
            self.didSelectedCell(indexPath);
        }
        
    }
}

- (BOOL)isAddBtn:(NSIndexPath *)indexPath {
    if (self.array.count >= 6) {
        return NO;
    }
    
    if (indexPath.row >= self.array.count) {
        return YES;
    }
    
    return NO;
    
}

@end
