//
//  JHRecycleOrderBusinessBaseCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessBaseCell.h"

@implementation JHRecycleOrderBusinessBaseCell

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
    self.contentView.userInteractionEnabled = false;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void) layoutBaseViews {
    
}

#pragma mark - Lazy
@end
