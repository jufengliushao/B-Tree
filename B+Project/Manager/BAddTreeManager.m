//
//  BAddTreeManager.m
//  B+Project
//
//  Created by shaofeng liu on 2018/12/16.
//  Copyright © 2018年 shaofeng liu. All rights reserved.
//

#import "BAddTreeManager.h"
BAddTreeManager *bTreeM = nil;

@interface BAddTreeManager(){
    NSInteger B_ADD_M; // b+ 阶数
    MiddleNodeModel *rootNode; // 根节点
    NSMutableArray *deleteArr; //
}

@end

@implementation BAddTreeManager
+ (instancetype)shareInsatance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!bTreeM) {
            bTreeM = [[BAddTreeManager alloc] init];
        }
    });
    return bTreeM;
}

- (instancetype)init{
    if (self = [super init]) {
        B_ADD_M = 3;
        deleteArr = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

#pragma mark - public methods
/**
 * 插入节点leaf
 */
- (void)insertNode:(LeafModel *)model{
    if (!rootNode) {
        [self createRootNode:model];
    }else{
        if (rootNode.keys.count < 2) {
            // 当前rootNode中间存储的是叶子节点
            [self insertChildLeaf:rootNode leaf:model];
            if (rootNode.children.count > B_ADD_M) {
                // 根节点超过阶数
                [self spliteLeaf:rootNode];
            }
        }else{
            // 当前根节点为中间索引
            MiddleNodeModel *node = [self searchInsertPoint:model.index];
            [self insertChildLeaf:node leaf:model];
            if (node.children.count > B_ADD_M) {
                // 叶子点超过阶数
                [self spliteLeaf:node];
            }
            // 进行中间节点的分裂判断
            [self spliteMiddleNode:node.parent];
        }
    }
}

/**
 * 对数据进行搜索
 * index - 查询的下表
 * return - 查询结果
 */
- (ResultModel *)searchNodeWithIndex:(NSInteger)index{
    NSInteger tagFound= 0;
    NSInteger num = 0;
    MiddleNodeModel *node = rootNode;
    MiddleNodeModel *result;
    LeafModel *tmp;
    while (tagFound == 0 && node) {
        num ++;
        NSInteger i = 0;
        i = [self seartchNode:node index:index];
        result = node.children[i];
        if (result.keys.count < 2) {
            // 此节点为叶子节点
            // 若里面没有数据，则表示，查找不到
            for (LeafModel *m in result.children) {
                if (m.index == index) {
                    tmp = m;
                    tagFound = 1;
                    break;
                }
            }
            if (tagFound == 0) {
                break;
            }
        }else{
            // 当前节点仍为中间索引节点
            node = result;
            continue;
        }
    }
    ResultModel *re = [[ResultModel alloc] initWithLeaf:tmp floor:num];
    re.isFind = re.isFind ? ([deleteArr containsObject:re.result] ? NO : YES) : NO;
    return re;
}

/**
 * b+tree 生成后，进行手动插入
 */
- (LeafModel *)insertFileNode:(NSInteger)index msg:(NSString *)msg{
    LeafModel *model = [[LeafModel alloc] initWithArr:@[@(index), msg]];
    [self insertNode:model];
    return model;
}

/**
 * 对指定索引进行删除
 * index - 删除的下表
 * return - 删除结果
 */
- (ResultModel *)deleteNodeWithIndex:(NSInteger)index{
    [self private_deleteIndex:index];
    ResultModel *result = [self searchNodeWithIndex:index];
    result.isFind = [deleteArr containsObject:result.result] ? NO : YES;
    if (result.isFind) {
        [self deleteAction_HN:result.result];
    }
    return result;
}
#pragma mark - private methods
/**
 * 查找indexc需要插入的节点 - 返回的是叶子节点
 * child - leafs
 * index - leaf.index
 */
- (MiddleNodeModel *)searchInsertPoint:(NSInteger)index{
    NSInteger flagFind = 0;
    MiddleNodeModel *former = nil;
    MiddleNodeModel *node = rootNode;
    // 循环找出对应的插入节点
    while (node && flagFind == 0) {
        NSInteger i = [self seartchNode:node index:index];
        MiddleNodeModel *tmp = node.children[i];
        if (tmp.keys.count < 2) {
            // 当前node为叶子节点直接返回
            node = tmp;
            flagFind = 1;
            break;
        }
        former = node;
        node = tmp;
    }
    return node;
}

/**
 * 找到对应需要插入节点的key分支
 */
- (NSInteger)seartchNode:(MiddleNodeModel *)node index:(NSInteger)index{
    NSInteger i = 0;
    for ( i = 0; i < node.keys.count-1 && index >= [node.keys[i + 1] integerValue]; i ++) {
        
    }
    return i;
}

/**
 * 创建根节点，并将leaf添加到数组中
 * leaf 第一个数据的节点
 */
- (void)createRootNode:(LeafModel *)leaf{
    MiddleNodeModel *middle = [[MiddleNodeModel alloc] init];
    [middle.children addObject:leaf];
    rootNode = middle;
}

/**
 * 创建索引节点
 * index - 第一个元素
 * return - 返回中间节点
 */
- (MiddleNodeModel *)createMiddle:(NSInteger)index{
    MiddleNodeModel *middle = [[MiddleNodeModel alloc] init];
    [middle.keys addObject:[NSString stringWithFormat:@"%ld", index]];
    return middle;
}

/**
 * 创建索引、叶子节点
 * arr - 存入child
 * parent - parent
 */
- (MiddleNodeModel *)createMiddleChildLeaf:(NSArray *)arr parent:(MiddleNodeModel *)parent{
     MiddleNodeModel *middle = [[MiddleNodeModel alloc] init];
    [self resetparent:arr parent:middle];
    [middle.children addObjectsFromArray:arr];
    middle.parent = parent;
    return middle;
}

/**
 * 将leaf插入数组
 */
- (void)insertChildLeaf:(MiddleNodeModel *)middle leaf:(LeafModel *)leaf{
    NSInteger i = 0;
    for (i = 0; i <middle.children.count && [middle.children[i] index] < leaf.index; i ++) {
        
    }
    [middle.children insertObject:leaf atIndex:i];
}

/**
 * 分裂叶子节点
 */
- (void)spliteLeaf:(MiddleNodeModel *)node{
    NSDictionary *dic = [self spliteArr:node.children];
    NSArray *first = dic[@"first"];
    NSArray *second = dic[@"second"];
    if (node.parent == nil) {
        // 为根节点
        MiddleNodeModel *middle = [self createMiddle:[second.firstObject index]];
        // 左节点
        MiddleNodeModel *leftNode = [self createMiddleChildLeaf:first parent:middle];
        
        // 右节点
        MiddleNodeModel *rightNode= [self createMiddleChildLeaf:second  parent:middle];
        
        [middle.children addObject:leftNode];
        [middle.children addObject:rightNode];
        rootNode = middle;
    }else{
        // 向上一个节点进行分裂
        [self addMiddleValue:node first:first second:second index:[second.firstObject index]];
    }
}

/**
 * 在中间节点插入索引
 */
- (void)addMiddleValue:(MiddleNodeModel *)node first:(NSArray *)first second:(NSArray *)second index:(NSInteger)index{
    MiddleNodeModel *parent = node.parent;
    NSInteger i = 0;
    for (i = 0; i < parent.keys.count && [parent.keys[i] integerValue] < index; i ++) {
        
    }
    [parent.keys insertObject:[NSString stringWithFormat:@"%ld", index] atIndex:i];
    
    // 重新设置node 节点数据
    [node.children removeAllObjects];
    [node.children addObjectsFromArray:first];
    node.parent = parent;
    
    MiddleNodeModel *rightNode = [self createMiddleChildLeaf:second parent:parent];
    [parent.children insertObject:rightNode atIndex:i];
}

/**
 * 在中间节点插入索引
 */
- (void)addMiddleValueKey:(MiddleNodeModel *)node first:(NSArray *)first second:(NSArray *)second  firstC:(NSArray *)firstC secondeC:(NSArray *)secondC index:(NSInteger)index{
    MiddleNodeModel *parent = node.parent;
    NSInteger i = 0;
    for (i = 0; i < parent.keys.count && [parent.keys[i] integerValue] < index; i ++) {
        
    }
    [parent.keys insertObject:[NSString stringWithFormat:@"%ld", index] atIndex:i];
    
    // 重新设置node 节点数据
    MiddleNodeModel *leftNode = [self createMiddleChildLeaf:firstC parent:parent];
    [node.keys removeAllObjects];
    [node.keys addObjectsFromArray:first];
    node.children = leftNode.children;
    [self resetparent:firstC parent:node];
    node.parent = parent;
    
    MiddleNodeModel *rightNode = [self createMiddleChildLeaf:secondC parent:parent];
    rightNode.parent = parent;
    [rightNode.keys addObjectsFromArray:second];
    [rightNode.keys removeObjectAtIndex:1];
    [parent.children insertObject:rightNode atIndex:i];
}

/**
 * 分裂中间索引节点
 */
- (void)spliteMiddleNode:(MiddleNodeModel *)node{
    if (node.keys.count <= B_ADD_M + 1 || !node) {
        // 无需分裂
        return;
    }
    // 分裂key
    [node.keys removeObjectAtIndex:0];
    NSDictionary *dict1 = [self spliteArr:node.keys];
    NSArray *first = dict1[@"first"];
    NSArray *second = dict1[@"second"];
    // 分裂child
    NSMutableArray *firstC = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *secondC = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i <= first.count; i++) {
        [firstC addObject:node.children[i]];
    }
    for (NSInteger i = first.count + 1; i < node.children.count; i++) {
        [secondC addObject:node.children[i]];
    }
    // 需要自己移除second 第一个数据
    if (!node.parent) {
        // 没有父节点的中间节点，当前节点为根节点
        [self spliteRootMiddle:node first:first second:second firstC:firstC secondC:secondC];
    }else{
        // 有父节点的中间节点 - 分裂后，将值添加至父节点的中间索引
        [self spliteMiddleParentExist:node first:first second:second firstC:firstC secondC:secondC];
    }
}

/**
 * 分裂根节点索引
 * node - 需要分裂的node
 * first - key
 * second - key
 * firstC, secondC - child
 */
- (void)spliteRootMiddle:(MiddleNodeModel *)node first:(NSArray *)first second:(NSArray *)second firstC:(NSArray *)firstC secondC:(NSArray *)secondC{
    MiddleNodeModel *newNode = [self createMiddle:[second.firstObject integerValue]];
    MiddleNodeModel *leftNode = [self createMiddleChildLeaf:firstC parent:newNode];
    MiddleNodeModel *rightNode = [self createMiddleChildLeaf:secondC parent:newNode];
    [leftNode.keys addObjectsFromArray:first];
    [rightNode.keys addObjectsFromArray:second];
    [rightNode.keys removeObjectAtIndex:1];
    [newNode.children addObject:leftNode];
    [newNode.children addObject:rightNode];
    
    rootNode = newNode;
}

/**
 * 分裂存在父节点的中间索引节点
 * node - 需要分裂的node
 * first - key
 * second - key
 * firstC, secondC - child
 */
- (void)spliteMiddleParentExist:(MiddleNodeModel *)node first:(NSArray *)first second:(NSArray *)second firstC:(NSArray *)firstC secondC:(NSArray *)secondC{
    NSInteger index = [second.firstObject integerValue]; // 需要插入父节点的数据
    [self addMiddleValueKey:node first:first second:second firstC:firstC secondeC:secondC index:index];
    // 执行完向上一个中间索引分裂之后，需要对上一个中间索引进行再次检查是否c超过界限
    [self spliteMiddleNode:node.parent];
}

/**
 * 将数组 arr 按照阶数进行分裂
 */
- (NSDictionary *)spliteArr:(NSArray *)arr{
    NSInteger mid = B_ADD_M / 2;
    NSMutableArray *first = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *second = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < mid; i ++) {
        [first addObject:arr[i]];
    }
    for (NSInteger i = mid; i < arr.count; i ++) {
        [second addObject:arr[i]];
    }
    return @{
             @"first": first,
             @"second": second
             };
}

/**
 * 重新设置父节点
 */
- (void)resetparent:(NSArray *)arr parent:(MiddleNodeModel *)parent{
    if (arr.count < 1 || ![arr.firstObject isKindOfClass:[MiddleNodeModel class]]) {
        return;
    }
    for (MiddleNodeModel *m in arr) {
        m.parent = parent;
    }
}

/**
 * 调试所用的打印数据
 */
- (void)printNodeMiddle:(MiddleNodeModel *)middle{
    NSString *resulte = @"[";
    if (middle.keys.count < 2) {
        // 到了叶子节点
        for (LeafModel *mode in middle.children) {
            resulte = [NSString stringWithFormat:@"%@ %ld", resulte, mode.index];
        }
        NSLog(@"%@]value", resulte);
        return;
    }
    for (NSString *str in middle.keys) {
        resulte = [NSString stringWithFormat:@"%@ %@", resulte, str];
    }
    NSLog(@"%@]key", resulte);
    for (MiddleNodeModel *m in middle.children) {
        [self printNodeMiddle:m];
    }
}

- (void)deleteAction_HN:(LeafModel *)leaf{
    [deleteArr addObject:leaf];
}

- (void)private_deleteIndex:(NSInteger)index{
    ResultModel *result = [self searchNodeWithIndex:index];
    if (!result.isFind) {
        // 没有找到
        return;
    }
    
    if (rootNode.keys.count < 2) {
        // 根节点保存的是叶子节点
        [self private_delete_rootValue:index];
        return;
    }
    
    MiddleNodeModel *middleNode = [self searchInsertPoint:index]; // 当前的叶子节点
    if (middleNode.children.count > 1) {
        // 当前节点数据大于1
        [self private_deleteLeafWithMoreChild:middleNode index:index];
    }else{
        // 当前叶子节点只有1个数据
        [self private_deleteLeafWithOneChild:middleNode index:index];
    }
    NSLog(@"");
}

- (void)private_delete_rootValue:(NSInteger)index{
    [self private_removeLeafIndex:index array:rootNode.children];
    if (rootNode.children.count == 0) {
        // 如果根节点不保存了叶子节点，置为nil
        rootNode = nil;
    }
}

/**
 * 删除节点的叶子节点不只一个
 * leafModel - 叶子节点
 */
- (void)private_deleteLeafWithMoreChild:(MiddleNodeModel *)leafModel index:(NSInteger)index{
    NSInteger ind = 0; // 找到当前其在数组中的位置
    for (ind = 0; index < leafModel.children.count && [leafModel.children[ind] index] != index; ind ++) {
        
    }
    [self private_removeLeafIndex:index array:leafModel.children];
    if(ind == 0){
        // 是第一个数
        NSInteger updateIndex = [leafModel.children.firstObject index];
        [self private_updateIndex:updateIndex old:index leaf:leafModel];
    }
}

/**
 * 删除节点的叶子节点只有一个
 * leafModel - 叶子节点
 */
- (void)private_deleteLeafWithOneChild:(MiddleNodeModel *)leafModel index:(NSInteger)index{
    MiddleNodeModel *brother = [self private_delete_returnBortherNode:leafModel]; // 兄弟节点
    if (brother.children.count > 1) {
        //  兄弟节点数据大于 1
        [self private_delete_bortherNodeMore:leafModel brother:brother];
    }else{
        // 兄弟节点数据为1
        
    }
}

/**
 * 删除节点，问兄弟节点借
 * 兄弟节点不只一个节点
 * 1. 判断兄弟节点位置
 * 2. 若为删除节点右兄弟，借第一个数，并将剩下的leaf更新节点 更新两个索引，一个删除，一个借
 * 3. 若为左兄弟，借最后一个数, 更新一个索引
 */
- (void)private_delete_bortherNodeMore:(MiddleNodeModel *)current brother:(MiddleNodeModel *)brother{
    MiddleNodeModel *parent = current.parent;
    LeafModel *borrow;
    NSUInteger current_index = [parent.children indexOfObject:current];
    NSUInteger brother_index = [parent.children indexOfObject:brother];
    if (current_index > brother_index) {
        // 借左兄弟节点
        borrow = brother.children.lastObject;
        [brother.children removeLastObject];
        [self private_updateIndex:borrow.index old:[current.children.firstObject index] leaf:current];
    }else{
        // 借右兄弟
        borrow = brother.children.firstObject;
        [brother.children removeObject:borrow];
        [self private_updateIndex:borrow.index old:[current.children.firstObject index] leaf:current];
        [self private_updateIndex:[brother.children.firstObject index] old:borrow.index leaf:brother];
    }
    [current.children removeLastObject];
    [current.children addObject:borrow];
}

/**
 * 删除节点，问兄弟节点借
 * 兄弟节点只有一个节点
 * 1.两个进行合并，形成新的节点
 * 2. 将合并前的两个节点从父节点中删除，并将新的节点添加到父节点中，添加位置为合并前，index最小的位置
 * 3. 判断父节点，外部函数返回
 * 4. 更新节点，根据brother，左兄弟 -> 直接删除源节点的index 右兄弟的index, 右兄弟 -> 删除右节点的索引，同时对删除节点进行索引遍历，跟换成当前节点中第一个leaf的index
 * 5. 更新节点，当前所删除的节点
 */
- (void)private_delete_bortherNodeOnly:(MiddleNodeModel *)current brother:(MiddleNodeModel *)brother{
    MiddleNodeModel *parent = current.parent;
    NSUInteger current_index = [parent.children indexOfObject:current];
    NSUInteger brother_index = [parent.children indexOfObject:brother];
    NSUInteger min_index = MIN(current_index, brother_index);
//    NSInteger updateKey = min_index == current_index ? [brother.children.firstObject index] : [current.children.firstObject index]; // 需要删除的node
    MiddleNodeModel *newNode = [self createMiddleChildLeaf:@[brother.children.firstObject] parent:parent]; // 新的叶子节点
    [parent.children removeObject:current];
    [parent.children removeObject:brother];
    [parent.children insertObject:newNode atIndex:min_index];
    // 更新索引
    if (current_index < brother_index) {
        // 删除的是左子树
        [self private_updateIndex:[parent.children.firstObject index] old:[current.children.firstObject index] leaf:current];
    }
    MiddleNodeModel *newParent = [self private_delete_middleChanged:parent index:[brother.children.firstObject index]]; // 新的parent
    newNode.parent = newParent;
}

/**
 * 删除根节点后，对其父节点的合法性判断和处理
 * midNode - 需要检查的父节点
 * index - 需要删除的index
 * return - 删除index，并且经过调整的索引节点
 */
- (MiddleNodeModel *)private_delete_middleChanged:(MiddleNodeModel *)midNode index:(NSInteger)index{
    MiddleNodeModel *result;
    return result;
}

/**
 * 从数据中删除数据
 */
- (void)private_removeLeafIndex:(NSInteger)index array:(NSMutableArray *)arr{
    for (LeafModel *leaf in arr) {
        if (leaf.index == index) {
            [arr removeObject:leaf];
            break;
        }
    }
}

/**
 * 更新索引
 * 针对删除操作
 * newIndex - 新的节点
 * old - 旧的
 * leaf - 最底层的叶子节点
 */
- (void)private_updateIndex:(NSInteger)newIndex old:(NSInteger)oldIndex leaf:(MiddleNodeModel *)leaf{
    MiddleNodeModel *parent = leaf;
    BOOL isFound = 0;
    while (parent && isFound == 0) {
        for (NSInteger i = 0; i < parent.keys.count; i ++) {
            if ([parent.keys[i] integerValue] == oldIndex) {
                parent.keys[i] = [NSString stringWithFormat:@"%ld", newIndex];
                isFound = 1;
                break;
            }
        }
        parent = parent.parent;
    }
}

/**
 * 返回当前节点的兄弟节点
 * 0 -> 1
 * 1 -> 0, 2 返回较多数据的节点 若一样，返回0
 * 2 -> 1, 3 返回较多数据的节点 若一样，返回1
 * 3 -> 2
 */
- (MiddleNodeModel *)private_delete_returnBortherNode:(MiddleNodeModel *)node{
    MiddleNodeModel *parent = node.parent;
    MiddleNodeModel *result;
    NSInteger index = 0;
    for (index = 0; index < parent.children.count && parent.children[index] != node; index ++) {
        
    }
    if (index == 0) {
        result = parent.children[1];
    }else if (index == 3){
        result = parent.children[2];
    }else{
        // 中间节点 1, 2
        if (parent.children.count > index) {
            // 当前节点有三个兄弟
            result = [parent.children[index - 1] count] < [parent.children[index + 1] count] ? parent.children[index + 1] : parent.children[index - 1];
        }else{
            result = parent.children[index - 1];
        }
    }
    return result;
}
@end
