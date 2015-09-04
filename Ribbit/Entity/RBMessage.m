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
    self = [super init];
    if (self) {
        self.file = file;
        self.fileType = data.fileType;
        self.recipients = data.recipients;
        self.senderId = data.user.objectId;
        self.senderName = data.user.username;
    }
    return self;
}

+ (NSString *)recipients {
    return @"recipients";
}
- (BOOL)isImageFile {
    return [self.fileType isEqualToString:@"image"];
}

- (NSString *)time {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.locale = [NSLocale currentLocale];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    });
    return [formatter stringFromDate:self.createdAt];
}
@end