//
//  MiddleNodeModel.m
//  B+Project
//
//  Created by shaofeng liu on 2018/12/16.
//  Copyright © 2018年 shaofeng liu. All rights reserved.
//

#import "MiddleNodeModel.h"

@implementation MiddleNodeModel
- (instancetype)init{
    if (self = [super init]) {
        self.keys = [NSMutableArray arrayWithCapacity:4];
        [self.keys addObject:@"-1"];
        self.children = [NSMutableArray arrayWithCapacity:0];
        self.parent = nil;
    }
    return self;
}
@end
