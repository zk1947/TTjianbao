//
//  JHSQPublishSelectPlateTopicView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/11/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQPublishSelectPlateTopicView.h"
#import "JHPublishTopicDetailModel.h"
#import "JHGrowingIO.h"

static const CGFloat labelRightMagin = 32.f;

@interface JHSQPublishBottomLabel : UIView

///版块，话题 图标
@property (nonatomic, weak) UIImageView *tipIcon;

/// 删除按钮
@property (nonatomic, weak) UIButton *deleteButton;

/// 版块、话题名字
@property (nonatomic, weak) UILabel *label;

@property (nonatomic, copy) dispatch_block_t deleteBlock;

@end

@implementation JHSQPublishBottomLabel

- (void)jh_updateLabelLayouts:(CGFloat)buttonWidth {
    _deleteButton.hidden = (buttonWidth <= 0);
    [_deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(buttonWidth, 12));
    }];
    CGFloat rightSpace = buttonWidth > 0 ? labelRightMagin : 5;
    [_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 26, 0, rightSpace));
    }];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self jh_cornerRadius:12];
        
        [self addUI];
    }
    return self;
}

-(void)addUI
{
//   UIView *bgView = [UIView jh_viewWithColor:(type == 1 ? RGB(255, 250, 215) : RGB(238, 243, 250)) addToSuperview:self];
    _tipIcon = [UIImageView jh_imageViewWithImage:JHImageNamed(@"publish_plate_icon") addToSuperview:self];
    [_tipIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    _deleteButton = [UIButton jh_buttonWithImage:JHImageNamed(@"publish_tips_delete") target:self action:@selector(deleteAction) addToSuperView:self];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    _label = [UILabel jh_labelWithFont:13 textColor:RGB(254, 145, 0) textAlignment:1 addToSuperView:self];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 26, 0, labelRightMagin));
    }];
}

-(void)deleteAction
{
    if(_deleteBlock)
    {
        _deleteBlock();
    }
}

@end

@interface JHSQPublishSelectPlateTopicView ()

@property (nonatomic, weak) JHSQPublishBottomLabel *plateView;

@property (nonatomic, strong) NSMutableArray <JHSQPublishBottomLabel *> *topicViewArray;
//添加图片视频按钮

@end

@implementation JHSQPublishSelectPlateTopicView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSelfSubViews];
    }
    return self;
}

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    CGFloat buttonWidth = isEdit ? 0 : 12;
    [_plateView jh_updateLabelLayouts:buttonWidth];
}

- (void)addSelfSubViews {
    ///线
    [[UIView jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:self] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    ///线
    UIView *lineView = [UIView jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:self];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.equalTo(self).offset(48);
    }];
    
    JHSQPublishBottomLabel *topicView = [JHSQPublishBottomLabel jh_viewWithColor:UIColor.clearColor addToSuperview:self];
    topicView.label.text = @"请选择话题";
    topicView.tipIcon.image = JHImageNamed(@"publish_selected_topic_img");
    topicView.label.textColor = RGB515151;
    topicView.deleteButton.jh_imageName(@"publish_tips_push");
    [topicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(24);
        make.bottom.equalTo(lineView).offset(-12);
    }];
    @weakify(self);
    [topicView jh_addTapGesture:^{
        @strongify(self);
        [self addTipsAction];
    }];
    
    _plateView = [JHSQPublishBottomLabel jh_viewWithColor:UIColor.clearColor addToSuperview:self];
    _plateView.label.text = @"请选择版块";
    _plateView.label.textColor = RGB515151;
    _plateView.deleteButton.jh_imageName(@"publish_tips_push");
    [_plateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(topicView);
        make.top.equalTo(lineView).offset(12);
    }];
    [_plateView jh_addTapGesture:^{
        @strongify(self);
        if(self.addCatePlateBlock){
            self.addCatePlateBlock();
        }
    }];
    _plateView.deleteBlock = ^{
        @strongify(self);
        if(self.deletePlateBlock)
        {
            self.deletePlateBlock();
        }
    };
     
    UIScrollView *scrollView = [UIScrollView jh_scrollViewWithContentSize:CGSizeZero showsScrollIndicator:NO scrollsToTop:NO bounces:YES pagingEnabled:NO addToSuperView:self];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(150);
        make.top.right.equalTo(self);
        make.bottom.equalTo(lineView);
    }];

    _topicViewArray = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < 3; i++)
    {
        JHSQPublishBottomLabel *m = [JHSQPublishBottomLabel jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:scrollView];
        m.label.textColor = RGB(64, 143, 254);
        m.tipIcon.image = JHImageNamed(@"publish_selected_topic_img");
        m.deleteButton.jh_imageName(@"publish_tips_delete");
        m.deleteBlock = ^{
            @strongify(self);
            if(self.deleteTopicBlock)
            {
                self.deleteTopicBlock(i);
            }
        };
        [_topicViewArray addObject:m];
    }

    JHSQPublishBottomLabel *label1 = _topicViewArray[0];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(topicView);
        make.left.equalTo(scrollView);
    }];

    JHSQPublishBottomLabel *label2 = _topicViewArray[1];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(topicView);
        make.left.equalTo(label1.mas_right).offset(5);
    }];

    JHSQPublishBottomLabel *label3 = _topicViewArray[2];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(topicView);
        make.left.equalTo(label2.mas_right).offset(5);
        make.right.equalTo(scrollView).offset(-15);
    }];
}

/// 板块赋值
- (void)setPlateName:(NSString *)plateName{
    
    _plateName = plateName;
    if(_plateName && _plateName.length > 0){
        
        _plateView.backgroundColor = RGB(255, 250, 215);
        _plateView.label.text = plateName;
        _plateView.label.textColor = RGB(254, 145, 0);
        _plateView.deleteButton.jh_imageName(@"publish_tips_delete");
        _plateView.backgroundColor = APP_BACKGROUND_COLOR;
    }
    else{
        _plateView.backgroundColor = APP_BACKGROUND_COLOR;
        _plateView.label.text = @"请选择版块";
        _plateView.label.textColor = RGB515151;
        _plateView.deleteButton.jh_imageName(@"publish_tips_push");
        _plateView.backgroundColor = UIColor.clearColor;
    }
}

/// 话题赋值
- (void)setTopicArray:(NSArray<JHPublishTopicDetailModel *> *)topicArray {
    _topicArray = topicArray;
    if(!_topicArray || !IS_ARRAY(_topicArray)) {
        _topicArray = @[];
    }
    for (int i = 0; i < _topicViewArray.count; i++)
    {
        JHSQPublishBottomLabel *m = SAFE_OBJECTATINDEX(_topicViewArray, i);
        m.hidden = (i >= _topicArray.count);
        JHPublishTopicDetailModel *model = SAFE_OBJECTATINDEX(_topicArray, i);
        if(i < _topicArray.count && model)
        {
            m.label.text = model.title;
        }
    }
}

/// 话题
- (void)addTipsAction{
    
    [JHGrowingIO trackEventId:JHSQPublishSeleteTopicClick];
    if(_addTopicBlock)
    {
        _addTopicBlock();
    }
}

/// 整体高度
+ (CGFloat)viewHeight
{
    return 97.0;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
