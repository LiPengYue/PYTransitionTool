//
//  PushViewController.m
//  PYTransitionAnimation
//
//  Created by 李鹏跃 on 17/3/16.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "PushViewController.h"
#import "Animater.h"
@interface PushViewController ()
@property (nonatomic,strong) Animater *animater;
@end

@implementation PushViewController

//可以在懒加载的时候进行动画的设置
- (Animater *)animater {
    if (!_animater) {
        _animater = [[Animater alloc]init];
        //dismiss动画预估时长
        _animater.dismissDuration = 4;
        
        //present动画预估时长
        _animater.presentDuration = 5;
        
        //dismiss转场动画
        [_animater dismissAnimaWithBlock:^(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView) {
            NSLog(@"dismiss开始");
            [UIView animateWithDuration:_animater.dismissDuration animations:^{
                fromeView.frame = CGRectMake(0, 0, 100, 100);
            } completion:^(BOOL finished) {
                //在完成动画的时候一定要把这个属性设置成YES 告诉系统动画完成
                _animater.isAccomplishAnima = YES;
            }];
        }];
        
        //present转场动画
        [_animater presentAnimaWithBlock:^(UIViewController *toVC, UIViewController *fromeVC, UIView *toView, UIView *fromeView) {
            [UIView animateWithDuration:_animater.presentDuration animations:^{
                toView.frame = CGRectMake(0,300, 300, 300);
            } completion:^(BOOL finished) {
                //在完成动画的时候一定要把这个属性设置成YES 告诉系统动画完成
                _animater.isAccomplishAnima = YES;
            }];
        }];
        
        //容器视图，装有toView和fromeView，可以作为遮罩
        [_animater setupContainerViewWithBlock:^(UIView *containerView) {
            containerView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        }];
        
    }
    return _animater;
}

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self.animater;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    UIButton *but = [[UIButton alloc]init];
    but.frame = CGRectMake(0, 0, 20, 20);
    but.backgroundColor = [UIColor blackColor];
    [self.view addSubview:but];
    [but addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickButton: (UIButton *)but {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



- (void)dealloc {
    NSLog(@"-------------%@",self);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
