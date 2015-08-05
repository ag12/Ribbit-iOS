//
//  RBUtils.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 05/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBUtils.h"

@implementation RBUtils


#pragma mark - Utils

+ (NSString *)trimTextField:(UITextField *)field {

    return [field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
