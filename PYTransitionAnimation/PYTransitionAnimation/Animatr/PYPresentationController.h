//
//  PYPresentationController.h
//  PYTransitionAnimation
//
//  Created by 李鹏跃 on 17/3/16.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYPresentationController : UIPresentationController
/**
 * layoutSubViewBlock: 可以设置toVC的view的frame，以及 containerView 的背景颜色
 * toVC: 要跳转的控制器
 * containerView: 跳转时存放fromVC与toVC的容器视图
 */
@property (nonatomic,copy) void(^layoutSubViewBlock)(UIViewController *toVC,UIView *containerView);
- (void)layoutSubViewWithBlock: (void(^)(UIViewController *toVC, UIView *containerView))layoutSubViewBlock;
@end
