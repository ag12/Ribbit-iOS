//
//  RBMessageViewController.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 31/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBMessageViewController.h"
#import "MBProgressHUD.h"
#import "RBService.h"

@interface RBMessageViewController ()
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) NSData *imageData;
@property (nonatomic) UILabel *timerLabel;

@end

@implementation RBMessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.message) {
        if ([self.message isImageFile]) {
            self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[[NSURL alloc] initWithString:self.message.file.url]]];
            [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] windows] lastObject] animated:YES];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.50]];

    if (self.message) {
        if ([self.message isImageFile]) {
            self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(-25, 0, 30, 30)];
            self.timerLabel.text = @"10";
            [self.timerLabel setBackgroundColor:[UIColor clearColor]];
            [self.timerLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
            //[self.timerLabel setTextColor:[UIColor redColor]];
            self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -320, -320, 320)];
            [self.imageView addSubview:self.timerLabel];
            [self.view addSubview:self.imageView];
        } else {

        }
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.message) {
         if ([self.message isImageFile]) {
             UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:self.view.center];
             [self.animator addBehavior:snap];
         }
    }


    //[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    if ([self respondsToSelector:@selector(time)]) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time) userInfo:nil repeats:YES];
    }
    if ([self respondsToSelector:@selector(dismiss)]) {
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)time {
    int time = [self.timerLabel.text intValue];
    time--;
    self.timerLabel.text = [NSString stringWithFormat:@"%d", time];
}

- (void)dismiss {
    [self.animator removeAllBehaviors];

    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) + 180.0f)];
    [self.animator addBehavior:snap];

    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (void)photoMessage {

}
@end