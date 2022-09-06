//
//  PageBaseView.h
//  AutographAlbum
//
//  Created by jiangchao on 2016/11/22.
//  Copyright © 2016年 jiangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewIn.h"
@interface PageBaseView : UIView<UIScrollViewDelegate,PageViewIn>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) NSInteger currentPage; /**<  页码   **/
@property (strong, nonatomic) UIScrollView *topTab; /**<  顶部tab   **/
@property (strong, nonatomic) NSArray *titleArray; /**<  标题   **/

- (instancetype)initWithFrame:(CGRect)frame WithSelectColor:(UIColor *)selectColor WithUnselectorColor:(UIColor *)unselectColor WithUnderLineColor:(UIColor *)underlineColor WithTopColur:(UIColor*)topColor;
@end
