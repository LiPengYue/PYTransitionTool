//
//  AnimatedTransition.m
//  PYTransitionAnimation
//
//  Created by 李鹏跃 on 17/3/13.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "AnimatedTransition.h"

@interface AnimatedTransition ()
@property (nonatomic,strong) id <UIViewControllerContextTransitioning> transitionContext;
//动画时长
@property (nonatomic,assign) CGFloat animaDuration;

//MARK: ---------------------- dismiss & present ------------------------
/**dismiss动画*/
@property (nonatomic,copy) void(^dismissAnimaBlock)(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView);

/**present动画*/
@property (nonatomic,copy) void(^presentAnimaBlock)(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView);

/**containerView*/
@property (nonatomic,copy) void(^setupContainerViewBlock)(UIView *containerView);

/**告诉系统停止动画*/
@property (nonatomic,copy) void(^completeTransitionBlock)(BOOL isompleteTransition);
@end

@implementation AnimatedTransition

//MARK -------------------- setter 方法 ----------------------------------
- (void)setIsAccomplishAnima:(BOOL)isAccomplishAnima {
    _isAccomplishAnima = isAccomplishAnima;
    if (isAccomplishAnima) {
        //执行完成动画
        [self.transitionContext completeTransition:isAccomplishAnima];
    }
}

//MAKR: --------------- dismiss & present 方法实现 ------------------
- (void)presentAnimaWithBlock:(void (^)(UIViewController *, UIViewController *, UIView *, UIView *))presentAnimaBlock {
    self.presentAnimaBlock = presentAnimaBlock;
}

- (void)dismissAnimaWithBlock:(void (^)(UIViewController *, UIViewController *, UIView *, UIView *))dismissAnimaBlock {
    self.dismissAnimaBlock = dismissAnimaBlock;
}

//MARK: ---------------------- setupContainerView ------------------------
- (void)setupContainerViewWithBlock: (void(^)(UIView *containerView))setupContainerViewBlock{
    self.setupContainerViewBlock = setupContainerViewBlock;
}


#pragma mark - 动画核心方法
//MARK: 返回一个动画时长，这个时长尽量要与实际动画时长一直，因为系统会以此来作为转场参考时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    //0 是present 1是dismiss
    self.animaDuration = self.animatedTransitionType? self.dismissDuration : self.presentDuration;
    return self.animaDuration;
}

//MARK: 提供了transitionContext，里面能拿到fromeVC与toVC，以及对应的View
//注意，这里对应的View不能直接fromeVC.view获取
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    self.transitionContext = transitionContext;
    
    //1. 获取到当前VC 目标VC
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //2. 获取当前的容器视图
    UIView * contentView = [transitionContext containerView];
    
    //3. 添加fromView,与toView（不能直接fromeVC.view获取）
    UIView *toView = [transitionContext viewForKey:(UITransitionContextToViewKey)];

    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    //[contentView addSubview:fromView];
    [contentView addSubview:toView];
    
    //4. contentView 设置蒙版 (这里是灰色的蒙版)
    contentView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    
//    //5. 动画实现 分为present动画和dismiss动画 （可以在Animatr的代理方法中区分并传进来）
//    if(present){
//        [UIView animateWithDuration:0.3 animations:^{
//            
//        }completion:^(BOOL finished) {
//            //注意：完成动画要调用[transitionContext completeTransition:YES];告诉系统完成动画了，否则就会造成toView不能相应点击的情况，可能在执行完动画后，系统回到了主线程，一直在等待完成命令，所以没有办法执行点击事件
//            [transitionContext completeTransition:YES];
//        }];
//    }else if(dismiss){
//        [UIView animateWithDuration:0.3 animations:^{
//            
//        } completion:^(BOOL finished) {
//            //注意：同present如果不告诉系统完成动画了就会直接dismiss掉fromeVC不会有任何动画，（这里的dismiss只是把present时候的toVC与fromeVC颠倒了）
//            [transitionContext completeTransition:YES];
//        }];
//    }
    //4. contentView 设置蒙版
    if (self.setupContainerViewBlock) {
        self.setupContainerViewBlock(contentView);
    }
    
    //5. 动画执行
    switch (self.animatedTransitionType) {
        case AnimatedTransitionType_Present:{
            if (self.presentAnimaBlock){
                self.presentAnimaBlock(toVC,fromVC,toView,fromView);
            }
        }
            break;
        case AnimatedTransitionType_Dismiss:{
            if (!toView) toView = toVC.view;//如果没有toView 那么就用toVC.View
            if (self.dismissAnimaBlock) {
                self.dismissAnimaBlock(toVC,fromVC,toView,fromView);
            }
        }
            break;
    }
    
    //最后如果不做动画完成处理，就会造成toView不能相应点击的情况，可能在执行完动画后，系统回到了主线程，一直在等待完成命令，所以没有办法执行点击事件
    //等待这个方法执行完毕才能进行下一波操作，否则会出现还没有执行完动画就被结束了（调度组不行）
    //最后还是弄了个属性记录了一下，当外界完成动画后一定要把isAccomplishAnima 设置成yes
//    if (self.dismissDuration) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animaDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [transitionContext completeTransition:YES];
//        });
//    }
    //如果实现了这个方法，那么告诉系统，动画停止了
//    if (self.completeTransitionBlock) {
//        [self setCompleteTransitionBlock:^(BOOL isComplete) {
//            [transitionContext completeTransition: isComplete];
//        }];
//    }
}



@end
