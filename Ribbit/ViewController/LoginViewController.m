//
//  LoginViewController.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 05/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthenticationService.h"
#import <ReactiveCocoa/RACEXTScope.h>


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *signup;
@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)login:(id)sender {

    NSString *username = [RBUtils trimTextField:self.username];
    NSString *password = [RBUtils trimTextField:self.password];

    if (username.length == 0 || password.length == 0 ) {

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ouch!"
                                                            message:@"You did not nailed it!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];

    } else {
        RBUser *user = [RBUser new];
        user.username = username;
        user.password = password;
        @weakify(self);
        [[AuthenticationService new] logIn:user completion:^(PFUser *user, NSError *error) {
            if (user) {
                @strongify(self);
//                [self.navigationController popToRootViewControllerAnimated:YES];
                id navigationControllerDelegate = self.navigationController.delegate;
                if([navigationControllerDelegate isKindOfClass:[UIViewController class]]){
                    [(UIViewController *)navigationControllerDelegate dismissViewControllerAnimated:YES completion:nil];
                }
                
            }
        }];
    }
}
@end
