//
//  JHAuthImageTableViewCell.m
//  TTjianbao
//
//  Created by lihui on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAuthImageTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface JHAuthImageTableViewCell ()
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation JHAuthImageTableViewCell

- (void)setImageNameString:(NSString *)imageNameString {
    _imageNameString = imageNameString;
    if ([imageNameString isNotBlank]) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:imageNameString] placeholderImage:kDefaultCoverImage];
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kColorFFF;
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView];
        _imgView.image = kDefaultCoverImage;
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
