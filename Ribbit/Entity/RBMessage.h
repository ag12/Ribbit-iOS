//
//  RBMessage.h
//  Ribbit
//
//  Created by Amir Ghoreshi on 18/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "PFObject.h"
#import <Parse/Parse.h>
#import "RBUploadData.h"

@interface RBMessage : PFObject <PFSubclassing>
- (instancetype)initWithFile:(PFFile *)file data:(RBUploadData *)data;
@property (nonatomic) PFFile *file;
@property (nonatomic, strong) NSString *fileType;
@property (nonatomic) NSArray *recipients;
@property (nonatomic) NSString *senderId;
@property (nonatomic) NSString *senderName;

+ (NSString *)recipients;
- (BOOL)isImageFile;
@end
