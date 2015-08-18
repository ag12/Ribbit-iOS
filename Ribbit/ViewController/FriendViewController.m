//
//  FriendViewController.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 05/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "FriendViewController.h"
#import "EditFriendViewController.h"

@interface FriendViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataHandler = [RBFriendsDataHandler new];
    self.tableView.dataSource = self.dataHandler;
    self.tableView.delegate = self.dataHandler;
    [self.dataHandler dataSource:^{
        [self.tableView reloadData];
    }];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.dataHandler) {
        [self.dataHandler dataSource:^{
            [self.tableView reloadData];
        }];
    }
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
    if ([segue.identifier isEqualToString:@"editFriendViewControllerSegue"]) {
        EditFriendViewController *editFriendViewController = (EditFriendViewController *)segue.destinationViewController;
        editFriendViewController.friends = self.dataHandler.friends;
    }
}
@end