//
//  RBDataHandler.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 28/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBDataHandler.h"

@implementation RBDataHandler

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        _service = [RBService service];
    }
    return self;
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:@"NotImplementedException" reason:@"Should be implemented by the subclass" userInfo:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //@throw [NSException exceptionWithName:@"NotImplementedException" reason:@"Should be implemented by the subclass" userInfo:nil];
    return [self.data count];
}
@end
