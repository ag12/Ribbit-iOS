//
//  AuthenticationService.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 04/09/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "AuthenticationService.h"

@implementation AuthenticationService

#pragma mark - Sign up

- (void)signUp:(RBUser *)user completion:(SignUpInBackground)completion {
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            completion(YES, error);
        } else {
            completion(NO, error);
        }
    }];
}

#pragma mark - Log in

- (void)logIn:(RBUser *)user completion:(LogInInBackground)completion {
    [RBUser logInWithUsernameInBackground:user.username password:user.password block:^(PFUser *user, NSError *error) {
        if (!error) {
            LogTrace(@"LOG IN ::%@", [AuthenticationService getUser]);
            completion(user, nil);
            return;
        } else {
            completion(nil, error);
        }
    }];
}

#pragma mark - Log out

- (void)logOut {
    [RBUser logOut];
    LogTrace(@"LOG OUT ::%@", [AuthenticationService getUser]);
}

+  (RBUser *)getUser {
    return [RBUser currentUser];
}
@end
