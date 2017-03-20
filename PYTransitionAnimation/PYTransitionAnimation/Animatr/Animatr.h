//
//  Animatr.h
//  PYTransitionAnimation
//
//  Created by 李鹏跃 on 17/3/13.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// ------------------------------- readMe -------------------------------
/**
//使用注意，
 // 1. dismissDuration 与presentDuration的动画事件尽量与动画时间一直，否则内存会受影响
 // 2. 最后还是弄了个属性记录了一下，当外界完成动画后一定要把isAccomplishAnima 设置成yes
 
 // 一、a跳转b，
 -----------a: a可以什么都不用做，直接present，
 -----------b: b要在init方法里面 写这两个方法，
 这个方法保证fromView才不会被移除(及可以在modal后看到a控制器的view)
 self.modalPresentationStyle = UIModalPresentationCustom;
 这个属性表示在modal、dismiss的时候会走自定义的方法
 self.transitioningDelegate = self.animatr;
 
 // 二、在执行动画类（AnimatedTransition）中：在完成动画后一定要调用[transitionContext completeTransition:YES];
 最后如果不做动画完成处理，就会造成toView不能相应点击的情况，可能在执行完动画后，系统回到了主线程，一直在等待完成命令，所以没有办法执行点击事件
 
// 三、在dismiss的时候，其实是拿不到toView的（这时候其实相当于是b-》a，用枚举记录区分一下就好）
 可以用toVC.view

// 四、在present的时候，不能用toVC.View表示toView，会出问题的老铁
 */


@interface Animatr : NSObject <UIViewControllerTransitioningDelegate>

//MARK:  -------------------- 动画时长 和类型 ------------------------
/** present动画时长*/
@property (nonatomic,assign) CGFloat presentDuration;
/** dismiss动画时长*/
@property (nonatomic,assign) CGFloat dismissDuration;
/**动画是否完成，在动画完成时候，一定要把这个属性改为YES*/
@property (nonatomic,assign) BOOL isAccomplishAnima;


//MARK: ---------------------- dismiss & present ------------------------
/**dismiss动画*/
- (void)dismissAnimaWithBlock: (void(^)(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView))dismissAnimaBlock;
/**present动画*/
- (void)presentAnimaWithBlock: (void(^)(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView))presentAnimaBlock;
//MARK: ---------------------- setupContainerView ------------------------
- (void)setupContainerViewWithBlock: (void(^)(UIView *containerView))setupContainerViewBlock;

@end
