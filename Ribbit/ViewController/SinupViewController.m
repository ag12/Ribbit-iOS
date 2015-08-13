//
//  SinupViewController.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 05/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "SinupViewController.h"
#import "RBUserService.h"
#import <ReactiveCocoa/RACEXTScope.h>


@interface SinupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *signup;

@end

@implementation SinupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
- (IBAction)signup:(id)sender {

    NSString *username = [RBUtils trimTextField:self.username];
    NSString *password = [RBUtils trimTextField:self.password];
    NSString *email = [RBUtils trimTextField:self.email];

    if (username.length == 0 || password.length == 0 || email.length == 0) {

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ouch!" message:@"You did not nailed it!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];

    } else {
        RBUser *user = [RBUser new];
        user.username = username;
        user.password = password;
        user.email = email;
        @weakify(self);
        [[RBUserService new] signUp:user completion:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                @strongify(self);
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}
@end
