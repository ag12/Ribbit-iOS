//
//  RBUserService.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 05/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBService.h"
#import <Parse/Parse.h>
#import <TMCache/TMCache.h>
#import <SAMCache/SAMCache.h>
#import "RBMessage.h"
#import "RBUploadData.h"


#define  kUsername @"username"
#define  kFriendsCache @"friendsCache"
#define  kFriendsRelation @"friendsRelation"


@interface RBService ()
@property (nonatomic) PFRelation *friendsRelation;
@end

@implementation RBService



#pragma mark - init


+ (instancetype)service {
    
    static RBService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [RBService new];
    });
    service.currentUser = [RBUser currentUser];
    service.friendsRelation = [service.currentUser relationForKey:kFriendsRelation];
    return service;
}

/*
- (instancetype)init {
    self = [super init];
    if (self) {
        _currentUser = [RBUser currentUser];
        _friendsRelation = [_currentUser relationForKey:kFriendsRelation];
    }
    return self;
}
*/
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

- (void)addFriend:(RBUser *)user completion:(AddFriend)completion {
    PFRelation *friends = [self.currentUser relationForKey:kFriendsRelation];
    [friends addObject:user];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            if (completion) {
                completion(YES);
            }
            return;
        }
        if (completion) {
            completion(NO);
        }
    }];
}

- (void)removeFriend:(RBUser *)user completion:(AddFriend)completion {
    PFRelation *friends = [self.currentUser relationForKey:kFriendsRelation];
    [friends removeObject:user];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            if (completion) {
                completion(YES);
            }
            return;
        }
        if (completion) {
            completion(NO);
        }
    }];
}

- (void)fetchFriends:(FetchFriends)completion {
    PFQuery *query = [_friendsRelation query];
    [query orderByAscending:kUsername];
    [query findObjectsInBackgroundWithBlock:^(NSArray *friends, NSError *error){
        if (error) {
            LogDebug(@"Error while fetching friends %@, %@", error, [error userInfo]);
            completion(nil);
            return;
        } else {
            LogTrace(@"Success while fetching friends");
            completion(friends);
        }
    }];
}

#pragma mark - Messages

- (void)uploadFile:(UIImage *)image recipients:(NSMutableArray *)recipients success:(UploadedFileSucceeded)success failure:(UploadedFileFailed)failure {

    RBUploadData *data = [[RBUploadData alloc] initWithImage:image user:self.currentUser recipients:recipients];
    [[data getFile] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {

            RBMessage *message = [[RBMessage alloc] initWithFile:[data getFile] data:data];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if (succeeded) {
                    success(succeeded);
                    return;
                }else {
                    failure();
                }
            }];

        } else {
            failure();
        }
    }];
}

- (void)fetchMessages:(FetchMessages)completion {
    PFQuery *query = [RBMessage query];
    [query whereKey:[RBMessage recipients] equalTo:_currentUser.objectId];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error) {
        if (messages) {
            completion(messages);
            return;
        } else {
            completion(nil);
        }

    }];
}


@end