//
//  RBInboxDataHandler.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 28/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBInboxDataHandler.h"
#import "RBInboxTableViewCell.h"
#import "RBMessage.h"

@interface RBInboxDataHandler()

@end

@implementation RBInboxDataHandler


- (void) dataSource:(Messages)completion {
    [[RBService service] fetchMessages:^(NSArray *messages) {
        self.data = messages;
        completion();
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"inboxTableViewCell";
    RBInboxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    RBMessage *message = [self.data objectAtIndex:indexPath.row];
    [cell setMessageWithMessage:message];
    return cell;
}
@end
