//
//  JHPersonalResellTableViewCell.h
//  TTjianbao
//  Description:个人转售cell
//  Created by jesee on 20/5/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoneCommonTableViewCell.h"
#import "JHPersonalResellModel.h"

typedef NS_ENUM(NSInteger, JHPersonalResellCellActiveType)
{
    JHPersonalResellCellActiveTypeDelete,
    JHPersonalResellCellActiveTypeEdit,
    JHPersonalResellCellActiveTypeShelve,
    JHPersonalResellCellActiveTypeUnshelve,
    JHPersonalResellCellActiveTypeDetail, //订单详情
    JHPersonalResellCellActiveTypeSend,
};

NS_ASSUME_NONNULL_BEGIN

@interface JHPersonalResellTableViewCell : JHStoneCommonTableViewCell

@property (nonatomic, weak) id<JHTableViewCellDelegate>mDelegate;

- (instancetype)initWithPageStyle:(JHPersonalResellSubPageType)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
