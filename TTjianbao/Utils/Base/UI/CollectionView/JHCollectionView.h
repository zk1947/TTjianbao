//
//  JHCollectionView.h
//  TTjianbao
//  Description:复用CollectionView
//  Created by jesee on 15/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCollectionImgTextCell.h"
#import "JHCollectionTextUnderImageCell.h"

#define kMaxItemCountOfLine 3

typedef NS_ENUM(NSUInteger, JHDetailCollectionCellType)
{
    JHDetailCollectionCellTypeDefault,
    JHDetailCollectionCellTypeOnlyImage = JHDetailCollectionCellTypeDefault,
    JHDetailCollectionCellTypeTextUnderImage, //image下+text,跟only image样式类似
    JHDetailCollectionCellTypeImageText, //默认折行,不能滚动
    JHDetailCollectionCellTypeImageTextScroll, //可以横向滚动
    JHDetailCollectionCellTypeImageTextScrollCross, //可以横向滚动,且有X号
};

@protocol JHDetailCollectionDelegate <NSObject>

@optional
- (void)clickCollectionItem:(id)item;
@end

@interface JHCollectionView : UIView

@property (nonatomic, weak) id<JHDetailCollectionDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(JHDetailCollectionCellType)type;
- (void)makeLayout:(CGSize)size lineSpace:(CGFloat)lineSpace itemSpace:(CGFloat)itemSpace;
- (void)updateData:(NSArray*)array;
@end

