//
//  RBFriendsDataHandler.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 07/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBFriendsDataHandler.h"
#import "RBService.h"



@implementation RBFriendsDataHandler

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        _friends = nil;
    }
    return self;
}

- (void) dataSource:(Friends)completion {
    [self.service fetchFriends:^(NSArray *friends) {
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