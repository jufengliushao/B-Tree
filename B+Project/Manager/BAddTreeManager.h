//
//  BAddTreeManager.h
//  B+Project
//
//  Created by shaofeng liu on 2018/12/16.
//  Copyright © 2018年 shaofeng liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MiddleNodeModel.h"
#import "ResultModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BAddTreeManager : NSObject
+ (instancetype)shareInsatance;
/**
 * 插入节点leaf
 */
- (void)insertNode:(LeafModel *)model;

/**
 * 对数据进行搜索
 * index - 查询的下表
 * return - 查询结果
 */
- (ResultModel *)searchNodeWithIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
