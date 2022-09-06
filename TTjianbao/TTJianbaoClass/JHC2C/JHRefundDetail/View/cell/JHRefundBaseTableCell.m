//
//  JHRefundBaseTableCell.m
//  TTjianbao
//
//  Created by hao on 2021/5/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRefundBaseTableCell.h"

@implementation JHRefundBaseTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HEXCOLOR(0xF5F5F8);
        [self.contentView addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.f));
        }];
        [self setupViews];
        
    }
    return self;
}
- (void)setupViews{
   
}

- (void)bindViewModel:(id)dataModel{
    
}

- (void)setOrderId:(NSString *)orderId{
    _orderId = orderId;
}
- (void)setOrderStatusCode:(NSString *)orderStatusCode{
    _orderStatusCode = orderStatusCode;
}
- (void)setUserIdentity:(NSInteger)userIdentity{
    _userIdentity = userIdentity;
}
- (void)setWorkOrderId:(NSString *)workOrderId{
    _workOrderId = workOrderId;
}
- (void)setWorkOrderStatus:(NSString *)workOrderStatus{
    _workOrderStatus = workOrderStatus;
}
- (void)setUserId:(NSString *)userId{
    _userId = userId;
}
- (void)setOrderInfo:(JHChatOrderInfoModel *)orderInfo{
    _orderInfo = orderInfo;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColor.whiteColor;
        _backView.layer.cornerRadius = 8;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}


- (NSString *)timestampSwitchTime:(NSInteger)timestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
@end
