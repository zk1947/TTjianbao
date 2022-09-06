//
//  JHStoneDetailTopInfoCell.h
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneDetailTopInfoCell : JHWBaseTableViewCell

-(void)setAvatorUrl:(NSString *)url
               name:(NSString *)name
              price:(NSNumber *)price
             number:(NSString *)number
              title:(NSString *)title
         seekNumber:(NSInteger )seekNumber
              array:(NSMutableArray *)array
            resellFlag:(NSInteger)resellFlag;

@end

@interface JHStoneDetailTopInfoCollectionViewCell : JHBaseCollectionViewCell

@end

NS_ASSUME_NONNULL_END
