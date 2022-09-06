//
//  JHPostDetailImageTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/9/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPostDetailImageTableCell.h"
#import <SDImageCache.h>
#import "TTjianbaoMarcoUI.h"

@interface JHPostDetailImageTableCell ()
@property (nonatomic, strong) UIImageView *detailImageView;
@end

@implementation JHPostDetailImageTableCell

- (void)setDetailString:(NSString *)detailString {
    if (!detailString) {
        return;
    }
    
    _detailString = detailString;
    UIImage *cachedImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_detailString];
    if (!cachedImg) {
        cachedImg = kDefaultCoverImage;
    }
    if(_detailImageView)
    {
        CGFloat height = (ScreenW - 30);
        //防止除0
        if(cachedImg.size.width > 0){
            height = height * (cachedImg.size.height / cachedImg.size.width);
            _detailImageView.image = cachedImg;
            [_detailImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
        }
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIImageView *imageV = [[UIImageView alloc] initWithImage:kDefaultCoverImage];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.layer.cornerRadius = 8.f;
    imageV.clipsToBounds = YES;
    [self.contentView addSubview:imageV];
    _detailImageView = imageV;
    imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleDetailImageEvent)];
    [imageV addGestureRecognizer:tapGR];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:bottomView];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(0);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.top.equalTo(imageV.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
}

- (void)__handleDetailImageEvent {
    if (self.imageBlock) {
        self.imageBlock(@[_detailImageView], self.indexPath);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
