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
    self.editDataSource = [RBEditFriendDataSource new];
    self.tableView.dataSource = self.editDataSource;
    self.tableView.delegate = self.editDataSource;

    [self.editDataSource dataSource:^{
        [self.tableView reloadData];
        LogTrace(@"Its all done");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
