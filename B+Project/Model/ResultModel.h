//
//  ResultModel.h
//  B+Project
//
//  Created by shaofeng liu on 2018/12/19.
//  Copyright © 2018年 shaofeng liu. All rights reserved.
//

#import "BaseModel.h"
#import "LeafModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ResultModel : BaseModel
@property (nonatomic, strong) LeafModel *result; // 查询的结果
@property (nonatomic, assign) NSInteger floors; // 查询了几次
@property (nonatomic, assign) BOOL isFind; // 是否找到

- (instancetype)initWithLeaf:(LeafModel *)leaf floor:(NSInteger)num;
@end

NS_ASSUME_NONNULL_END
