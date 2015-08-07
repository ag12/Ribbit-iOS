//
//  RBUserService.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 05/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBUserService.h"
#import <Parse/Parse.h>


#define  kUsername @"username"
#define  kFriendsRelation @"friendsRelation"


@interface RBUserService ()
@property (nonatomic) RBUser *currentUser;
@end

@implementation RBUserService



#pragma mark - init

- (instancetype) init {
    self = [super init];
    if (self) {
        _currentUser = [RBUser currentUser];
    }
    return self;
}

#pragma mark - Sign up 

- (void)signUp:(RBUser *)user completion:(SignUpInBackground)completion {
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            LogTrace(@"YES");
            completion(YES, error);

        } else {
            LogDebug(@"NOPE")
            LogDebug(error);
            completion(NO, error);
        }
    }];
}

#pragma mark - Log in

- (void)logIn:(RBUser *)user completion:(LogInInBackground)completion {
    [RBUser logInWithUsernameInBackground:user.username password:user.password block:^(PFUser *user, NSError *error) {
        if (!error) {
            completion(user, nil);
        } else {
            completion(nil, error);
        }
    }];
}

#pragma mark - Fetch Users

- (void)users:(FetchUsers)completion {
    PFQuery *query = [RBUser query];
    [query whereKey:kUsername notEqualTo:_currentUser.username];
    [query orderByAscending:kUsername];
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error){
        if (error) {
            LogDebug(@"Error while fetching users %@, %@", error, [error userInfo]);
            completion(nil);
            return;
        } else {
            LogTrace(@"Success while fetching users %@", users);
            completion(users);
        }
    }];
}

#pragma mark - Friends

- (void)friend:(RBUser *)user completion:(AddFriend)completion {
    PFRelation *friends = [self.currentUser relationForKey:kFriendsRelation];
    [friends addObject:user];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            completion(YES);
            return;
        }
        completion(NO);
    }];
}

@end
