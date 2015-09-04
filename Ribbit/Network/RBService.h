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
#import "RBMessage.h"


typedef void (^FetchUsers)(NSArray *users);
typedef void (^FetchFriends)(NSArray *friends);
typedef void (^AddFriend)(BOOL succeeded);
typedef void (^UploadedFileSucceeded)(BOOL succeeded);
typedef void (^UploadedFileFailed)();
typedef void (^FetchMessages)(NSArray *messages);
typedef void (^SeenMessage)(BOOL succeeded);



@interface RBService : NSObject
@property (nonatomic) RBUser *user;

+ (instancetype)service;
- (void)users:(FetchUsers)completion;
- (void)fetchFriends:(FetchFriends)completion;
- (void)addFriend:(RBUser *)user completion:(AddFriend)completion;
- (void)removeFriend:(RBUser *)user completion:(AddFriend)completion;
- (void)uploadImage:(UIImage *)image recipients:(NSMutableArray *)recipients success:(UploadedFileSucceeded)success failure:(UploadedFileFailed)failure;
- (void)uploadVideo:(NSString *)path recipients:(NSMutableArray *)recipients success:(UploadedFileSucceeded)success failure:(UploadedFileFailed)failure;
- (void)fetchMessages:(FetchMessages)completion;
- (void)didSeenMessage:(RBMessage *)message completion:(SeenMessage)completion;
@end
