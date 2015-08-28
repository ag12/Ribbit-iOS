//
//  RBDataHandler.h
//  Ribbit
//
//  Created by Amir Ghoreshi on 28/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBService.h"

@interface RBDataHandler : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) RBService *service;
@property (nonatomic) NSArray *data;
@end
