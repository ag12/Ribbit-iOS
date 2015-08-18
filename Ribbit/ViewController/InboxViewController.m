//
//  InboxViewController.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 05/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "InboxViewController.h"
#import <Parse/Parse.h>
#import "RBUser.h"

#define kAuthenticationSegue @"authenticationSegue"

@interface InboxViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logOut;
@property (nonatomic) RBUser *user;
@end

@implementation InboxViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _user = [RBUser currentUser];
    if (_user) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s %@", _user.username, @"Inbox"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LogTrace(@"ViewDidLoad");
    _user = [RBUser currentUser];
    if (_user) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s %@", _user.username, @"Inbox"];
    } else {
        self.navigationItem.hidesBackButton = YES;
        [self performSegueWithIdentifier:kAuthenticationSegue sender:self];
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kAuthenticationSegue]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

- (IBAction)logOut:(id)sender {
    [RBUser logOut];
    [self performSegueWithIdentifier:kAuthenticationSegue sender:self];
}

@end
