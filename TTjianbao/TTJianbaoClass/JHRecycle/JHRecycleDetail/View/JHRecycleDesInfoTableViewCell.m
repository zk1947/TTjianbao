//
//  JHRecycleDesInfoTableViewCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleDesInfoTableViewCell.h"
#import "JHRecycleDetailModel.h"

@interface JHRecycleDesInfoTableViewCell ()
@property (nonatomic, strong) UILabel *desContentLabel;

@end

@implementation JHRecycleDesInfoTableViewCell

- (void)setupViews{
    //宝贝说明内容
    [self.backView addSubview:self.desContentLabel];
    [self.desContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(0);
        make.left.equalTo(self.backView).offset(12);
        make.right.equalTo(self.backView).offset(-12);
        make.bottom.equalTo(self.backView).offset(-15);
    }];
    

}
- (void)bindViewModel:(id)dataModel{
    JHRecycleDetailModel *detailModel = dataModel;
    self.desContentLabel.text = detailModel.productDesc;
}

- (UILabel *)desContentLabel{
    if (!_desContentLabel) {
        _desContentLabel = [[UILabel alloc] init];
        _desContentLabel.textColor = HEXCOLOR(0x666666);
        _desContentLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _desContentLabel.numberOfLines = 0;
    }
    return _desContentLabel;
}

@end
