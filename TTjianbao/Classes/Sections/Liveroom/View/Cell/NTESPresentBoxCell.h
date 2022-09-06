//
//  NTESPresentBoxCell.h
//  TTjianbao
//
//  Created by chris on 16/3/31.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESPresent.h"

@interface NTESPresentBoxCell : UICollectionViewCell

- (void)refreshPresent:(NTESPresent *)present
                 count:(NSInteger)count;

@end
