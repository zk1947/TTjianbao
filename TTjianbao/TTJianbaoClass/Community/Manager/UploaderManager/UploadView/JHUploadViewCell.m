//
//  JHUploadViewCell.m
//  TTjianbao
//
//  Created by apple on 2019/10/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHUploadViewCell.h"
#import "JHProgressView.h"
#import "JHUploadManager.h"


@interface JHUploadViewCell ()

///图标
@property (nonatomic, strong) UIImageView *iconImageView;

///文字描述
@property (nonatomic, strong) UILabel *titleLabel;

///重新上传按钮
@property (nonatomic, strong) UIButton *reuploadButton;
///取消上传按钮
@property (nonatomic, strong) UIButton *cancelButton;


///进度条
@property (nonatomic, strong) JHProgressView *proressView;


@end

@implementation JHUploadViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setArticle:(JHArticleItemModel *)article {
    _article = article;
    if (!_article) {
        return;
    }
    UIImage *uploadImage = [article.uploadImageData firstObject];
    self.iconImageView.image = uploadImage;
    NSString *str = [self uploadStatus:article];
    self.titleLabel.text = str;
    //设置进度条
    [self.proressView setPresent:article.uploadProgress];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}


- (void)initSubviews {
    UIImageView *imgeView = [[UIImageView alloc] init];
    imgeView.image = [UIImage imageNamed:@""];
    imgeView.backgroundColor = HEXCOLOR(0xf7f7f7);
    self.iconImageView = imgeView;
    [self.contentView addSubview:imgeView];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:kFontMedium size:12];
    label.text = @"等待合成，请稍候(0%)";
    self.titleLabel = label;
    [self.contentView addSubview:label];
    
    
    UIButton *reuploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reuploadBtn setImage:[UIImage imageNamed:@"icon_upload_reload"] forState:UIControlStateNormal];
    [reuploadBtn setImage:[UIImage imageNamed:@"icon_upload_reload"] forState:UIControlStateHighlighted];
    [reuploadBtn addTarget:self action:@selector(reuploadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.reuploadButton = reuploadBtn;
    [self.contentView addSubview:reuploadBtn];
    self.reuploadButton.hidden = YES;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"icon_upload_cancel"] forState:UIControlStateNormal];
    [cancelBtn setImage:[UIImage imageNamed:@"icon_upload_cancel"] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton = cancelBtn;
    [self.contentView addSubview:cancelBtn];
    self.cancelButton.hidden = YES;
    
    JHProgressView *proressV = [[JHProgressView alloc] init];
    proressV.maxValue = 100;
    proressV.bgImgeView.backgroundColor = HEXCOLOR(0xf8f8f8);
    proressV.leftImgView.backgroundColor = [UIColor colorWithRed:254/255.0 green:225/255.0 blue:0/255.0 alpha:1.0];
    self.proressView = proressV;
    [self.contentView addSubview:proressV];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@9);
        make.width.height.equalTo(@30);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(8);
        make.height.equalTo(@17);
        make.centerY.equalTo(self.iconImageView.mas_centerY).with.offset(0);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-14));
        make.height.equalTo(self.contentView.mas_height).offset(-2);
        make.width.equalTo(@15);
        make.centerY.equalTo(self.iconImageView.mas_centerY).with.offset(0);
    }];
    
    [self.reuploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cancelButton.mas_left).with.offset(-20);
        make.height.equalTo(self.cancelButton.mas_height);
        make.width.equalTo(@15);
        make.centerY.equalTo(self.iconImageView.mas_centerY).with.offset(0);
    }];
    
    [self.proressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.width.equalTo(self);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.height.equalTo(@2);
    }];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

///重新上传
- (void)reuploadButtonClick:(UIButton*)sender {
    if ([self.delegate respondsToSelector:@selector(reUpload:)]) {
        [self.delegate reUpload:self.indexPath];
    }
}

///取消上传
- (void)cancelButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cancelUpload:)]) {
        [self.delegate cancelUpload:self.indexPath];
    }
}

- (void)setIsShowReload:(BOOL)isShowReload {
    _cancelButton.hidden = !isShowReload;
    _reuploadButton.hidden = !isShowReload;
}

- (NSString *)uploadStatus:(JHArticleItemModel *)article {
    JHArticleUploadStatus status = article.uploadStatus;
    switch (status) {
        case JHArticleUploadStatusSuccess:
            return @"发布成功（100%）";
            break;
        case JHArticleUploadStatusInterrupt:
            return @"发送中断";
            break;
        case JHArticleUploadStatusUploading:
            return [NSString stringWithFormat:@"正在合成，请勿离开天天鉴宝(%d%%)", article.uploadProgress];
            break;
        case JHArticleUploadStatusWaitUpload:
            return @"等待合成，请稍候(0%)";
            break;
        default:
            return @"等待合成，请稍候(0%)";
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
