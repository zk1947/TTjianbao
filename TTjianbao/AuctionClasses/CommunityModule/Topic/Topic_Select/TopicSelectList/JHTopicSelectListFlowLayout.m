//
//  JHTopicSelectListFlowLayout.m
//  TTjianbao
//
//  Created by wuyd on 2019/7/30.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTopicSelectListFlowLayout.h"
#import "JHTopicSelectListHeader.h"

@implementation JHTopicSelectListFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15); //整体边距
        self.minimumLineSpacing = 10.0;
        self.minimumInteritemSpacing = 5.0;
        /**
        CGFloat itemWidth = (ScreenWidth - 30 - kMarginX*(kColumnCount - 1)) / kColumnCount;
        self.itemSize = CGSizeMake(itemWidth, kCCellHeight);
        self.minimumLineSpacing = kMarginY; //行间距(纵)
        self.minimumInteritemSpacing = kMarginX;
        //self.headerReferenceSize = CGSizeMake(ScreenWidth, [JHTopicSelectListHeader headerHeight]);
        //self.footerReferenceSize = CGSizeMake(ScreenWidth, 100.0);
         */
    }
    return self;
}

@end
