//
//  RBMessage.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 18/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBMessage.h"
#import "RBUser.h"

@implementation RBMessage

@dynamic file;
@dynamic fileType;
@dynamic recipients;
@dynamic senderId;
@dynamic senderName;

+ (NSString *)parseClassName {
    return @"Message";
}

- (instancetype)initWithFile:(PFFile *)file data:(RBUploadData *)data  {
    //self = [super initWithClassName:@"Messages"];
    self = [super init];
    if (self) {
        self.file = file;
        self.fileType = data.fileType;
        self.recipients = data.recipients;
        self.senderId = data.user.objectId;
        self.senderName = data.user.username;
        /*
        [self setObject:file forKey:@"file"];
        [self setObject:message.fileType forKey:@"fileType"];
        [self setObject:recipients forKey:@"recipients"];
        [self setObject:[[RBUser currentUser] objectId] forKey:@"senderId"];
        [self setObject:[[RBUser currentUser] username] forKey:@"senderName"];
         */
    }
    return self;
}

+ (NSString *)recipients {
    return @"recipients";
}
- (BOOL)isImageFile {
    return [self.fileType isEqualToString:@"image"];
}
@end
