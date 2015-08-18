//
//  RBRecipientsDataHandler.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 13/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBRecipientsDataHandler.h"
#import "RBUserService.h"

@interface RBRecipientsDataHandler() 
@property (nonatomic) RBUserService *service;
@property (nonatomic) NSArray *data;
@end

@implementation RBRecipientsDataHandler

#pragma mark - init

- (instancetype)init {
    if (self) {
        _service = [RBUserService service];
    }
    return self;
}

- (void) dataSource:(Recipients)completion {
    [_service fetchFriends:^(NSArray *recipients) {
        _data = recipients;
        /*
        if (_recipients) {
            _recipients = [NSMutableArray arrayWithArray:_recipients];
        } else {
            _recipients = [NSMutableArray array];
        }*/
         _recipients = [NSMutableArray array];
        completion();
    }];
}
#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"recipientsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    RBUser *user = [_data objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    if ([self isRecipients:user]) {
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
    return [_data count];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    RBUser *user = [_data objectAtIndex:indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        //if ([self isRecipients:user]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [_recipients removeObject:user.objectId];
        //}
    } else /*if (cell.accessoryType == UITableViewCellAccessoryNone)*/ {
        //if (![self isRecipients:user]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [_recipients addObject:user.objectId];
        //}
    }
    LogTrace(@"%@", _recipients);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Utility Source

- (BOOL)isRecipientsCheck:(RBUser *)user {
    if (_recipients) {
        for (NSString *rip in _recipients) {
            if ([rip isEqualToString:user.objectId]) {
                return YES;
            }
        }
    }
    return NO;
}
- (BOOL)isRecipients:(RBUser *)user {
    return [_recipients containsObject:user.objectId];
}
@end
