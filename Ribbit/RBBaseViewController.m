//
//  RBBaseViewController.m
//  Ribbit
//
//  Created by Håkon Knutzen on 05/09/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBBaseViewController.h"
#import "RBService.h"

@interface RBBaseViewController ()

@end

@implementation RBBaseViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(![[RBService service] userActiveForCurrentSession]){
        [self presentLoginAnimated:NO];
    }
}

-(void)presentLoginAnimated:(BOOL)animated
{
    UIViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    NSAssert(loginViewController != nil, @"Login controller not found in storyboard");
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    navigationController.delegate = self;
    [self presentViewController:navigationController
                       animated:animated
                     completion:nil];
}


@end
