//
//  JHOnlineListCollectionCell.m
//  TTjianbao
//
//  Created by lihui on 2020/12/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOnlineListCollectionCell.h"
#import "TTjianbaoHeader.h"

#define cellRate (float)  (249.f/171) //240/170

@interface JHOnlineListCollectionCell ()
@property (strong, nonatomic) YYAnimatedImageView *coverImage;
@property (strong, nonatomic) UILabel* title;
@property (nonatomic, strong) UIButton *playButton;
@end

@implementation JHOnlineListCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView * backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 4;
        backView.clipsToBounds = YES;
        [self.contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        _coverImage = [[YYAnimatedImageView alloc] init];
        _coverImage.layer.masksToBounds = YES;
        _coverImage.clipsToBounds = YES;
        [backView addSubview:_coverImage];
        [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.right.offset(0);
            make.height.offset((ScreenW-24-9)/2*cellRate);
        }];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"online_play_circle"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"online_play_circle"] forState:UIControlStateHighlighted];
        _playButton.userInteractionEnabled = NO;
        [_coverImage addSubview:_playButton];
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25., 25.));
            make.right.equalTo(self.coverImage).offset(-10);
            make.top.equalTo(self.coverImage).offset(10);
        }];

        _title = [[UILabel alloc] init];
        _title.font = [UIFont fontWithName:kFontNormal size:14.];
        _title.backgroundColor = [UIColor clearColor];
        _title.textColor = HEXCOLOR(0x333333);
        _title.numberOfLines = 1;
        _title.text = @"";
        _title.numberOfLines = 2;
        _title.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        [backView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(backView).offset(-10);
            make.top.equalTo(self.coverImage.mas_bottom).offset(10);
            make.left.equalTo(backView).offset(10);
        }];
    }
    return self;
}

- (void)setPostData:(JHPostDetailModel *)postData {
    if (!postData) {
        return;
    }
    _postData = postData;
    _title.text = [_postData.content isNotBlank] ? _postData.content : @"暂无描述~";
    _coverImage.contentMode = UIViewContentModeScaleAspectFill;
    NSString *coverString = _postData.videoInfo.image;//  ThumbSmallByOrginal(_recordMode.coverImg);
    @weakify(self);
    [_coverImage jhSetImageWithURL:[NSURL URLWithString:coverString] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        @strongify(self);
        if (!image) {
             self.coverImage.contentMode = UIViewContentModeScaleAspectFill;
       }
    }];
}

+ (CGFloat)heightCellWithModel:(JHPostDetailModel *)model {
    CGFloat height = (ScreenW-24-9)/2*cellRate;
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:kFontBoldPingFang size:15.]};
    CGFloat titleH = 0;
    if (model.content && model.content.length > 0) {
        titleH = [model.content boundingRectWithSize:CGSizeMake((ScreenW-24-9)/2 - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.height;
    }
    
    if (titleH > 40) {
        titleH = 40;
    }
    return height+titleH+20;
}

@end
