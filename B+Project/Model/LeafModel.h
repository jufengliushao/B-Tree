//
//  LeafModel.h
//  B+Project
//
//  Created by shaofeng liu on 2018/12/16.
//  Copyright © 2018年 shaofeng liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LeafModel : BaseModel
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *a_attribute;
- (instancetype)initWithArr:(NSArray *)arr;
@end

NS_ASSUME_NONNULL_END
