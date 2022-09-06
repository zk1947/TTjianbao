//
//  JHHotListTableViewCell.m
//  TTjianbao
//
//  Created by lihui on 2020/6/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHotListTableViewCell.h"
#import "TTjianbao.h"
#import "JHSQModel.h"

@interface JHHotListTableViewCell ()

///帖子封面图
@property (nonatomic, strong) UIImageView *faceImageView;

///帖子标题
@property (nonatomic, strong) UILabel *titleLabel;

///帖子作者昵称/板块
@property (nonatomic, strong) UILabel *nickNameLabel;

///序号
@property (nonatomic, weak) UILabel *sortLabel;

///小视频icon
@property (nonatomic, weak) UIImageView *videoIconView;

@end

@implementation JHHotListTableViewCell

- (void)dealloc {
    NSLog(@"JHHotListTableViewCell --- 🔥🔥🔥🔥");
}

+ (CGFloat)cellHeight {
    return 91;
}

- (void)setPostData:(JHPostData *)postData {
    if (!postData) {
        return;
    }
    _postData = postData;
    if (_postData.images_thumb.count > 0) {
        NSString *imageUrl = _postData.images_thumb[0];
        [_faceImageView jhSetImageWithURL:[NSURL URLWithString:imageUrl] placeholder:kDefaultCoverImage];
    }
    _titleLabel.text = _postData.title;
    
    NSString *desc = _postData.publisher.user_name;
    if(_postData.plate_info)
    {
        desc = [NSString stringWithFormat:@"%@/%@",_postData.publisher.user_name,_postData.plate_info.name];
    }
    _nickNameLabel.text = desc;
    
    _videoIconView.hidden = (_postData.item_type != JHPostItemTypeVideo);
}

-(void)setSortNum:(NSInteger)sortNum
{
    _sortNum = sortNum;
    self.sortLabel.text = [NSString stringWithFormat:@"%@",@(_sortNum)];
    self.sortLabel.textColor = _sortNum > 3 ? RGB515151 : UIColor.whiteColor;
    switch (_sortNum) {
        case 1:
            self.sortLabel.backgroundColor = RGB(255, 216, 0);
            break;
            
        case 2:
            self.sortLabel.backgroundColor = RGB(255, 180, 51);
            break;
            
        case 3:
            self.sortLabel.backgroundColor = RGB(221, 187, 148);
            break;
            
        default:
            self.sortLabel.backgroundColor = UIColor.whiteColor;
            break;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        
        self.contentView.backgroundColor = UIColor.clearColor;
        self.backgroundView.backgroundColor = UIColor.clearColor;
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)setupViews
{
    _sortLabel = [UILabel jh_labelWithFont:16 textColor:RGB515151 addToSuperView:self.contentView];
    _sortLabel.textAlignment = 1;
    _sortLabel.font = JHDINBoldFont(16);
    [_sortLabel jh_cornerRadius:4];
    
    _faceImageView = [[UIImageView alloc] init];
    _faceImageView.image = kDefaultCoverImage;
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_faceImageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"玉佛不能随便带，要选择自己的本命佛，你知道吗?";
    _titleLabel.numberOfLines = 2;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    _titleLabel.textColor = HEXCOLOR(0x333333);
    [self.contentView addSubview:_titleLabel];
    
    _nickNameLabel = [[UILabel alloc] init];
    _nickNameLabel.text = @"全场消费有赵公子买单";
    _nickNameLabel.font = [UIFont fontWithName:kFontNormal size:12];
    _nickNameLabel.textColor = kColor999;
    [self.contentView addSubview:_nickNameLabel];
    
    _videoIconView = [UIImageView jh_imageViewWithImage:@"icon_video_play" addToSuperview:_faceImageView];
    
    ///设置布局
    [self makeLayouts];
}

- (void)makeLayouts
{
    [_sortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(21.f, 21.f));
        make.left.equalTo(self.contentView).offset(26.f);
    }];
    
    [_faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(57);
        make.top.equalTo(self.contentView).offset(15);
        make.height.width.mas_equalTo(71);
    }];
    
    [_videoIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.faceImageView);
        make.size.mas_equalTo(CGSizeMake(25.f, 25.f));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.faceImageView.mas_right).offset(10.f);
        make.top.equalTo(self.faceImageView).offset(3.f);
        make.right.equalTo(self.contentView).offset(-10.f);
    }];
        
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-15.f);
        make.bottom.equalTo(self.faceImageView).offset(-3.f);
    }];
    
    _faceImageView.layer.cornerRadius = 8.f;
    _faceImageView.layer.masksToBounds = YES;
}

@end
