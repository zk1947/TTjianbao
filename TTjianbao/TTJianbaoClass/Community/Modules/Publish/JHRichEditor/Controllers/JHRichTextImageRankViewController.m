//
//  JHRichTextImageRankViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2020/7/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRichTextImageRankViewController.h"
#import "JHRichImageRankCell.h"
#import <UIImage+WebP.h>
@interface JHRichTextImageRankViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesTure;
@property (nonatomic, strong) UIImageView *tipImagView;
@end

@implementation JHRichTextImageRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initToolsBar];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction)  forControlEvents:UIControlEventTouchUpInside];
    self.title = @"排序";
    [self initRightButtonWithName:@"完成" action:@selector(complete)];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
//    [self.navbar addrightBtn:@"完成" withImage:nil withHImage:nil withFrame:CGRectMake(ScreenW-60,0,50,44)];
//       [self.navbar.rightBtn addTarget :self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
//    [self.navbar setTitle:@"排序"];
    [self.view addSubview:self.collectionView];
    
    [self showTipImge];

}
-(void)showTipImge{
    
    if (self.albumArray.count<2) {
        return;
    }
    if ([CommHelp isFirstForName:@"showRichImageSortTip"]){
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(((ScreenW-25)/4)-(131/2)+2.5, 10, 131, 76)];
           imageView.backgroundColor=[UIColor clearColor];
           NSString *path = [[NSBundle mainBundle] pathForResource:@"richtext_sort_tip" ofType:@"webp"];
           NSData *data = [NSData dataWithContentsOfFile:path];
           UIImage *webpImage = [UIImage sd_imageWithWebPData:data];
           imageView.image = webpImage;
           [self.collectionView addSubview:imageView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [imageView removeFromSuperview];
        });
    }
    
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(10,5,10,5);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.contentInset = UIEdgeInsetsMake(0,0, 0, 0);
        [_collectionView registerClass:[JHRichImageRankCell class] forCellWithReuseIdentifier:@"JHRichImageRankCell"];
       _longPressGesTure= [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMoving:)];
        _longPressGesTure.minimumPressDuration = 0.1;
        [_collectionView addGestureRecognizer:_longPressGesTure];
    }
    return _collectionView;;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     JHRichImageRankCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHRichImageRankCell" forIndexPath:indexPath];
    cell.mode = self.albumArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}
#pragma mark - UICollectionViewLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        CGFloat w =(ScreenW-25)/4;
        return CGSizeMake(w,w);
}
- (void)longPressMoving:(UILongPressGestureRecognizer *)longPress{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            {
    NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
    [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
       [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:longPress.view]];
        break;
        }
        case UIGestureRecognizerStateEnded: {
        [self.collectionView endInteractiveMovement];
        break;
        }
        default:
        [self.collectionView cancelInteractiveMovement];
        break;
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{

       JHAlbumPickerModel * mode = self.albumArray[sourceIndexPath.item];
       [self.albumArray removeObjectAtIndex:sourceIndexPath.item];
       [self.albumArray insertObject:mode atIndex:destinationIndexPath.item];
       [self.collectionView reloadData];
//    [self.albumArray exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
}
#pragma mark - action
-(void)complete{
    if (self.completeBlock) {
        self.completeBlock(self.albumArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
