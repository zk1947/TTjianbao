//
//  JHSearchTagsCollectionCell.m
//  TTjianbao
//
//  Created by hao on 2021/10/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSearchTagsCollectionCell.h"
#import "JHNewSearchResultRecommendTagsModel.h"

@interface JHSearchTagsCollectionCell ()
///标签
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation JHSearchTagsCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF8F8F8);
        [self jh_cornerRadius:self.height/2];
        
        [self setupUI];
    }
    return self;
}
#pragma mark  - 设置UI
- (void)setupUI{
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview:self.deleteBtn];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(7);
        make.right.equalTo(self.contentView).offset(-23);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(23, 22));
    }];
    
}
#pragma mark - LoadData
//数据绑定
- (void)bindViewModel:(id)dataModel params:(NSDictionary* _Nullable )parmas{
    JHNewSearchResultRecommendTagsListModel *model = dataModel;
    self.tagLabel.text = model.tagWord;
}

#pragma mark - Action
- (void)clickDeleteBtnAction:(UIButton *)sender{
    if (self.clickDeleteBtnBlock) {
        self.clickDeleteBtnBlock();
    }
}

#pragma mark - Delegate


#pragma mark - Lazy
- (UILabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [UILabel new];
        _tagLabel.textColor = HEXCOLOR(0x333333);
        _tagLabel.font = JHFont(13);
    }
    return _tagLabel;
}
- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
        [_deleteBtn setImage:JHImageNamed(@"c2c_class_alert_close") forState:UIControlStateNormal];
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(7.5, 8, 7.5, 8);
        [_deleteBtn addTarget:self action:@selector(clickDeleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _deleteBtn;
}
@end
