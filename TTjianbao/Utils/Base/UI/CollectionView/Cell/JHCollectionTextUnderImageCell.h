//
//  JHCollectionTextUnderImageCell.h
//  TTjianbao
//  Description:image下+text,跟only image样式类似
//  Created by jesee on 18/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCollectionCell.h"

//(kImageSmallSize + kImageTextSpace + kTextHeight + kLineSpace)
//kLineSpace=20此间距在这里体现
#define kTextUnderImageCellOffset 20 //间距kLineSpace=20
#define kTextUnderImageCellWidth 50 //kImageSmallSize
#define kTextUnderImageCellHeight (kTextUnderImageCellWidth+5+17+kTextUnderImageCellOffset)

@interface JHCollectionTextUnderImageCell : JHCollectionCell

@end

