//
//  ViewController.m
//  PYTransitionAnimation
//
//  Created by 李鹏跃 on 17/3/13.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "ViewController.h"
#import "PushViewController.h"
#import "Animatr.h"
@interface ViewController () <UIViewControllerTransitioningDelegate
>
@property (nonatomic,strong) UIButton *transitionButton;
@property (nonatomic,strong) UIViewController *VC;
@property (nonatomic,strong) Animatr *animatr;
@property (nonatomic, strong) id vc;
@end


@implementation ViewController

- (Animatr *)animatr {
    if (!_animatr) {
        _animatr = [[Animatr alloc]init];
    }
    return _animatr;
}

//- (instancetype)init {
//    if (self = [super init]) {
//        self.modalPresentationStyle = UIModalPresentationCustom;
//        self.transitioningDelegate = self.animatr;
//    }
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupButton];
    [self setupTransitionVC];
    self.view.backgroundColor = [UIColor redColor];
}


- (void)setupButton {
    self.transitionButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 500, 100, 100)];
    self.transitionButton.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.transitionButton];
    
    [self.transitionButton addTarget:self action:@selector(clickTransitionButton:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)clickTransitionButton: (UIButton *)button {
    UIViewController *pushViewController = [[PushViewController alloc]init];
    [self presentViewController:pushViewController animated:YES completion:nil];
    self.vc = pushViewController;
}

- (void)setupTransitionVC {
    self.VC = [[UIViewController alloc]init];
    self.VC.view.backgroundColor = [UIColor redColor];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 101, 100)];
    [self.VC.view addSubview:button];
    button.backgroundColor = [UIColor grayColor];
    [button addTarget:self action:@selector(clickCallBackButton:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)clickCallBackButton: (UIButton *)button {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
