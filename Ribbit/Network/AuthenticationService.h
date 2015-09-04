//
//  AuthenticationService.h
//  Ribbit
//
//  Created by Amir Ghoreshi on 04/09/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBUser.h"

typedef void (^SignUpInBackground)(BOOL succeeded, NSError *error);
typedef void (^LogInInBackground)(PFUser *user, NSError *error);

@interface AuthenticationService : NSObject

- (void)signUp:(RBUser *)user completion:(SignUpInBackground)completion;
- (void)logIn:(RBUser *)user completion:(LogInInBackground)completion;
- (void)logOut;
+  (RBUser *)getUser;
@end
