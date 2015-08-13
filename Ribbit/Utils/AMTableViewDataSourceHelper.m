//
//  AMTableViewHelper.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 13/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "AMTableViewDataSourceHelper.h"
#import "RBUser.h"

@implementation AMTableViewDataSourceHelper

- (instancetype)helper {
    static AMTableViewDataSourceHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [AMTableViewDataSourceHelper new];
    });
    return helper;
}
@end
