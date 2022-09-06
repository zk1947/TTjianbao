//
//  JHRecycleDetailBaseTableViewCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleDetailBaseTableViewCell.h"

@implementation JHRecycleDetailBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self setupViews];

    }
    return self;
}

- (void)setupViews{
    
}

- (void)bindViewModel:(id)dataModel{
    
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}
@end
