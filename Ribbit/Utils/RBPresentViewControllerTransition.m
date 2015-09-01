//
//  RBPresentViewControllerTransition.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 31/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBPresentViewControllerTransition.h"

@implementation RBPresentViewControllerTransition


#pragma mark - transition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //get the viewController
    UIViewController *destinationViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];

    destinationViewController.view.alpha = 0.0f;
    destinationViewController.view.frame = containerView.bounds;

    CGRect frame = containerView.bounds;
    frame.origin.y += 20.0f;
    frame.size.height -= 20.0f;

    destinationViewController.view.frame = frame;

    //Add the controllers view to the container
    [containerView addSubview:destinationViewController.view];

    [UIView animateWithDuration:0.3f animations:^{
        destinationViewController.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - duration

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}



@end
