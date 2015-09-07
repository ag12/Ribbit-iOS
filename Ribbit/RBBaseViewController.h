//
//  RBBaseViewController.h
//  Ribbit
//
//  Created by Håkon Knutzen on 05/09/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @description Base class for the other view controllers for the Ribbit App.
 This class allows for automatic instantiation of the login sequence if
 the user has logged out or does not exist.
 */
@interface RBBaseViewController : UIViewController <UINavigationControllerDelegate>

/**
 @warning This method should not be overridden. If it is overridden
 the intended presentation of the login VC will not function.
 */
-(void)presentLoginAnimated:(BOOL)animated;

@end
