//
//  JHCustomServLaypot.m
//  TTjianbao
//
//  Created by apple on 2020/9/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomServLayout.h"
#import "JHCustomSerDecorationView.h"
@interface JHCustomServLayout ()
/** attrs的数组 */
@property(nonatomic,strong)NSMutableArray * attrsArr;
@property(nonatomic,assign)float decorationViewH;
@end

@implementation JHCustomServLayout
-(void)prepareLayout{

    [super prepareLayout];
    self.decorationViewH = 200*ScreenW/375;
    [self registerClass:[JHCustomSerDecorationView class] forDecorationViewOfKind:@"JHCustomSerDecorationView"];//注册Decoration View
    [self.attrsArr removeAllObjects];
    NSInteger count =[self.collectionView numberOfItemsInSection:0];
    for (int i=0; i<count; i++) {
        NSIndexPath *  indexPath =[NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attrs=[self layoutAttributesForItemAtIndexPath:indexPath];
       [self.attrsArr addObject:attrs];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{

    //把Decoration View的布局加入可见区域布局。
    [self.attrsArr addObject:[self layoutAttributesForDecorationViewOfKind:@"JHCustomSerDecorationView" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]];

    return self.attrsArr;

}

-(CGSize)collectionViewContentSize
{
    CGFloat itemW = (ScreenW-25) / 2 ;
    CGFloat itemH = itemW * 249 / 171;
    float count =(float)[self.collectionView numberOfItemsInSection:0];
    
    return CGSizeMake(ScreenW, ceilf(count/2) * (itemH + 5) + self.decorationViewH + 10);
    
}
 

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path

{

    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];

    NSInteger i = path.item;
    CGFloat itemW = (ScreenW-25) / 2 ;
    CGFloat itemH = itemW * 249 / 171;
    attributes.size = CGSizeMake(itemW, itemH);
    if ((i%2)==0) {
        attributes.frame = CGRectMake(10, floorf(i/2)*(itemH+5) + self.decorationViewH + 10, itemW, itemH);
    }else{
        attributes.frame = CGRectMake(10+5+itemW, floorf(i/2)*(itemH+5) + self.decorationViewH + 10, itemW, itemH);
    }

    return attributes;

}

//Decoration View的布局。

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewLayoutAttributes* att = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];

    att.frame=CGRectMake(0, 0, ScreenW, self.decorationViewH);

    att.zIndex=-1;

    return att;
}


-(NSMutableArray *)attrsArr
{
    if(!_attrsArr){
        _attrsArr=[[NSMutableArray alloc] init];
    }
    return _attrsArr;
}

@end
