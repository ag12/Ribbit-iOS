//
//  RBFriendsDataHandler.h
//  Ribbit
//
//  Created by Amir Ghoreshi on 07/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//


#import "RBDataHandler.h"

typedef void (^Friends)();


@interface RBFriendsDataHandler : RBDataHandler 
- (void) dataSource:(Friends)completion;
@property (nonatomic) NSArray *friends;
@end
