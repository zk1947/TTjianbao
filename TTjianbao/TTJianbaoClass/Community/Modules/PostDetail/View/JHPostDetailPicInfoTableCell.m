//
//  JHPostDetailPicInfoTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPostDetailPicInfoTableCell.h"
#import "UITapImageView.h"
#import "JHPostDetailModel.h"

#define spaceMargin (15)
#define kPhotoVerSpace  (5.f)   //图片纵向间距
#define kPhotoHorSpace  (5.f)   //图片横向间距

#define MAX_IMAGE_COUNT  9

@interface JHPostDetailPicInfoTableCell ()
@property (nonatomic, strong) NSMutableArray *photoViews;


@end

@implementation JHPostDetailPicInfoTableCell

+ (CGFloat)viewHeight {
    return ceil((ScreenW - spaceMargin*2 - kPhotoHorSpace*2) / 3);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        _photoViews = [NSMutableArray new];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    CGFloat imgWH = [[self class] viewHeight];
    NSMutableArray *views = [NSMutableArray new];
    @weakify(self);
    
    for (NSInteger i = 0; i < MAX_IMAGE_COUNT; i++) {
        NSInteger columnIndex = i % 3;
        NSInteger rowIndex = i / 3;

        UITapImageView *imageView = [UITapImageView new];
        imageView.image = kDefaultCoverImage;
        imageView.top = kPhotoVerSpace + (rowIndex * (imgWH + kPhotoVerSpace));
        imageView.left = spaceMargin + columnIndex * (imgWH + kPhotoHorSpace);
        imageView.size = CGSizeMake(imgWH, imgWH);
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 8;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.exclusiveTouch = YES;
//        imageView.hidden = YES;
        [imageView addTapBlock:^(id  _Nonnull obj) {
            @strongify(self);
            [self didClickedImageAtIndex:i];
        }];
        
        [views addObject:imageView];
        [self.contentView addSubview:imageView];
    }
    
    _photoViews = [views mutableCopy];
}


- (void)didClickedImageAtIndex:(NSInteger)index {
    //NSLog(@"点击图片 %ld", (long)index);
    if (self.clickPhotoBlock) {
        self.clickPhotoBlock(_photoViews, index);
    }
}

- (void)configImages:(NSArray *)imageArray {
    for (NSInteger i = imageArray.count; i < _photoViews.count; i++) {
        UITapImageView *imageView = [_photoViews objectAtIndex:i];
        [imageView.layer cancelCurrentImageRequest];
        imageView.hidden = YES;
    }

    if (!imageArray || imageArray.count == 0) {
        self.height = 0;
        return;
    }

    NSInteger perLineCount = 3; //每行显示几张图
    CGFloat imgWH = [[self class] viewHeight];
    [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger columnIndex = idx % perLineCount;
        NSInteger rowIndex = idx / perLineCount;
        UITapImageView *imageView = [_photoViews objectAtIndex:idx];
        imageView.hidden = NO;
        [imageView.layer removeAnimationForKey:@"contents"];
        imageView.top = kPhotoVerSpace + (rowIndex * (imgWH + kPhotoVerSpace));
        imageView.left = spaceMargin + columnIndex * (imgWH + kPhotoHorSpace);
        imageView.size = CGSizeMake(imgWH, imgWH);
        if ([obj isKindOfClass:[NSString class]]) {
        [imageView jhSetImageWithURL:[NSURL URLWithString:obj]];
        }
        else if ([obj isKindOfClass:[UIImage class]]) {
            imageView.image = obj;
        }
    }];
}

- (void)setPostInfo:(JHPostDetailModel *)postInfo {
    if (!postInfo) {
        return;
    }
    _postInfo = postInfo;
    [self configImages:postInfo.images_thumb];
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
