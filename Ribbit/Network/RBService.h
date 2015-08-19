//
//  RBUserService.h
//  Ribbit
//
//  Created by Amir Ghoreshi on 05/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBUser.h"
#import <Parse/Parse.h>
#import "RBUploadData.h"

typedef void (^SignUpInBackground)(BOOL succeeded, NSError *error);
typedef void (^LogInInBackground)(PFUser *user, NSError *error);
typedef void (^FetchUsers)(NSArray *users);
typedef void (^FetchFriends)(NSArray *friends);
typedef void (^AddFriend)(BOOL succeeded);
typedef void (^UploadedFileSucceeded)(BOOL succeeded);
typedef void (^UploadedFileFailed)();



@interface RBService : NSObject
@property (nonatomic) RBUser *currentUser;

+ (instancetype)service;
- (void)signUp:(RBUser *)user completion:(SignUpInBackground)completion;
- (void)logIn:(RBUser *)user completion:(LogInInBackground)completion;
- (void)users:(FetchUsers)completion;
- (void)fetchFriends:(FetchFriends)completion;
- (void)addFriend:(RBUser *)user completion:(AddFriend)completion;
- (void)removeFriend:(RBUser *)user completion:(AddFriend)completion;
- (void)uploadFile:(UIImage *)image recipients:(NSArray *)recipients success:(UploadedFileSucceeded)success failure:(UploadedFileFailed)failure;
@end
