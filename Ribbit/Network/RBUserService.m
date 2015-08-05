//
//  RBUserService.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 05/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBUserService.h"

@implementation RBUserService

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

- (void)logIn:(RBUser *)user completion:(LogInInBackground)completion {
    [RBUser logInWithUsernameInBackground:user.username password:user.password block:^(PFUser *user, NSError *error) {
        if (!error) {
            completion(user, nil);
        } else {
            completion(nil, error);
        }
    }];
}
@end
