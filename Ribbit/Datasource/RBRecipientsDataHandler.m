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

@end

@implementation RBRecipientsDataHandler

#pragma mark - init

- (instancetype)init {
    if (self) {
        _service = [RBUserService new];
    }
    return self;
}

- (void) dataSource:(Recipients)completion {
    [_service fetchFriends:^(NSArray *recipients) {
        _recipients = [NSMutableArray arrayWithArray:recipients];
        completion();
    }];
}
#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"recipientsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    RBUser *user = [_recipients objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_recipients count];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
