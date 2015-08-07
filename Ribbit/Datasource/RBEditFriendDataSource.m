//
//  RBEditFriendDataSource.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 06/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBEditFriendDataSource.h"
#import "RBUserService.h"


@interface RBEditFriendDataSource ()
@property (nonatomic) NSArray *users;
@property (nonatomic) RBUser *currentUser;
@property (nonatomic) RBUserService *service;
@end

@implementation RBEditFriendDataSource

#pragma mark - init

- (instancetype)init {
    if (self) {
        _service = [RBUserService new];
    }
    return self;
}

- (void) dataSource:(Users)completion {
    [_service users:^(NSArray *users) {
        _users = users;
        completion();
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"editFriendTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    RBUser *user = [_users objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self count];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    RBUser *user = [_users objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_service friend:user completion:^(BOOL succeeded) {
        if (succeeded) {
            LogTrace(@"%@ is now a friend of yours", user);
        } else {
            LogDebug(@"Ouch!");
        }
    }];
}

#pragma mark - Utility

- (NSInteger)count {
    return [self.users count];
}
@end
