//
//  RBTabBarController.m
//  Ribbit
//
//  Created by Håkon Knutzen on 05/09/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBTabBarController.h"
#import "RBService.h"
#import "LoginViewController.h"

@interface RBTabBarController ()

@end

@implementation RBTabBarController


-(void)tabBarController:(UITabBarController *)tabBarController
didSelectViewController:(UIViewController *)viewController
{
    BOOL userActive = [[RBService service] userActiveForCurrentSession];
    NSLog(@"User is: %@",userActive ? @"active" : @"not active");
    NSLog(@"Selected: %@",viewController);
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"%@", item);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Loaded %@", self);
    self.tabBarController.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
