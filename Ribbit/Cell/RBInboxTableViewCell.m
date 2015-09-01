//
//  RBInboxTableViewCell.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 28/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBInboxTableViewCell.h"

@implementation RBInboxTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageWithMessage:(RBMessage *)message {
    self.senderLabel.text = message.senderName;
    if ([message isImageFile]) {
        self.image.image = [UIImage imageNamed:@"icon_image"];
    } else {
        self.image.image = [UIImage imageNamed:@"icon_video"];
    }
    self.time.text = [message time];

}

@end
