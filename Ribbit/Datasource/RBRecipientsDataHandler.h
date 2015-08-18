//
//  RBRecipientsDataHandler.h
//  Ribbit
//
//  Created by Amir Ghoreshi on 13/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//


typedef void (^Recipients)();

@interface RBRecipientsDataHandler : NSObject <UITableViewDataSource, UITableViewDelegate>
- (void)dataSource:(Recipients)completion;
@property (nonatomic) NSMutableArray *recipients;
@end
