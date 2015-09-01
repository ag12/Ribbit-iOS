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
#import "RBInboxDataHandler.h"
#import "RBPresentViewControllerTransition.h"
#import "RBDismissViewControllerTransition.h"
#import "RBMessageViewController.h"


#define kAuthenticationSegue @"authenticationSegue"
#define kMessageSegue @"messageSegue"

@interface InboxViewController () <UITableViewDelegate, UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logOut;
@property (nonatomic) RBUser *user;
@property (nonatomic) RBInboxDataHandler *dataHandler;

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
        self.dataHandler = [RBInboxDataHandler new];
        self.tableView.dataSource = self.dataHandler;
        self.tableView.delegate = self;
        [self.dataHandler dataSource:^{
            [self.tableView reloadData];
        }];
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

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
    } else if ([segue.identifier isEqualToString:kMessageSegue]) {
        RBMessageViewController *messageViewController = [RBMessageViewController new];
        messageViewController.modalPresentationStyle = UIModalPresentationCustom;
        messageViewController.transitioningDelegate = self;
        [self presentViewController:messageViewController animated:YES completion:nil];
        LogTrace(@"DONE DIII");
    }
}

- (IBAction)logOut:(id)sender {
    [RBUser logOut];
    [self performSegueWithIdentifier:kAuthenticationSegue sender:self];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:kMessageSegue sender:self];
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    LogTrace(@"LOZZZ");
    return [RBPresentViewControllerTransition new];

}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    LogTrace(@"DISMISS");
    return [RBDismissViewControllerTransition new];
}

@end
