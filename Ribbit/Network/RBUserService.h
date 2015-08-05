//
//  RBUserService.h
//  Ribbit
//
//  Created by Amir Ghoreshi on 05/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBUser.h"

typedef void (^SignUpInBackground)(BOOL succeeded, NSError *error);
typedef void (^LogInInBackground)(PFUser *user, NSError *error);


@interface RBUserService : NSObject

- (void)signUp:(RBUser *)user completion:(SignUpInBackground)completion;
- (void)logIn:(RBUser *)user completion:(LogInInBackground)completion;

@end
