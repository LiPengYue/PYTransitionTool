//
//  PYPresentationController.m
//  PYTransitionAnimation
//
//  Created by 李鹏跃 on 17/3/16.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "PYPresentationController.h"

@implementation PYPresentationController
#pragma mark - 重写布局子界面的方法
//在跳转的时候这里可以设置跳转控制器的大小，并且，containerView的大小为屏幕大小
///containerView是不会变的，他是负责转场动画中VC切换的根本容器
- (void)containerViewWillLayoutSubviews{
    
    //1.调用父类的方法
    [super containerViewWillLayoutSubviews];
    
    //2.获取容器视图
    UIView *containerView= self.containerView;
    
    //3.获取第二个控制器的View
    UIViewController *toController = self.presentedViewController;
    UIView *twoView = self.presentedView;
    
    //4.添加到容器视图中
    [containerView addSubview:twoView];
  
    
    //5.布局block
    if (self.layoutSubViewBlock) {
      self.layoutSubViewBlock(toController,containerView);
    }
    
    //6.如果没有大小那么就刷新界面
    if(!toController.view.frame.size.height || !toController.view.frame.size.width){
        [self.containerView layoutIfNeeded];
    }
}

- (void)layoutSubViewWithBlock:(void (^)(UIViewController *, UIView *))layoutSubViewBlock {
    self.layoutSubViewBlock = layoutSubViewBlock;
}
@end
