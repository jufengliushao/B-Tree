//
//  MiddleNodeModel.h
//  B+Project
//
//  Created by shaofeng liu on 2018/12/16.
//  Copyright © 2018年 shaofeng liu. All rights reserved.
//

#import "BaseModel.h"
#import "LeafModel.h"

@interface MiddleNodeModel : BaseModel
@property (nonatomic, strong) NSMutableArray *keys; // 存储当前中间节点key
@property (nonatomic, strong) MiddleNodeModel *parent; // 当前节点的父节点，若为nil则表示当前节点存储的为leaf - 仅限根节点时刻
@property (nonatomic, strong) NSMutableArray *children; // 保存指针指向的model 可以为leaf middle
@end


