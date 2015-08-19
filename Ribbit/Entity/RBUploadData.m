//
//  RBFile.m
//  Ribbit
//
//  Created by Amir Ghoreshi on 18/08/15.
//  Copyright (c) 2015 AM. All rights reserved.
//

#import "RBUploadData.h"
#import <Parse/Parse.h>

@implementation RBUploadData



- (instancetype)initWithImage:(UIImage *)image user:(RBUser *)user recipients:(NSMutableArray *)recipients {
    self = [super init];
    if (self) {
        _fileData = UIImagePNGRepresentation(image);
        _fileName = @"image.png";
        _fileType = @"image";
        _user = user;
        _recipients = [NSArray arrayWithArray:recipients];
    }
    return self;
}
- (instancetype)initWithVideoPath:(NSString *)path user:(RBUser *)user recipients:(NSMutableArray *)recipients {
    self = [super init];
    if (self) {
        _fileData = [NSData dataWithContentsOfFile:path];
        _fileName = @"video.mov";
        _fileType = @"video";
        _user = user;
        _recipients = [NSArray arrayWithArray:recipients];
    }
    return self;
}

- (PFFile *)getFile {
    return [PFFile fileWithName:_fileName data:_fileData];
}

@end
