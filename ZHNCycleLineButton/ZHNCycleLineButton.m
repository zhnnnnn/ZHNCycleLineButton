//
//  ZHNCycleLineButton.m
//  ZHNCycleLineButton
//
//  Created by 张辉男 on 17/2/23.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNCycleLineButton.h"

#define KFIRSTSTEPANIMATIONKEY @"kfirstSetpAnimationKey"
#define KSECONDSTEPANIMATIONKEY @"ksectonSetpAnimationKey"
#define KTHIRDSTEPANIMATIONKEY @"kthirdStepAnimationKey"
#define KstrokePercentDelta (self.lineEndPercent - self.lineStartPercent)
@interface ZHNCycleLineButton()<CAAnimationDelegate>
@property (strong,nonatomic) CAShapeLayer *animateLine;
@property (strong,nonatomic) CAShapeLayer *animateLine2;
@property (strong,nonatomic) UILabel *titleLabel;
@property (nonatomic,assign) BOOL isAnimating;
@property (nonatomic,assign) CGFloat surplusRepeatCount;
@end

@implementation ZHNCycleLineButton

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self.layer addSublayer:self.animateLine];
        [self.layer addSublayer:self.animateLine2];
        [self p_juageParams];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 第一条line
    self.animateLine.strokeStart = self.lineStartPercent;
    self.animateLine.strokeEnd = self.lineEndPercent;
    self.animateLine.frame = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.animateLine.path = path.CGPath;
    // 第二条line
    self.animateLine2.frame = self.bounds;
    self.animateLine2.path = path.CGPath;
    // 标题
    self.titleLabel.frame = self.bounds;
    // 手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapButton)];
    [self addGestureRecognizer:tap];
}

- (void)tapButton {
    if(self.isAnimating) return;
    self.isAnimating = true;
    self.surplusRepeatCount = self.lineAnimateRepeatCount;
    if (self.clickAction) {
        self.clickAction();
    }
    [self p_firstSetpAnimation];
}
#pragma mark - public methods
+ (instancetype)CycleLinebuttonWithTitle:(NSString *)title tapAction:(clickActionBlock)action {
    ZHNCycleLineButton *button = [[ZHNCycleLineButton alloc]init];
    button.buttonTitle = title;
    button.clickAction = action;
    return button;
}

#pragma mark - pravite methods
- (void)p_firstSetpAnimation {
    
    CGFloat duration = (1 - self.lineEndPercent) * self.lineAnimateduration;
    CAKeyframeAnimation *strokeStartAnimate = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimate.values = @[@(self.lineStartPercent),@(self.lineStartPercent + (1-self.lineEndPercent))];
    strokeStartAnimate.repeatCount = 1;
    strokeStartAnimate.duration = duration;
    strokeStartAnimate.removedOnCompletion = NO;
    strokeStartAnimate.fillMode = kCAFillModeForwards;
    strokeStartAnimate.delegate = self;
    [self.animateLine addAnimation:strokeStartAnimate forKey:KFIRSTSTEPANIMATIONKEY];
    
    CAKeyframeAnimation *strokeEndAimate = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAimate.values = @[@(self.lineEndPercent),@(1)];
    strokeEndAimate.repeatCount = 1;
    strokeEndAimate.duration = duration;
    strokeEndAimate.removedOnCompletion = NO;
    strokeEndAimate.fillMode = kCAFillModeForwards;
    strokeEndAimate.delegate = self;
    [self.animateLine addAnimation:strokeEndAimate forKey:nil];
}

- (void)p_secondSetpAnimation {
    
    CGFloat duration = KstrokePercentDelta * self.lineAnimateduration;
    CAKeyframeAnimation *strokeStartAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.values = @[@(self.lineStartPercent + (1-self.lineEndPercent)),@(1)];
    strokeStartAnimation.repeatCount = 1;
    strokeStartAnimation.duration = duration;
    strokeStartAnimation.removedOnCompletion = NO;
    strokeStartAnimation.fillMode = kCAFillModeForwards;
    strokeStartAnimation.delegate = self;
    [self.animateLine addAnimation:strokeStartAnimation forKey:KSECONDSTEPANIMATIONKEY];
    
    CAKeyframeAnimation *line2strokeEndAimate = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    line2strokeEndAimate.values = @[@(0),@(KstrokePercentDelta)];
    line2strokeEndAimate.repeatCount = 1;
    line2strokeEndAimate.duration = duration;
    line2strokeEndAimate.removedOnCompletion = NO;
    line2strokeEndAimate.fillMode = kCAFillModeForwards;
    line2strokeEndAimate.delegate = self;
    [self.animateLine2 addAnimation:line2strokeEndAimate forKey:nil];
}

- (void)p_thirdStepAnimation {
    CGFloat duration = self.lineStartPercent * self.lineAnimateduration;
    CAKeyframeAnimation *strokeStartAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.values = @[@(0),@(self.lineStartPercent)];
    strokeStartAnimation.repeatCount = 1;
    strokeStartAnimation.duration = duration;
    strokeStartAnimation.removedOnCompletion = NO;
    strokeStartAnimation.fillMode = kCAFillModeForwards;
    strokeStartAnimation.delegate = self;
    [self.animateLine2 addAnimation:strokeStartAnimation forKey:KTHIRDSTEPANIMATIONKEY];
    
    CAKeyframeAnimation *strokeEndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.values = @[@(KstrokePercentDelta),@(self.lineEndPercent)];
    strokeEndAnimation.repeatCount = 1;
    strokeEndAnimation.duration = duration;
    strokeEndAnimation.removedOnCompletion = NO;
    strokeEndAnimation.fillMode = kCAFillModeForwards;
    strokeEndAnimation.delegate = self;
    [self.animateLine2 addAnimation:strokeEndAnimation forKey:nil];
}

- (void)p_juageParams {
    NSAssert(self.lineStartPercent>=0&&self.lineStartPercent<=1, @"lineStartPercent取值范围0~1");
    NSAssert(self.lineEndPercent>=0&&self.lineEndPercent<=1, @"lineEndPercent取值范围0~1");
    NSAssert(self.lineStartPercent<=self.lineEndPercent, @"lineEndPercent必须比lineStartPercent大");
    NSAssert(self.lineAnimateduration >= 0, @"动画的时长duration需要大于0");
    NSAssert(self.lineAnimateRepeatCount >= 0 , @"动画执行次数需要大于0");
    self.lineStartPercent = self.lineStartPercent > 0 ? self.lineStartPercent : 0.15;
    self.lineEndPercent = self.lineEndPercent > 0 ? self.lineEndPercent : 0.6;
    self.lineAnimateduration = self.lineAnimateduration > 0 ? self.lineAnimateduration : 1;
    self.lineAnimateRepeatCount = self.lineAnimateRepeatCount > 0 ? self.lineAnimateRepeatCount : 1;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([anim isEqual:[self.animateLine animationForKey:KFIRSTSTEPANIMATIONKEY]]) {
        [self p_secondSetpAnimation];
    }
    
    if ([anim isEqual:[self.animateLine animationForKey:KSECONDSTEPANIMATIONKEY]]) {
        [self p_thirdStepAnimation];
    }
    
    if ([anim isEqual:[self.animateLine2 animationForKey:KTHIRDSTEPANIMATIONKEY]]) {
        [self.animateLine removeAllAnimations];
        [self.animateLine2 removeAllAnimations];
        self.animateLine.strokeStart = self.lineStartPercent;
        self.animateLine.strokeEnd = self.lineEndPercent;
        self.animateLine2.strokeStart = 0;
        self.animateLine2.strokeEnd = 0;
        self.surplusRepeatCount -= 1;
        if(self.surplusRepeatCount == 0) {
            self.isAnimating = false;
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self p_firstSetpAnimation];
            });
        }
    }
}

#pragma mark - setter getter
- (CAShapeLayer *)animateLine {
    if (_animateLine == nil) {
        _animateLine = [CAShapeLayer layer];
        _animateLine.lineWidth = 2;
        _animateLine.strokeColor = [UIColor redColor].CGColor;
        _animateLine.fillColor = [UIColor clearColor].CGColor;
    }
    return _animateLine;
}

- (CAShapeLayer *)animateLine2 {
    if (_animateLine2 == nil) {
        _animateLine2 = [CAShapeLayer layer];
        _animateLine2.lineWidth = 2;
        _animateLine2.strokeColor = [UIColor redColor].CGColor;
        _animateLine2.fillColor = [UIColor clearColor].CGColor;
        _animateLine2.strokeStart = 0;
        _animateLine2.strokeEnd = 0;
    }
    return _animateLine2;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"zhnnnnn";
        _titleLabel.textColor = [UIColor redColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:20];
    }
    return _titleLabel;
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;
    self.titleLabel.text = buttonTitle;
}

- (void)setButtonTitleFont:(CGFloat)buttonTitleFont {
    _buttonTitleFont = buttonTitleFont;
    self.titleLabel.font = [UIFont systemFontOfSize:buttonTitleFont];
}

- (void)setButtonTitleColor:(UIColor *)buttonTitleColor {
    _buttonTitleColor = buttonTitleColor;
    self.titleLabel.textColor = buttonTitleColor;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.animateLine.strokeColor = lineColor.CGColor;
    self.animateLine2.strokeColor = lineColor.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.animateLine.lineWidth = lineWidth;
    self.animateLine2.lineWidth = lineWidth;
}

@end
