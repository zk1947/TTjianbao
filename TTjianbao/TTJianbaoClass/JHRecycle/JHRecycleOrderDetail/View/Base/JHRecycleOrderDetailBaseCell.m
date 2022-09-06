//
//  JHRecycleOrderDetailBaseCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailBaseCell.h"

@interface JHRecycleOrderDetailBaseCell()
@end
@implementation JHRecycleOrderDetailBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Life Cycle Functions

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupBaseUI];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutBaseViews];
}

- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions

#pragma mark - Private Functions
#pragma mark - Action functions
#pragma mark - Bind
- (void) bindData {
    
}
#pragma mark - setupUI
- (void) setupBaseUI {
    self.backgroundColor = UIColor.clearColor;
    self.contentView.userInteractionEnabled = false;
    self.content.userInteractionEnabled = true;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.content];
}
- (void) layoutBaseViews {
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self.contentView).offset(0);
//        make.left.equalTo(self.contentView).offset(ContentLeftSpace);
//        make.right.equalTo(self.contentView).offset(-ContentLeftSpace);
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, ContentLeftSpace, 0, ContentLeftSpace));
    }];
}
- (void)setupCornerRadiusWithRect : (RecycleOrderDetailCornerType) rectCorner{
    [self layoutIfNeeded];
    self.content.backgroundColor = UIColor.clearColor;
    switch (rectCorner) {
        case RecycleOrderDetailCornerNo:
            self.content.image = nil;
            self.content.backgroundColor = UIColor.whiteColor;
            break;
        case RecycleOrderDetailCornerAll:
            self.content.image = [UIImage imageNamed:@"recycle_orderDetail_all_bg"];
            break;
        case RecycleOrderDetailCornerTop:
            self.content.image = [UIImage imageNamed:@"recycle_orderDetail_top_bg"];
            break;
        case RecycleOrderDetailCornerBottom:
            self.content.image = [UIImage imageNamed:@"recycle_orderDetail_bottom_bg"];
            break;
        default:
            break;
    }
}
- (RecycleOrderDetailCornerType)getCornerTypeWithValue : (NSInteger)value {
    switch (value) {
        case 1:
            return RecycleOrderDetailCornerTop;
            break;
        case 2:
            return RecycleOrderDetailCornerBottom;
        case 3:
            return RecycleOrderDetailCornerAll;
        case 4:
            return RecycleOrderDetailCornerNo;
        default:
            return RecycleOrderDetailCornerNo;
            break;
    }
}
#pragma mark - Lazy
- (UIImageView *)content {
    if (!_content) {
        _content = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _content;
}
@end
