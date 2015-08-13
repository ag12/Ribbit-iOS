//
//  RBFriendsDataHandler.h
//  Ribbit
//
//  Created by Amir Ghoreshi on 07/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

typedef void (^Friends)();


@interface RBFriendsDataHandler : NSObject <UITableViewDataSource, UITableViewDelegate>
- (void) dataSource:(Friends)completion;
@property (nonatomic) NSArray *friends;
@end
