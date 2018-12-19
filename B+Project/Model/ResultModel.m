//
//  ResultModel.m
//  B+Project
//
//  Created by shaofeng liu on 2018/12/19.
//  Copyright © 2018年 shaofeng liu. All rights reserved.
//

#import "ResultModel.h"

@implementation ResultModel
- (instancetype)initWithLeaf:(LeafModel *)leaf floor:(NSInteger)num{
    if (self = [super init]) {
        self.result = leaf;
        self.floors = num;
        self.isFind = leaf == nil ? NO : YES;
    }
    return self;
}
@end
