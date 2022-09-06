//
//  JHHotSearchCell.m
//  TTjianbao
//
//  Created by liuhai on 2021/10/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHHotSearchCell.h"
#import "CSearchKeyModel.h"
#import "JHHotWordModel.h"
#import "JHSearchRecommendModel.h"
#define button_MARGIN 10.0f
#define BOTTOM_MARGIN 15.0f
#define HORIZONTAL_PADDING 30.0f

@interface JHHotSearchCell ()

@property (nonatomic, strong) NSMutableArray *hotTagArray;
@property (nonatomic, assign) SearchWordsType searchWordsType;
@property (nonatomic, assign) BOOL isExpand;//是否展开
@property (nonatomic, strong) UIButton * lastBtn;
@end

@implementation JHHotSearchCell

@synthesize view, textArray;
- (void)dealloc{
    NSLog(@"dealloc_MSHotSearchCell");
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withArr:(NSMutableArray *_Nullable)arr withHotTagArr:(NSMutableArray *_Nullable)hotTagArr andSearchType:(SearchWordsType)type andisexpandL:(BOOL)isexpand{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = NO;
        self.isExpand = isexpand;
        textArray = arr;
        self.hotTagArray = hotTagArr;
        self.searchWordsType = type;
        if (self.searchWordsType == SearchWordsTypeHot) {
            [self hotdisplay];
        }else{
            [self display];
        }
        
    }
    return self;
}

- (void)setTags:(NSArray *)array
{
    textArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    [self display];
}

- (void)display
{
    self.backgroundColor = [UIColor clearColor];
    
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    NSInteger lines = 1;

    for (int i = 0; i < textArray.count; i ++) {

        NSString *text = ((CSearchKeyData*)textArray[i]).keyword;
        CGSize textSize = [self sizeWithText:text];
        if (textSize.width > kScreenWidth - 60) {
            textSize.width = kScreenWidth - 60;
        }
        textSize.width += HORIZONTAL_PADDING;
        
        textSize.height = 28;
        
        UIButton *button = nil;
        
        if (!gotPreviousFrame) {
            button = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, textSize.width, textSize.height)];
            totalHeight = textSize.height;
        } else {
            CGRect newRect = CGRectZero;
                
                if (previousFrame.origin.x + previousFrame.size.width + textSize.width + button_MARGIN > ScreenW - 30) {
                    lines++ ;
                    if (lines>2 && !self.isExpand) {
                        CGFloat expandX = 0;
                        if (_lastBtn.right + button_MARGIN + 20 + 28 <= ScreenW) {
                              expandX = previousFrame.origin.x + previousFrame.size.width + button_MARGIN;
                        }else{
                            if (_lastBtn.width > 150) {
                                _lastBtn.width = _lastBtn.width - button_MARGIN - 28;
                                expandX = _lastBtn.right + button_MARGIN;
                            }else{
                                expandX = _lastBtn.left;
                                [_lastBtn removeFromSuperview];
                            }
                        }
                        
                        UIButton * expandbutton = [[UIButton alloc] initWithFrame:CGRectMake(expandX, previousFrame.origin.y, 28, 28)];
                        [expandbutton setImage:[UIImage imageNamed:@"customize_icon_anchor_arrow_down"] forState:UIControlStateNormal];
                        expandbutton.backgroundColor = HEXCOLOR(0xF8F8F8);
                        expandbutton.layer.masksToBounds = YES;
                        expandbutton.layer.cornerRadius = 14.0f;
                        [expandbutton addTarget:self action:@selector(expandbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
                        [self addSubview:expandbutton];
                        break;
                    }
                    
                    newRect.origin = CGPointMake(20, previousFrame.origin.y + textSize.height + BOTTOM_MARGIN);
                    totalHeight += textSize.height + BOTTOM_MARGIN;
                    
                    
                    
                } else {
                    newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + button_MARGIN, previousFrame.origin.y);
                }
            
            newRect.size = textSize;
            button = [[UIButton alloc] initWithFrame:newRect];
        }
        previousFrame = button.frame;
        gotPreviousFrame = YES;
        button.backgroundColor = HEXCOLOR(0xF8F8F8);
        button.titleLabel.font = JHFont(13);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 14.0f;
        [button setTitleColor:HEXCOLOR(0x333333) forState:(UIControlStateNormal)];
        [self.contentView addSubview:button];

        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [button setTitle:text forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(clickCellButton:) forControlEvents:(UIControlEventTouchUpInside)];
        button.tag = i;
        
        self.lastBtn = button;
    }
   
    sizeFit = CGSizeMake(ScreenW, totalHeight + 5.0f);
//    self.line = [[UILabel alloc]initWithFrame:CGRectMake(0, sizeFit.height-kLinePixel, kUIScreenWidth, kLinePixel)];
//    [self addSubview:self.line];
//    self.line.backgroundColor = kLineColor;
    
}

- (void)hotdisplay
{
    self.backgroundColor = [UIColor clearColor];
    
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;

    for (int i = 0; i < self.hotTagArray.count; i ++) {

        JHSearchRecommendKeyWordModel *hotModel = self.hotTagArray[i];
        NSString *text = hotModel.name;
        CGSize textSize = [self sizeWithText:text];
        if (textSize.width > kScreenWidth - 60) {
            textSize.width = kScreenWidth - 60;
        }
        textSize.width += HORIZONTAL_PADDING;
        //如果展示热门标签
        
        textSize.height = 28;
        
        UIButton *button = nil;
        
        if (!gotPreviousFrame) {
            button = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, textSize.width, textSize.height)];
            
            totalHeight = textSize.height;
        } else {
            CGRect newRect = CGRectZero;

            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + button_MARGIN > ScreenW-30) {
                newRect.origin = CGPointMake(20, previousFrame.origin.y + textSize.height + BOTTOM_MARGIN);
                totalHeight += textSize.height + BOTTOM_MARGIN;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + button_MARGIN, previousFrame.origin.y);
            }
            newRect.size = textSize;
            button = [[UIButton alloc] initWithFrame:newRect];
        }
        previousFrame = button.frame;
        gotPreviousFrame = YES;
        button.backgroundColor = HEXCOLOR(0xF8F8F8);
        button.titleLabel.font = JHFont(13);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 14.0f;
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [button setTitleColor:HEXCOLOR(0x333333) forState:(UIControlStateNormal)];
        [self.contentView addSubview:button];
        //添加热门标签

        
        [button setTitle:text forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(clickCellButton:) forControlEvents:(UIControlEventTouchUpInside)];
        button.tag = i;
        
//        //添加热门标签
        if ([hotModel.isShow integerValue] == 1) {

            UIImageView * tagImage = [[UIImageView alloc] init];
            tagImage.contentMode = UIViewContentModeScaleAspectFit;
            tagImage.clipsToBounds = YES;
            [self.contentView addSubview:tagImage];
            
//            [tagImage jh_setImageWithUrl:hotModel.icon];
            [tagImage jhSetImageWithURL:[NSURL URLWithString:hotModel.icon] placeholder:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                            
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
                if (image && image.size.height>0 ) {
                    float imagew = image.size.width/image.size.height*12;
                    [tagImage mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(button.mas_right).offset(5);
                        make.bottom.mas_equalTo(button.mas_top).offset(6);
                        make.size.mas_equalTo(CGSizeMake(imagew, 12));
                    }];
                }
                
            }];
            
        }
        
    }
   
    sizeFit = CGSizeMake(ScreenW, totalHeight + 5.0f);
    
}


-(void)expandbuttonAction:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(expandBtnAction)]) {
        [_delegate expandBtnAction];
    }
}
- (CGSize)fittedSize
{
    return sizeFit;
}
- (CGSize)sizeWithText:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
}
- (void)clickCellButton:(UIButton*)sender{
    if (self.searchWordsType == SearchWordsTypeHistory) {
        if ([_delegate respondsToSelector:@selector(clickHotLabelChangeValue:searchWordsType:andindex:)]) {
            [_delegate clickHotLabelChangeValue:((CSearchKeyData*)textArray[sender.tag]).keyword searchWordsType:self.searchWordsType andindex:sender.tag];
        }
    }else{
        [_delegate clickHotLabelChangeValue:@"" searchWordsType:self.searchWordsType andindex:sender.tag];
        
    }
    
}

-(void)lpGR:(UILongPressGestureRecognizer *)lpGR

{
    if (self.indexpath.section == 1) {
        
        UIButton * btn = (UIButton*)lpGR.view;
        UIButton * closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closebtn.frame = CGRectMake(btn.right - 10, btn.top - 10, 20, 20);
        [closebtn setBackgroundImage:[UIImage imageNamed:@"close_searchHot"] forState:UIControlStateNormal];
        [closebtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        closebtn.tag = btn.tag-101;
        [self addSubview:closebtn];
    }
    
    
}
- (void)closeAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteHotKey:)]) {
        [self.delegate deleteHotKey:sender.tag];
        [sender removeFromSuperview];
    }
}
@end
