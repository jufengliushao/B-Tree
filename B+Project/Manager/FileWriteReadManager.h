//
//  FileWriteReadManager.h
//  B+Project
//
//  Created by shaofeng liu on 2018/12/16.
//  Copyright © 2018年 shaofeng liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeafModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FileWriteReadManager : NSObject
+ (instancetype)shareInsatance;
- (void)createFile; // 创建文件

/**
 * 读取数据
 * count - 读取数据的行数
 */
- (__kindof NSArray *)readData:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
