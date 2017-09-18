![转场动画.gif](http://upload-images.jianshu.io/upload_images/4185621-462ed58e40a04439.gif?imageMogr2/auto-orient/strip)


#一、 参考资料:
> 1.王巍 《博客》（非常详细，推荐阅读）
https://onevcat.com/2013/10/vc-transition-in-ios7/
2.xiao333ma 《博客》
http://blog.csdn.net/xiao333ma/article/details/49028241#t1
3.[VincentHK](http://www.jianshu.com/u/b3fda29e8dfb)[ iOS 视图控制器转场详解](http://www.jianshu.com/p/c26a4180b375)

-----------------------------------------------------------------------
#二、protocol
**1.@protocol UIViewControllerContextTransitioning**
1. 这个接口用来提供切换上下文给开发者使用，包含了从哪个VC到哪个VC等各类信息，一般不需要开发者自己实现。具体来说，iOS7的自定义切换目的之一就是切换相关代码解耦，在进行VC切换时，做切换效果实现的时候必须要需要切换前后VC的一些信息。
2. 重要的方法：
```
-(UIView *)containerView; 
VC切换所发生的view容器，开发者应该将切出的view移除，将切入的view加入到该view容器中。
```
```
-(UIViewController *)viewControllerForKey:(NSString *)key; 
提供一个key，返回对应的VC。现在的SDK中key的选择只有:
UITransitionContextFromViewControllerKey表示将要切出VC。
UITransitionContextToViewControllerKey表示将要切入的VC。
```

```
-(CGRect)initialFrameForViewController:(UIViewController *)vc; 
某个VC的初始位置，可以用来做动画的计算。
-(CGRect)finalFrameForViewController:(UIViewController *)vc; 
与上面的方法对应，得到切换结束时某个VC应在的frame。
```
```
-(void)completeTransition:(BOOL)didComplete; 
向这个context报告切换已经完成。
```

**2.@protocol UIViewControllerAnimatedTransitioning**
>1.  这个接口负责切换的具体内容，也即“切换中应该发生什么”。开发者在做自定义切换效果时大部分代码会是用来实现这个接口。
2. 重要的方法：
```
-(NSTimeInterval)transitionDuration:(id < UIViewControllerContextTransitioning >)transitionContext; 
系统给出一个切换上下文，我们根据上下文环境返回这个切换所需要的花费时间
（一般就返回动画的时间就好了，SDK会用这个时间来在百分比驱动的切换中进行帧的计算）
```
```
-(void)animateTransition:(id < UIViewControllerContextTransitioning >)transitionContext;
 在进行切换的时候将调用该方法，我们对于切换时的UIView的设置和动画都在这个方法中完成。
```

**3.@protocol UIViewControllerTransitioningDelegate**
>1. 这个接口的作用比较简单单一，在需要VC切换的时候系统会像实现了这个接口的对象询问是否需要使用自定义的切换效果。
>2. 这个接口共有四个类似的方法：
前两个方法是针对动画切换的，我们需要分别在呈现VC和解散VC时，给出一个实现了UIViewControllerAnimatedTransitioning接口的对象（其中包含切换时长和如何切换）。后两个方法涉及交互式切换
```
-(id< UIViewControllerAnimatedTransitioning >)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
```
```
-(id< UIViewControllerAnimatedTransitioning >)animationControllerForDismissedController:(UIViewController *)dismissed;
```
```
-(id< UIViewControllerInteractiveTransitioning >)interactionControllerForPresentation:(id < UIViewControllerAnimatedTransitioning >)animator;
```
```
-(id< UIViewControllerInteractiveTransitioning >)interactionControllerForDismissal:(id < UIViewControllerAnimatedTransitioning >)animator;
```

-----------------------------------------------------------------------

#三、没有交互的代码具体思想步骤
>情景: VC_a跳到VC_b ,注意，转场动画不难，但是套路一定要明显，我们都是有原则的人。[戳这里看源码](https://github.com/LiPengYue/PYTransitionTool)

**1. 创建`VC_a`：` VC_a`可以什么都不用做，直接`presen`**

**2. 构建`Animatr`转场动画的工具类（继承`NSObject `遵守`<UIViewControllerTransitioningDelegate>`协议）**
1. 在`Animatr`中实现代理方法
```
//present
-(id< UIViewControllerAnimatedTransitioning >)animationControllerForDismissedController:(UIViewController *)dismissed;
//dismiss
-(id<UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
```

2. 创建`AnimatedTransition`（继承`NSObject`遵守`<UIViewControllerAnimatedTransitioning>`协议，在Animatr的方法中创建并返回）
>1. 你会发现，返回值需要遵守`UIViewControllerAnimatedTransitioning `协议的id类型的类
于是  创建`AnimatedTransition`
>2. 内部实现两个方法
 . 返回动画时长
```
//1. 返回一个动画时长，这个时长尽量要与实际动画时长一直，因为系统会以此来作为转场参考时间
-(NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;
```
```
//2. 具体动画的实现类
-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
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
    //5. 动画实现 分为present动画和dismiss动画 （可以在Animatr的代理方法中区分并传进来）
    if(present){
        [UIView animateWithDuration:0.3 animations:^{
//这里不能用toView.view获取toView
        }completion:^(BOOL finished) {
            //注意：完成动画要调用[transitionContext completeTransition:YES];告诉系统完成动画了，否则就会造成toView不能相应点击的情况，可能在执行完动画后，系统回到了主线程，一直在等待完成命令，所以没有办法执行点击事件
            [transitionContext completeTransition:YES];
        }];
    }else if(dismiss){
        [UIView animateWithDuration:0.3 animations:^{
        //这时候，必须要用toVC.View获取toView
        } completion:^(BOOL finished) {
            //注意：同present如果不告诉系统完成动画了就会直接dismiss掉fromeVC不会有任何动画，（这里的dismiss只是把present时候的toVC与fromeVC颠倒了）
            [transitionContext completeTransition:YES];
        }];
  }    
}
```

3. `VC_b`: 在init方法里面设置`delegate`和`modalPresentationStyle`
```
-(instancetype)init
{
    self = [super init];
    if (self) {
 //这个属性表示在modal、dismiss的时候会走自定义的方法
        self.transitioningDelegate = self;
// 这个方法保证fromView才不会被移除(及可以在modal后看到a控制器的view)
 self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}
```
---
#四、有交互代码实现思路 —— 手势驱动的百分比切换
**1. 创建一个UIPercentDrivenInteractiveTransition 类**
>1.这是一个实现了UIViewControllerInteractiveTransitioning接口的类，为我们预先实现和提供了一系列便利的方法，可以用一个百分比来控制交互式切换的过程。一般来说我们更多地会使用某些手势来完成交互式的转移。

**2. 本类中重要的方法**
```
-(void)updateInteractiveTransition:(CGFloat)percentComplete;
//更新百分比，一般通过手势识别的长度之类的来计算一个值，然后进行更新。

-(void)cancelInteractiveTransition ;
//报告交互取消，返回切换前的状态

–(void)finishInteractiveTransition;
 //报告交互完成，更新到切换后的状态
```

**3. 给view添加手势（对于手势的总结请看 [iOS 手势的基本介绍](http://www.jianshu.com/p/399fb18ad551)）**

---
#五、对于坑
**1.  dismiss转场结束后出现黑屏：**
参考：[iOS 视图控制器转场详解](https://github.com/seedante/iOS-Note/wiki/ViewController-Transition#%E7%89%B9%E6%AE%8A%E7%9A%84-modal-%E8%BD%AC%E5%9C%BA)
>Custom 模式：presentation 结束后，presentingView(fromView) 未被主动移出视图结构，在 dismissal 中，注意不要像其他转场中那样将 presentingView(toView) 加入 containerView 中，否则 dismissal 结束后本来可见的 presentingView 将会随着 containerView 一起被移除。如果你在 Custom 模式下没有注意到这点，很容易出现黑屏之类的现象而不知道问题所在。
在 Custom 模式下的**dismissal 转场**（在present中要添加）中不要像其他的转场那样将 toView(presentingView) 加入 containerView，否则 presentingView 将消失不见，而应用则也很可能假死。而 FullScreen 模式下可以使用与前面的容器类 VC 转场同样的代码。因此，上一节里示范的 Slide 动画控制器不适合在 Custom 模式下使用，放心好了，Demo 里适配好了，具体的处理措施，请看下一节的处理


#六、代码学习
 1.[github源码](https://github.com/wazrx/XWTrasitionPractice)：简书作者[wazrx](http://www.jianshu.com/u/80e096a6331e)
2.OC：[转场动画的管理工具类（无交互）](https://github.com/LiPengYue/PYTransitionTool)
3.swift: [转场动画的管理工具类（无交互)](https://github.com/LiPengYue/PYTransitionTool_swift)
