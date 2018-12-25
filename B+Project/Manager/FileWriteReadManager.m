//
//  FileWriteReadManager.m
//  B+Project
//
//  Created by shaofeng liu on 2018/12/16.
//  Copyright © 2018年 shaofeng liu. All rights reserved.
//

#import "FileWriteReadManager.h"
#import "SFFileManager.h"
FileWriteReadManager *readWriteM = nil;
NSString *fileName = @"Sources.txt";

@interface FileWriteReadManager(){
    NSString *filePath;
    NSInteger recordCount;
    NSUInteger _dataLength;
    NSString *rss;
}

@end

@implementation FileWriteReadManager
+ (instancetype)shareInsatance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!readWriteM) {
            readWriteM = [[FileWriteReadManager alloc] init];
        }
    });
    return readWriteM;
}

- (instancetype)init{
    if (self = [super init]) {
        filePath = [[SFFileManager shareInstance].sf_getDocumentsPath stringByAppendingPathComponent:fileName];
        recordCount = 100;
        _dataLength = @"00043#abcdefg00043\n".length;
        rss = @"abcdefg";
        NSLog(@"%@", filePath);
    }
    return self;
}

#pragma mark - public methods
- (void)createFile{
    [[SFFileManager shareInstance] sf_createFile:fileName path:filePath];
    [self file_writeRecordsData];
}

- (__kindof NSArray *)readData:(NSInteger)count{
    return [self private_readDataFromPath:filePath count:count];
}
#pragma mark - private methods
- (void)file_writeRecordsData{
    NSFileHandle *hander = [NSFileHandle fileHandleForWritingAtPath:filePath];
    [hander seekToEndOfFile];
    long i = 0;
    while (i < recordCount) {
        [hander writeData:[[self createRecords] dataUsingEncoding:NSUTF8StringEncoding]];
        i ++;
    }
    [hander closeFile];
}

- (NSString *)createRecords{
    NSString *result;
    NSString *index = [NSString stringWithFormat:@"%05u", arc4random() % 100];
    result = [NSString stringWithFormat:@"%@#%@%@\n", index, rss, index];
    _dataLength = result.length;
    return result;
}

- (NSString *)returnRecords:(LeafModel *)leaf{
    NSString *result = [NSString stringWithFormat:@"%05ld#%@%@", leaf.index, leaf.a_attribute, @"abcdefg"];
    result = [result substringWithRange:NSMakeRange(0, _dataLength - 1)];
    return [NSString stringWithFormat:@"%@\n", result];
}

/**
 * 写入数据
 */
- (void)writeLeafData:(LeafModel *)leaf{
    NSFileHandle *hander = [NSFileHandle fileHandleForWritingAtPath:filePath];
    [hander seekToEndOfFile];
    [hander writeData:[[self returnRecords:leaf] dataUsingEncoding:NSUTF8StringEncoding]];
    [hander closeFile];
}

/**
 * 读取数据
 */
- (NSMutableArray *)private_readDataFromPath:(NSString *)path count:(long)count{
    NSFileHandle *hander = [NSFileHandle fileHandleForReadingAtPath:path];
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];
    long index = 0;
    while (index < count) {
        NSString *str = [[NSString alloc] initWithData:[hander readDataOfLength:_dataLength] encoding:NSUTF8StringEncoding];
        [dataArr addObject:[self createLeafModel:str]];
        index ++;
    }
    [hander closeFile];
    return dataArr;
}

- (LeafModel *)createLeafModel:(NSString *)str{
    NSArray *arr = [str componentsSeparatedByString:@"#"];
    LeafModel *model = [[LeafModel alloc] initWithArr:arr];
    NSLog(@"--------index:%ld", model.index);
    return model;
}
@end
