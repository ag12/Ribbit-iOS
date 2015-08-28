//
//  RBInboxDataHandler.h
//  Ribbit
//
//  Created by Amir Ghoreshi on 28/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBDataHandler.h"

typedef void (^Messages)();


@interface RBInboxDataHandler : RBDataHandler
- (void) dataSource:(Messages)completion;

@end
