//
//  ZHNCycleLineButton.h
//  ZHNCycleLineButton
//
//  Created by 张辉男 on 17/2/23.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickActionBlock)();
@interface ZHNCycleLineButton: UIView

/*boder边框从(0,0)开始顺时针计算一整圈是0-1*/

/**
 边框boder线结束的百分比 (取值0-1,默认0.6)
 */
@property (nonatomic,assign) CGFloat lineEndPercent;

/**
 边框boder线开始的百分比 (取值0-1,并且start <= end,默认0.15)
 */
@property (nonatomic,assign) CGFloat lineStartPercent;

/**
 边框boder每一圈动画的时长 (默认1秒)
 */
@property (nonatomic,assign) CGFloat lineAnimateduration;

/**
 边框boder动画的循环次数 (默认1次)
 */
@property (nonatomic,assign) CGFloat lineAnimateRepeatCount;

/**
 边框boder的颜色 (默认红色)
 */
@property (strong,nonatomic) UIColor *lineColor;

/**
 边框线的宽度 (默认2)
 */
@property (nonatomic,assign) CGFloat lineWidth;

/**
 标题文字的颜色 (默认红色)
 */
@property (strong,nonatomic) UIColor *buttonTitleColor;

/**
 标题文字的字体大小 (默认20)
 */
@property (nonatomic,assign) CGFloat buttonTitleFont;

/**
 标题的文字
 */
@property (nonatomic,copy) NSString *buttonTitle;

/**
 点击事件blcok回调
 */
@property (nonatomic,copy) clickActionBlock clickAction;


/**
 初始化方法
 
 @param title 标题文字
 @param action 点击的动作
 @return ddbutton
 */
+ (instancetype)CycleLinebuttonWithTitle:(NSString *)title tapAction:(clickActionBlock)action;
@end
