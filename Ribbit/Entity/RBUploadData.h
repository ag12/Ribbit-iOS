//
//  RBFile.h
//  Ribbit
//
//  Created by Amir Ghoreshi on 18/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBUser.h"
#import <Parse/Parse.h>

@interface RBUploadData : NSObject

- (instancetype)initWithImage:(UIImage *)image user:(RBUser *)user recipients:(NSMutableArray *)recipients;
- (instancetype)initWithVideoPath:(NSString *)path user:(RBUser *)user recipients:(NSMutableArray *)recipients;
@property (nonatomic) NSData *fileData;
@property (nonatomic) NSString *fileName;
@property (nonatomic) NSString *fileType;
@property (nonatomic) NSArray *recipients;
@property (nonatomic) RBUser *user;
- (PFFile *)getFile;
@end
