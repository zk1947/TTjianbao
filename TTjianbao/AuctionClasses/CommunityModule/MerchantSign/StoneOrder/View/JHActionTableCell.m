//
//  JHActionTableCell.m
//  TaodangpuAuction
//
//  Created by apple on 2019/11/7.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHActionTableCell.h"

@interface JHActionTableCell ()

///升跌设定按钮
@property (nonatomic, strong) UIButton *setButton;
///上传图片视频按钮
@property (nonatomic, strong) UIButton *uploadButton;

@end

@implementation JHActionTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)setStoneModel:(JHOriginStoneModel *)stoneModel {
    _stoneModel = stoneModel;
    if (!_stoneModel) {
        return;
    }
    
    
    
    
    
}

- (void)initSubViews {
    _setButton = [[UIButton alloc] init];
    [_setButton setTitle:@"升跌设定" forState:UIControlStateNormal];
    [_setButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_setButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_setButton addTarget:self action:@selector(setButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_setButton];
    
    _uploadButton = [[UIButton alloc] init];
    _uploadButton.backgroundColor = [UIColor orangeColor];
    [_uploadButton setTitle:@"上传视频图片" forState:UIControlStateNormal];
    [_uploadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_uploadButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_uploadButton addTarget:self action:@selector(uploadButtonClick:)  forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_uploadButton];
     
    [_uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-10);
        make.centerY.equalTo(self);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    [_setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.uploadButton.mas_left).with.offset(-10);
        make.width.equalTo(self.uploadButton.mas_width);
        make.height.equalTo(self.uploadButton.mas_height);
        make.centerY.equalTo(self.uploadButton.mas_centerY);
    }];
}


///升跌设定 action
- (void)setButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(setAction:)]) {
        [self.delegate setAction:self.indexPath];
    }
}

///上传图片视频 anction
- (void)uploadButtonClick:(UIButton *)sender {
    NSLog(@"上传视频图片 anction");
   if ([self.delegate respondsToSelector:@selector(uploadAction:)]) {
        [self.delegate uploadAction:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
