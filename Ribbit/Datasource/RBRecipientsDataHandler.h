//
//  RBRecipientsDataHandler.h
//  Ribbit
//
//  Created by Amir Ghoreshi on 13/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBDataHandler.h"

typedef void (^Recipients)();

@interface RBRecipientsDataHandler : RBDataHandler
- (void)dataSource:(Recipients)completion;
@property (nonatomic) NSMutableArray *recipients;
-(void)reset;
@end
