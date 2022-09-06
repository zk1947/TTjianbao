//
//  JHCustomizeFlyOrderTagsView.m
//  TTjianbao
//
//  Created by lihang on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeFlyOrderTagsView.h"


@implementation JHCustomizeFlyOrderTagsView {
    NSArray *disposeAry;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
        self.frame = frame;
        _tagSpace = 10.0;
        _tagHeight = 20;
        _tagOriginX = 10.0;
        _tagOriginY = 10.0;
        _tagHorizontalSpace = 20.0;
        _tagVerticalSpace = 7.5;
        _borderColor = [UIColor colorWithRed:144/255.0f green:144/255.0f blue:144/255.0f alpha:1];
        _borderWidth = 1.0f;
        _masksToBounds = YES;
        _cornerRadius = 5;
        _titleSize = 11;
        _titleColor = [UIColor colorWithRed:144/255.0f green:144/255.0f blue:144/255.0f alpha:1];
        _normalBackgroundImage = [self imageWithColor:[UIColor clearColor] size:CGSizeMake(1.0, 1.0)];
    }
    return self;
}

//设置标签数据和代理
- (void)setTagAry:(NSArray *)tagAry delegate:(id)delegate {
    _tagDelegate = delegate;
    [self disposeTags:tagAry];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //遍历标签数组,将标签显示在界面上,并给每个标签打上tag加以区分
    for (NSArray *iTags in disposeAry) {
        NSUInteger i = [disposeAry indexOfObject:iTags];
        
        for (NSDictionary *tagDic in iTags) {
            NSUInteger j = [iTags indexOfObject:tagDic];
            
            NSString *tagTitle = tagDic[@"tagTitle"];
            float originX = [tagDic[@"originX"] floatValue];
            float buttonWith = [tagDic[@"buttonWith"] floatValue];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(originX, _tagOriginY+i*(_tagHeight+_tagVerticalSpace), buttonWith, _tagHeight);
            button.layer.borderColor = _borderColor.CGColor;
            button.layer.borderWidth = _borderWidth;
            button.layer.masksToBounds = _masksToBounds;
            button.layer.cornerRadius = _cornerRadius;
            button.titleLabel.font = [UIFont systemFontOfSize:_titleSize];
            [button setTitle:tagTitle forState:UIControlStateNormal];
            [button setTitleColor:_titleColor forState:UIControlStateNormal];
            [button setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
            [button setBackgroundImage:_normalBackgroundImage forState:UIControlStateNormal];
            [button setBackgroundImage:_selectedBackgroundImage forState:UIControlStateSelected];
            [button setBackgroundImage:_highlightedBackgroundImage forState:UIControlStateHighlighted];
            if (tagDic[@"id"] != nil) {
                NSString* tag = tagDic[@"id"];
                button.tag = tag.intValue;
            }else{
                button.tag = i*iTags.count+j;
            }
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            if(self.canDel){
                UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [delBtn setImage:[UIImage imageNamed:@"customizev_fly_del_count"] forState:UIControlStateNormal];
                [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:delBtn];
                [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(button.mas_right).offset(-3);
                    make.centerY.equalTo(button.mas_top);
                    make.width.height.equalTo(@18);
                }];
                delBtn.tag = button.tag;
            }
        }
    }
    
    if (disposeAry.count > 0) {
        if (_type == 0) {
            //多行
            float contentSizeHeight = _tagOriginY+disposeAry.count*(_tagHeight+_tagVerticalSpace)- _tagVerticalSpace;
            self.contentSize = CGSizeMake(self.frame.size.width,contentSizeHeight);
        } else if (_type == 1) {
            //单行
            NSArray *a = disposeAry[0];
            NSDictionary *tagDic = a[a.count-1];
            float originX = [tagDic[@"originX"] floatValue];
            float buttonWith = [tagDic[@"buttonWith"] floatValue];
            self.contentSize = CGSizeMake(originX+buttonWith+_tagOriginX,self.frame.size.height);
        }
    }
    //多行
    if (self.frame.size.height <= 0) {
        self.frame = CGRectMake(CGRectGetMinX([self frame]), CGRectGetMinY([self frame]), CGRectGetWidth([self frame]), [self getDisposeTagsViewHeight:disposeAry]);
    } else {
        if (_type == 0) {
            if (self.frame.size.height > self.contentSize.height) {
                self.frame = CGRectMake(CGRectGetMinX([self frame]), CGRectGetMinY([self frame]), CGRectGetWidth([self frame]), self.contentSize.height);
            }
        }
    }
}

//将标签数组根据type以及其他参数进行分组装入数组
- (void)disposeTags:(NSArray *)ary {
    if (ary.count == 0) {
        disposeAry = nil;
    }
    __block NSMutableArray *tags = [NSMutableArray new];//纵向数组
    __block NSMutableArray *subTags = [NSMutableArray new];//横向数组
    
    __block float originX = _tagOriginX;
    

    [ary enumerateObjectsUsingBlock:^(id  _Nonnull data, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        NSString* obj = @"";
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dic = data;
            obj = dic[@"title"];
            dict[@"id"] = dic[@"id"];//标签标题
        }else if([data isKindOfClass:[NSString class]]){
            obj = data;
        }
        //计算每个tag的宽度
        NSString * tagTitle = [NSString stringWithFormat:@"%@",obj];
        CGSize contentSize = [tagTitle fdd_sizeWithFont:[UIFont systemFontOfSize:_titleSize] constrainedToSize:CGSizeMake(self.frame.size.width-_tagOriginX*2, MAXFLOAT)];
        
        dict[@"tagTitle"] = tagTitle;//标签标题
        dict[@"buttonWith"] = [NSString stringWithFormat:@"%f",contentSize.width+_tagSpace];//标签的宽度
        
        if (idx == 0) {
            dict[@"originX"] = [NSString stringWithFormat:@"%f",originX];//标签的X坐标
            [subTags addObject:dict];
        } else {
            if (_type == 0) {
                //多行
                if (originX + contentSize.width + _tagSpace > self.frame.size.width-_tagOriginX) {
                    //当前标签的X坐标+当前标签的长度>屏幕的横向总长度则换行
                    [tags addObject:subTags];
                    //换行标签的起点坐标初始化
                    originX = _tagOriginX;
                    dict[@"originX"] = [NSString stringWithFormat:@"%f",originX];//标签的X坐标
                    subTags = [NSMutableArray new];
                    [subTags addObject:dict];
                } else {
                    //如果没有超过屏幕则继续加在前一个数组里
                    dict[@"originX"] = [NSString stringWithFormat:@"%f",originX];//标签的X坐标
                    [subTags addObject:dict];
                }
            } else {
                //一行
                dict[@"originX"] = [NSString stringWithFormat:@"%f",originX];//标签的X坐标
                [subTags addObject:dict];
            }
        }
        
        if (idx +1 == ary.count) {
            //最后一个标签加完将横向数组加到纵向数组中
            [tags addObject:subTags];
            disposeAry = tags;
        }
        
        //标签的X坐标每次都是前一个标签的宽度+标签左右空隙+标签距下个标签的距离
        originX += contentSize.width+_tagHorizontalSpace+_tagSpace;
    }];
}

//获取处理后的tagsView的高度根据标签的数组
- (float)getDisposeTagsViewHeight:(NSArray *)ary {
    
    if (ary.count == disposeAry.count) {
        
    } else {
        [self disposeTags:ary];
    }
    
    float height = 0;
    if (disposeAry.count > 0) {
        if (_type == 0) {
            height = _tagOriginY+disposeAry.count*(_tagHeight+_tagVerticalSpace) - _tagVerticalSpace;
        } else if (_type == 1) {
            height = _tagOriginY+_tagHeight+_tagVerticalSpace;
        }
    }
    return height;
}

- (void)buttonAction:(UIButton *)sender {
    if (_tagDelegate && [_tagDelegate respondsToSelector:@selector(tagsViewButtonAction:button:)]) {
        [_tagDelegate tagsViewButtonAction:self button:sender];
    }
}

- (void)delBtnClick:(UIButton *)sender {
    if (_tagDelegate && [_tagDelegate respondsToSelector:@selector(tagsViewDelButtonAction:button:)]) {
        [_tagDelegate tagsViewDelButtonAction:self button:sender];
    }
}

//颜色生成图片方法
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,
                                   
                                   color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end

#pragma mark - 扩展方法

@implementation NSString (FDDExtention)

- (CGSize)fdd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    CGSize resultSize;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        NSStringDrawingContext *context;
        [invocation setArgument:&size atIndex:2];
        [invocation setArgument:&options atIndex:3];
        [invocation setArgument:&attributes atIndex:4];
        [invocation setArgument:&context atIndex:5];
        [invocation invoke];
        CGRect rect;
        [invocation getReturnValue:&rect];
        resultSize = rect.size;
    } else {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(sizeWithFont:constrainedToSize:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(sizeWithFont:constrainedToSize:)];
        [invocation setArgument:&font atIndex:2];
        [invocation setArgument:&size atIndex:3];
        [invocation invoke];
        [invocation getReturnValue:&resultSize];
    }
    return resultSize;
}

@end

