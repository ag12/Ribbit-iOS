//
//  RBInboxTableViewCell.h
//  Ribbit
//
//  Created by Amir Ghoreshi on 28/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBMessage.h"

@interface RBInboxTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *time;

- (void)setMessageWithMessage:(RBMessage *)message;

@end
