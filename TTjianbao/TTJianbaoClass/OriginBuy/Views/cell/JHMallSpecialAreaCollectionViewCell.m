//
//  JHMallSpecialAreaCollectionViewCell.m
//  TTjianbao
//
//  Created by jiang on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallSpecialAreaCollectionViewCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoHeader.h"
#import <SVGAParser.h>

@interface JHMallSpecialAreaCollectionViewCell()

@property (nonatomic, strong) UILabel *titleLabel;          ///标题
@property (nonatomic, strong) UILabel *descLabel;           ///描述
@property (nonatomic, strong) YYAnimatedImageView *coverImageView;

@end

@implementation JHMallSpecialAreaCollectionViewCell

-(void)setSpecialAreaMode:(JHOperationImageModel *)specialAreaMode{
    
    _specialAreaMode=specialAreaMode;
    if(_specialAreaMode.imageUrl && ([_specialAreaMode.imageUrl containsString:@"svga"] || [_specialAreaMode.imageUrl containsString:@"SVGA"]))
    {
        SVGAParser *parser = [[SVGAParser alloc] init];
        [parser parseWithURL:[NSURL URLWithString:_specialAreaMode.imageUrl] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            if (videoItem != nil) {
                self.player.videoItem = videoItem;
                [self start];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            NSLog(@"123");
        }];
        _coverImageView.hidden = YES;
        _player.hidden = NO;
    }
    else
    {
        _coverImageView.hidden = NO;
        _player.hidden = YES;
        [_coverImageView setImageWithURL:[NSURL URLWithString:_specialAreaMode.imageUrl] placeholder:nil];
    }
    [self stop];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (!_coverImageView) {
        _coverImageView = [[YYAnimatedImageView alloc] init];
        _coverImageView.image = [UIImage imageNamed:@""];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_coverImageView];
    }
    
  [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _player = [[SVGAPlayer alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:_player];
    _player.backgroundColor = [UIColor clearColor];
    _player.loops = 0;
}

-(void)start
{
    [self.player startAnimation];
}

- (void)stop
{
    [self.player stopAnimation];
}

@end
