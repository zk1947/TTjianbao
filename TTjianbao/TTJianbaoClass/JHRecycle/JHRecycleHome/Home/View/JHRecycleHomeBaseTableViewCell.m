//
//  JHRecycleHomeBaseTableViewCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeBaseTableViewCell.h"

@implementation JHRecycleHomeBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HEXCOLOR(0xF5F5F8);
        [self.contentView addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f));
        }];

        [self configUI];
        
    }
    return self;
}
- (void)configUI{
   
}

- (void)bindViewModel:(id)dataModel{
    
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColor.whiteColor;
      //  _backView.layer.cornerRadius = 5;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
- (RACSubject *)loginSuccessSubject{
    if (!_loginSuccessSubject) {
        _loginSuccessSubject = [[RACSubject alloc] init];
    }
    return _loginSuccessSubject;
}
@end
