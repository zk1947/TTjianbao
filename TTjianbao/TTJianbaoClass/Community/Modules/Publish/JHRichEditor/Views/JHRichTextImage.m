//
//  JHRichTextImage.m
//  TTjianbao
//
//  Created by jiangchao on 2020/6/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRichTextImage.h"
#import "UIImageView+JHWebImage.h"
@interface JHRichTextImage()
@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, strong) YYAnimatedImageView *videoIconImage;
@property (nonatomic, strong) UILabel * timeLabel;
@end
@implementation JHRichTextImage
- (instancetype)initWithDataSourece:(id<JHRichTextImageDelegate>)_delegete {
    if (self = [super init]) {
        
        self.delegete = _delegete;
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        
//        YYTextView * desTextView = [YYTextView new];
//                      // desTextView.delegate = self;
//                      desTextView.contentInset = UIEdgeInsetsMake(0, 0, 0,0);
//                      desTextView.text = @"可在此编辑图片描述信息";
//                      desTextView.font = [UIFont systemFontOfSize:12];
//                      desTextView.textAlignment = NSTextAlignmentLeft;
//                      desTextView.textColor = [UIColor grayColor];
//                      desTextView.backgroundColor = [UIColor yellowColor];
//                      desTextView.scrollEnabled = NO;
//                      [self addSubview:desTextView];
//                      [desTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//                          make.bottom.left.right.equalTo(self);
//                          make.height.offset(50);
//                      }];
//               _imageView = [[YYAnimatedImageView alloc] init];
//               _imageView.userInteractionEnabled = YES;
//               _imageView.contentMode = UIViewContentModeScaleToFill;
//               _imageView.clipsToBounds = YES;
//               [self addSubview:_imageView];
//               [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                      make.width.equalTo(self.mas_width);
//                     make.bottom.equalTo(desTextView.mas_top);
//                      make.top.equalTo(self);
//               }];
        
        
        
        _imageView = [[YYAnimatedImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_height);
            make.top.equalTo(self);
            make.centerX.equalTo(self);
        }];
//        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
//        _uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        UIButton * button=[[UIButton  alloc]init];
        [button setBackgroundImage:[UIImage imageNamed:@"rich_image_delete"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
        [_imageView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(_imageView).offset(0);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        
        _videoIconImage = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"sq_rcmd_icon_video"]];
        _videoIconImage.userInteractionEnabled = YES;
        _videoIconImage.contentMode = UIViewContentModeScaleAspectFit;
        _videoIconImage.clipsToBounds = YES;
        [_imageView addSubview:_videoIconImage];
        [_videoIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_imageView);
        }];
        _videoIconImage.hidden=YES;
        
        _timeLabel = [UILabel jh_labelWithFont:12 textColor:UIColor.whiteColor addToSuperView:_imageView];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(34);
            make.left.equalTo(self.imageView).offset(10);
            make.bottom.equalTo(self.imageView);
        }];
        
    }
    return self;
}
-(void)deleteImage{

    [self.delegete remove:self];
    
}
//-(void)setIsVideo:(BOOL)isVideo{
//    
//    _isVideo=isVideo;
//    _videoIconImage.hidden=!_isVideo;
//}
-(void)setAlbumModel:(JHAlbumPickerModel *)albumModel{

    _albumModel=albumModel;
    _videoIconImage.hidden=!_albumModel.isVideo;
    if (_albumModel.isVideo) {
        self.timeLabel.text = [NSString stringWithFormat:@"%d:%.2d",albumModel.videoDuration/60,albumModel.videoDuration%60];
    }
    
}
- (void)setImage:(id)image {
    _image = image;
    if ([image isKindOfClass:[UIImage class]]) {
        _imageView.image = image;
    } else {
        JH_WEAK(self)
        [_imageView jhSetImageWithURL:[NSURL URLWithString:image] placeholder:nil completed:^(UIImage * _Nullable image1, NSError * _Nullable error) {
            JH_STRONG(self)
            if([image1 isKindOfClass:[UIImage class]]) {
                self -> _image = image1;
            }
        }];
    }
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
return NO;
}
@end
