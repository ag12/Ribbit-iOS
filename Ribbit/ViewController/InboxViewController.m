//
//  InboxViewController.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 05/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>
#import "InboxViewController.h"
#import "RBUser.h"
#import "RBInboxDataHandler.h"
#import "RBPresentViewControllerTransition.h"
#import "RBDismissViewControllerTransition.h"
#import "RBMessageViewController.h"
#import "MBProgressHUD.h"
#import "AuthenticationService.h"

#define kAuthenticationSegue @"authenticationSegue"
#define kMessageSegue @"messageSegue"

@interface InboxViewController () <UITableViewDelegate, UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logOut;
@property (nonatomic) RBUser *user;
@property (nonatomic) RBInboxDataHandler *dataHandler;
@property (nonatomic) RBMessage *message;
@property (nonatomic) MPMoviePlayerController *mPlayer;
@end


@implementation InboxViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.user = [AuthenticationService getUser];
    if (self.user) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s %@", self.user.username, @"Inbox"];
    }
    [self updateMessages];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataHandler = [RBInboxDataHandler new];
    self.tableView.dataSource = self.dataHandler;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.user = [AuthenticationService getUser];
    if (self.user) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s %@", self.user.username, @"Inbox"];
        self.mPlayer = [MPMoviePlayerController new];
    } else {
        self.navigationItem.hidesBackButton = YES;
        [self performSegueWithIdentifier:kAuthenticationSegue sender:self];
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kAuthenticationSegue]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    } else if ([segue.identifier isEqualToString:kMessageSegue]) {
        [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] windows] lastObject] animated:YES];
        RBMessageViewController *messageViewController = [RBMessageViewController new];
        messageViewController.message = self.message;
        messageViewController.modalPresentationStyle = UIModalPresentationCustom;
        messageViewController.transitioningDelegate = self;
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        [self presentViewController:messageViewController animated:YES completion:nil];
    }
}

- (IBAction)logOut:(id)sender {
    [[AuthenticationService new] logOut];
    [self performSegueWithIdentifier:kAuthenticationSegue sender:self];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.message = [self.dataHandler.data objectAtIndex:indexPath.row];
    if (self.message) {
        [[RBService service] didSeenMessage:self.message completion:^(BOOL succeeded) {
            [self updateMessages];
        }];
        if ([self.message isImageFile]) {
            [self performSegueWithIdentifier:kMessageSegue sender:self];
        } else {
            [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] windows] lastObject] animated:YES];
            self.mPlayer.contentURL = [[NSURL alloc] initWithString:self.message.file.url];
            [self.mPlayer prepareToPlay];
            //[self.mPlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            [self.view addSubview:self.mPlayer.view];
            [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] windows] lastObject] animated:YES];
            [self.mPlayer setFullscreen:YES animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)updateMessages {
    LogTrace(@"updateMessages");
    if (self.dataHandler) {
        [self.dataHandler dataSource:^{
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return [RBPresentViewControllerTransition new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [RBDismissViewControllerTransition new];
}
@end