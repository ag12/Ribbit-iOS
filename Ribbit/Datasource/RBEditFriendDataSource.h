//
//  RBEditFriendDataSource.h
//  Ribbit
//
//  Created by Amir Ghoreshi on 06/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//


typedef void (^Users)();

@interface RBEditFriendDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
- (instancetype) initWithFriends:(NSArray *)friends;
- (void) dataSource:(Users)completion;

@end
