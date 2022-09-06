//
//  JHCollectionImgTextCell.h
//  TTjianbao
//  Description:详情复用CollectionView之cell
//  1:image+text 2-ext:image+text+X(e.g. close)
//  Created by jesee on 18/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCollectionCell.h"

//1:image+text
@interface JHCollectionImgTextCell : JHCollectionCell

@end

//2-ext:image+text+X(e.g. close)
@interface JHCollectionImgTextCellExt : JHCollectionImgTextCell

@property (nonatomic, copy) dispatch_block_t deleteBlock;
@end
