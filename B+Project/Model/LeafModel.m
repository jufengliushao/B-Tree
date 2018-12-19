//
//  LeafModel.m
//  B+Project
//
//  Created by shaofeng liu on 2018/12/16.
//  Copyright © 2018年 shaofeng liu. All rights reserved.
//

#import "LeafModel.h"

@implementation LeafModel
- (instancetype)initWithArr:(NSArray *)arr{
    if (self = [super init]) {
        self.index = [arr.firstObject integerValue];
        self.a_attribute = arr.lastObject;
    }
    return self;
}
@end
