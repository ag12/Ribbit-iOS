//
//  RBFriendsDataHandler.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 07/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBFriendsDataHandler.h"
#import "RBUserService.h"

@interface RBFriendsDataHandler ()
@property (nonatomic) RBUserService *service;
@end

@implementation RBFriendsDataHandler

#pragma mark - init

- (instancetype)init {
    if (self) {
        _service = [RBUserService new];
    }
    return self;
}

- (void) dataSource:(Friends)completion {
    [_service fetchFriends:^(NSArray *friends) {
        _friends = friends;
        completion();
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"friendTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    RBUser *user = [_friends objectAtIndex:indexPath.row];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Utility

- (NSInteger)count {
    return [_friends count];
}
@end