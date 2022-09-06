//
//  JHHomeCollectionViewFlowLayout.m
//  TTjianbao
//
//  Created by yaoyao on 2019/4/28.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHHomeCollectionViewFlowLayout.h"

@implementation CellSizeModel

@end

@interface JHHomeCollectionViewFlowLayout ()
@property(nonatomic,strong)NSMutableArray *attrArray;
@property(nonatomic,strong)NSMutableArray *frameYa;

@property(nonatomic,assign)float leftMargin;
@property(nonatomic,assign)float rightMargin;

@end


@implementation JHHomeCollectionViewFlowLayout

- (instancetype)initWithColoumn:(int)coloumn  data:(NSMutableArray *)dataA   verticleMin:(float)minv  horizonMin:(float)minh  leftMargin:(float)leftMargin  rightMargin:(float)rightMargin headerHeight:(float)headerHeight {
    self = [super init];
    if (self) {
        self.iconArray = dataA;
        self.minimumLineSpacing = minv;
        self.minimumInteritemSpacing = minh;
        self.leftMargin = leftMargin;
        self.rightMargin = rightMargin;
        self.colunms = coloumn;
        self.headerHeight = headerHeight+45;

        self.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 45);

    }
    return self;
}

- (void)prepareLayout{
    //计算每个cell的宽度
    [super prepareLayout];
    NSLog(@"2222222prepareLayout");
    [self.attrArray removeAllObjects];

    self.minimumLineSpacing = self.minimumLineSpacing;
    self.minimumInteritemSpacing = self.minimumInteritemSpacing;
    self.sectionInset = UIEdgeInsetsMake(_headerHeight, self.leftMargin, 0, self.rightMargin);

    self.frameYa = [NSMutableArray arrayWithCapacity:self.colunms];
    for (int i = 0; i<self.colunms; i++) {
        self.frameYa[i] = @(self.sectionInset.top);
    }

    
    for(int i = 0;i<self.iconArray.count;i++){
        CellSizeModel *iconModel = self.iconArray[i];
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:1];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
        [self.attrArray addObject:attributes];
        //计算每个cell的高度
        float itemW = iconModel.width;

        float itemH = [self getcellHWithOriginSize:CGSizeMake(iconModel.width, iconModel.height) itemW:itemW];
        itemH = iconModel.height;

        if (self.showDefaultImage || iconModel.width == ScreenW) {
            itemH = iconModel.height;
            
        }

        //计算当前cell处于第几列
        int lie = [self getMinLie:self.frameYa];
        float itemX = self.sectionInset.left +(self.minimumInteritemSpacing+itemW)*(lie);
        float itemY = [self.frameYa[lie] floatValue];
        float result  = (itemH + self.minimumLineSpacing) + [self.frameYa[lie] floatValue];
        self.frameYa[lie] = @(result);
        attributes.frame = CGRectMake(itemX, itemY, itemW, itemH);

        if (self.showDefaultImage || iconModel.width == ScreenW) {
            attributes.frame = CGRectMake(0, itemY, iconModel.width, iconModel.height);
        }


    }
    


//    if (self.iconArray.count){} else {
//        UICollectionViewLayoutAttributes * layoutHeader = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//
//        NSLog(@"%@", NSStringFromCGRect(layoutHeader.frame));
//        layoutHeader.frame = CGRectMake(0,ScreenH, self.footerReferenceSize.width, ScreenH);
//        NSLog(@"%@", NSStringFromCGRect(layoutHeader.frame));
//
//        [self.attrArray addObject:layoutHeader];
//    }



}
//计算没行中每个cell的最大Y值
- (int)getMinLie:(NSMutableArray *)frameYa{
    int col = 0;
    float min = [frameYa[col] floatValue];
    for (int i = 1; i<self.colunms; i++) {
        if(min>[frameYa[i] floatValue]){
            min = [frameYa[i] floatValue];
            col = i;
        }

    }

    return col;
}
//计算cell的高度
- (float)getcellHWithOriginSize:(CGSize)originSize itemW:(float)itemW{

    return itemW*originSize.height/originSize.width;

}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSLog(@"2222222layoutAttributesForElementsInRect");
    return self.attrArray;

}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"2222222layoutAttributesForSupplementaryViewOfKind");
    UICollectionViewLayoutAttributes *layout = [super layoutAttributesForSupplementaryViewOfKind:elementKind
                                                 atIndexPath:indexPath];
    NSLog(@"%@", NSStringFromCGRect(layout.frame));
    layout.frame = CGRectMake(0, self.sectionInset.top-45, ScreenW, 45);
    return layout;

}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"2222222layoutAttributesForItemAtIndexPath");
    UICollectionViewLayoutAttributes *layout = [super layoutAttributesForItemAtIndexPath:indexPath];
    return layout;
}

- (NSMutableArray *)attrArray{
    if(!_attrArray){
        _attrArray = [NSMutableArray array];
    }
    return _attrArray;
}
- (CGSize)collectionViewContentSize{

    int maxindex = 0;
    float max = [self.frameYa[maxindex] floatValue];

    for (int i = 1; i<self.frameYa.count; i++) {

        if([self.frameYa[i] floatValue]>max){

            max = [self.frameYa[i] floatValue];
            maxindex = i;
        }

    }
    return CGSizeMake(0, max);
}
- (NSMutableArray *)frameYa{
    if(!_frameYa){
        _frameYa = [NSMutableArray array];
    }
    return _frameYa;
}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return YES;
//}
@end
