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
#import "RBUploadData.h"
#import "AuthenticationService.h"

#define  kUsername @"username"
#define  kFriendsCache @"friendsCache"
#define  kFriendsRelation @"friendsRelation"


@interface RBService ()
@property (nonatomic) PFRelation *friendsRelation;
@end

@implementation RBService

-(BOOL)userActiveForCurrentSession
{
    return self.user != nil ? YES : NO;
}

#pragma mark - init


+ (instancetype)service {
    
    static RBService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [RBService new];
    });
    service.user = [AuthenticationService getUser];
    if (service.user) {
        service.friendsRelation = [service.user relationForKey:kFriendsRelation];
    }
    return service;
}

#pragma mark - Fetch Users

- (void)users:(FetchUsers)completion {
    PFQuery *query = [RBUser query];
    [query whereKey:kUsername notEqualTo:self.user.username];
    [query orderByAscending:kUsername];
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error){
        if (error) {
            completion(nil);
            return;
        } else {
            completion(users);
        }
    }];
}

#pragma mark - Friends

- (void)addFriend:(RBUser *)user completion:(AddFriend)completion {
    PFRelation *friends = [self.user relationForKey:kFriendsRelation];
    [friends addObject:user];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
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
    PFRelation *friends = [self.user relationForKey:kFriendsRelation];
    [friends removeObject:user];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
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
            completion(nil);
            return;
        } else {
            completion(friends);
        }
    }];
}

#pragma mark - Messages

- (void)uploadImage:(UIImage *)image recipients:(NSMutableArray *)recipients success:(UploadedFileSucceeded)success failure:(UploadedFileFailed)failure {

    RBUploadData *data = [[RBUploadData alloc] initWithImage:image user:self.user recipients:recipients];
    [self uploadMessage:data success:success failure:failure];
}
- (void)uploadVideo:(NSString *)path recipients:(NSMutableArray *)recipients success:(UploadedFileSucceeded)success failure:(UploadedFileFailed)failure {

    RBUploadData *data = [[RBUploadData alloc] initWithVideoPath:path user:self.user recipients:recipients];
    [self uploadMessage:data success:success failure:failure];
}
- (void)uploadMessage:(RBUploadData *)data  success:(UploadedFileSucceeded)success failure:(UploadedFileFailed)failure {

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
    // found error: if self.user is null (e.g., first time user) the app will crash
    // because the parameter equalTo cannot be null. equalTo can however take NSNull:

    id userId = [self userActiveForCurrentSession] ? self.user.objectId : [NSNull null];
    [query whereKey:[RBMessage recipients] equalTo:userId];
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

- (void)didSeenMessage:(RBMessage *)message completion:(SeenMessage)completion {

    NSMutableArray *array = [NSMutableArray arrayWithArray:message.recipients];
    if (array.count == 1) {
        [message deleteInBackgroundWithBlock:^(BOOL deleted, NSError *error){
            completion(deleted);
        }];
    } else {
        [array removeObject:[AuthenticationService getUser].objectId];
        [message setRecipients:[NSArray arrayWithArray:array]];
        [message saveInBackgroundWithBlock:^(BOOL deleted, NSError *error){
            completion(deleted);
        }];
    }
}
@end