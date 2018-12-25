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
 * b+tree 生成后，进行手动插入
 */
- (LeafModel *)insertFileNode:(NSInteger)index msg:(NSString *)msg;

/**
 * 对数据进行搜索
 * index - 查询的下表
 * return - 查询结果
 */
- (ResultModel *)searchNodeWithIndex:(NSInteger)index;

/**
 * 对指定索引进行删除
 * index - 删除的下表
 * return - 删除结果
 */
- (ResultModel *)deleteNodeWithIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
