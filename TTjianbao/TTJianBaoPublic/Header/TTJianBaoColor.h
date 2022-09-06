//
//  TTJianBaoColor.h
//  TTjianbao
//
//  Created by YJ on 2020/12/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#ifndef TTJianBaoColor_h
#define TTJianBaoColor_h

#import "UIColor+ColorChange.h"

///***********颜色设置************/
#define COLOR_CHANGE(string)             [UIColor colorWithHexString:string]

/* 黄色 */
#define YELLOW_COLOR                     COLOR_CHANGE(@"#FFD70F")

/* 黑色 */
#define BLACK_COLOR                      COLOR_CHANGE(@"#222222")

/* 浅灰色 */
#define LIGHTGRAY_COLOR                  COLOR_CHANGE(@"#999999")

/* 灰色 */
#define GRAY_COLOR                       COLOR_CHANGE(@"#666666")

/* 浅浅灰色--分割线颜色 */
#define MLIGHTGRAY_COLOR                 COLOR_CHANGE(@"#D8D8D8")

/* 浅灰色--vc背景颜色 */
#define BACKGROUND_COLOR                 COLOR_CHANGE(@"#F5F5F8")

/* 浅灰色--筛按钮选背景颜色--选中 */
#define SELECTED_COLOR                   COLOR_CHANGE(@"#FCEC9D")

/* 浅灰色--筛按钮选背景颜色--未选中*/
#define USELECTED_COLOR                  COLOR_CHANGE(@"#F5F5F5")

/* 分类标签 */
#define CHANNER_COLOR                    COLOR_CHANGE(@"#ffffff")

/* 筛选确定按钮背景色 */
#define SURE_BACK_COLOR                  COLOR_CHANGE(@"#FECB33")

#define B_COLOR                          COLOR_CHANGE(@"#333333")
#define LINE_COLOR                       COLOR_CHANGE(@"#EEEEEE")
/* 时间 */
#define TIMEBG_COLOR                     COLOR_CHANGE(@"#E1E1E1")

#define BGVIEW_COLOR                     COLOR_CHANGE(@"#F5F6FA")

#endif /* TTJianBaoColor_h */
