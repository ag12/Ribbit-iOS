//
//  EditFriendViewController.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 05/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "EditFriendViewController.h"
#import "RBEditFriendDataSource.h"

@interface EditFriendViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) RBEditFriendDataSource *editDataSource;

@end

@implementation EditFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.editDataSource = [[RBEditFriendDataSource alloc] initWithFriends:self.friends];
    self.tableView.dataSource = self.editDataSource;
    self.tableView.delegate = self.editDataSource;
    [self.editDataSource dataSource:^{
        [self.tableView reloadData];
    }];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"editFriendViewControllerSegue"]) {

        
    }
}


@end