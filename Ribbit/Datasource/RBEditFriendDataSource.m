//
//  RBEditFriendDataSource.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 06/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBEditFriendDataSource.h"
#import "RBService.h"
#import <ReactiveCocoa/RACEXTScope.h>


@interface RBEditFriendDataSource ()
@property (nonatomic) NSArray *users;
@property (nonatomic) NSMutableArray *friends;
@end

@implementation RBEditFriendDataSource

#pragma mark - init
- (instancetype) initWithFriends:(NSArray *)friends {
    self = [super init];
    if (self) {
        if (friends) {
            self.friends = [NSMutableArray arrayWithArray:friends];
        }
    }
    return self;
}

#pragma mark - Source

- (void) dataSource:(Users)completion {
    if (!self.friends) {
        [[RBService service] fetchFriends:^(NSArray *friends) {
            self.friends = [NSMutableArray arrayWithArray:friends];
            [[RBService service] users:^(NSArray *users) {
                self.users = users;
                completion();
            }];
        }];

    } else {
        [[RBService service] users:^(NSArray *users) {
            self.users = users;
            completion();
        }];
    }
}
#pragma mark - Utility Source

- (BOOL)isFriend:(RBUser *)user {
    if (self.friends) {
        for (RBUser *friend in _friends) {
            if ([friend.objectId isEqualToString:user.objectId]) {
                return YES;
            }
        }
    }
    return NO;
}
#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"editFriendTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    RBUser *user = [_users objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    if ([self isFriend:user]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
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
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.friends removeObject:user];
        [[RBService service] removeFriend:user completion:nil];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.friends addObject:user];
        [[RBService service] addFriend:user completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Utility

- (NSInteger)count {
    return [self.users count];
}
@end
