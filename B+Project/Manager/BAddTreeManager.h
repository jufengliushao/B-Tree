//
//  BAddTreeManager.h
//  B+Project
//
//  Created by shaofeng liu on 2018/12/16.
//  Copyright © 2018年 shaofeng liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MiddleNodeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BAddTreeManager : NSObject
+ (instancetype)shareInsatance;
/**
 * 插入节点leaf
 */
- (void)insertNode:(LeafModel *)model;
@end

NS_ASSUME_NONNULL_END
