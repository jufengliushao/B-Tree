//
//  SFFileManager.m
//  SFDBFileManager
//
//  Created by cnlive-lsf on 2017/3/16.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFFileManager.h"

SFFileManager *manager = nil;

@implementation SFFileManager
#pragma mark share instance
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[SFFileManager alloc] init];
        }
    });
    return manager;
}

#pragma mark - public method
- (NSString *)sf_getHomeDirectoryPath{
    return NSHomeDirectory();
}

- (NSString *)sf_getDocumentsPath{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

- (NSString *)sf_getLibraryPath{
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
}

- (NSString *)sf_getCachePath{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

- (NSString *)sf_getTmpPath{
    return NSTemporaryDirectory();
}

- (NSString *)sf_getBlunleFilePath:(NSString *_Nonnull)fileName type:(NSString *_Nullable)type{
    return [self getBundleFilePath:fileName type:type];
}

- (BOOL)sf_copyBundleFile:(NSString *_Nonnull)file toPath:(NSString *_Nonnull)path{
    NSString *exist = [path stringByAppendingPathComponent:file];
    NSString *bundleStr = [self sf_getBlunleFilePath:file type:nil];
    if (!bundleStr) {
        return NO;
    }
    if(![self sf_fileExist:exist]){
        NSError *error;
        return [[NSFileManager defaultManager] copyItemAtPath:bundleStr toPath:exist error:&error];
    }
    return YES;
}

- (BOOL)sf_fileExist:(NSString *_Nullable)path{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (BOOL)sf_copyFilePath:(NSString *_Nonnull)filePath toPath:(NSString *_Nonnull)toPath{
    BOOL isfileName = NO;
    if ([[self returnFileNameFromPath:filePath] isEqualToString:[self returnFileNameFromPath:toPath]]) {
        isfileName = YES;
    }
    NSString *finalPath = isfileName ? toPath : [toPath stringByAppendingPathComponent:[self returnFileNameFromPath:filePath]];
    if (![self sf_fileExist:filePath]) {
        // 文件不存在
        return NO;
    }
    if (![self sf_fileExist:finalPath]) {
        NSError *error;
        return [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:finalPath error:&error];
    }
    return YES;
}

- (BOOL)sf_deleteFileWithPath:(NSString *_Nullable)filePath{
    if (![self sf_fileExist:filePath]) {
        // 文件不存在
        return YES;
    }
    NSError *error;
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
}

- (BOOL)sf_createDocumentBy:(NSString *_Nonnull)docName path:(NSString *_Nonnull)path{
    NSString *finalPath = [[self returnFileNameFromPath:path] isEqualToString:docName] ? path : [path stringByAppendingPathComponent:docName];
    if (!finalPath) {
        // 参数错误
        return NO;
    }
    if (![self sf_fileExist:finalPath]) {
        return [[NSFileManager defaultManager] createDirectoryAtPath:finalPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

- (BOOL)sf_deleteDocumentWithPath:(NSString *_Nullable)path{
    if (![self sf_fileExist:path]) {
        // 传入参数有误
        return YES;
    }
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (NSArray *_Nullable)sf_getAllFilesInPath:(NSString *_Nullable)path{
    if (!path || ![self sf_fileExist:path]) {
        // 路径错误
        return nil;
    }
    return [[NSArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil]];
}

- (BOOL)sf_deleteAllFilesInPath:(NSString *_Nullable)path{
    if (![self sf_fileExist:path]) {
        // 路径出错
        return NO;
    }
    NSArray *arr = [self sf_getAllFilesInPath:path];
    if (arr.count) {
        for (NSString *str in arr) {
            [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:str] error:nil];
        }
    }
    return YES;
}

- (void)sf_removeFilesWithExtension:(NSString *_Nullable)extension atPath:(NSString *_Nullable)path{
    if (!path || !extension || ![self sf_fileExist:path]) {
        // 参数错误
        return;
    }
    NSArray *files = [self sf_getAllFilesInPath:path];
    NSFileManager *m = [NSFileManager defaultManager];
    [files enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj pathExtension] isEqualToString:extension]) {
            [m removeItemAtPath:[path stringByAppendingPathComponent:obj] error:nil];
        }
    }];
}

- (void)sf_asyncReadDataAtPath:(NSString *_Nullable)path callBack:(void(^_Nullable)(NSData *_Nullable data))callBack{
    if (!path || ![self sf_fileExist:path]) {
        // 参数错误
        callBack(nil);
    }
    dispatch_async(dispatch_queue_create("async.read.file", DISPATCH_QUEUE_CONCURRENT), ^{
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        callBack(data);
    });
}

- (void)sf_writeDictionary:(NSDictionary __kindof* _Nullable)dict toPath:(NSString *_Nullable)path{
    if (!path) {
        // 参数错误
        return;
    }
    if (![self sf_fileExist:path]) {
        // 文件不存在，创建
        if ([self sf_createFile:nil path:path]) {
            
        }else{
            return;
        }
    }
}

- (BOOL)sf_createFile:(NSString *_Nullable)fileName path:(NSString *_Nullable)path{
    if (path && (fileName || [[self returnFileNameFromPath:path] isEqualToString:fileName])) {
        if (![self sf_fileExist:path]) {
            NSString *str = [[self returnFileNameFromPath:path] isEqualToString:fileName] ? path : [path stringByAppendingPathComponent:fileName];
            return [[NSFileManager defaultManager] createFileAtPath:str contents:nil attributes:nil];
        }
        return YES;
    }
    return NO;
}
#pragma mark - private method
- (NSString *)getBundleFilePath:(NSString *_Nonnull)fileName type:(NSString *_Nullable)fileType{
    return [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
}

- (NSString *)returnFileNameFromPath:(NSString *)path{
    NSArray *arr = [path componentsSeparatedByString:@"/"];
    NSString *fileName = [arr.lastObject length] > 0 ? arr.lastObject : ((arr.count > 1) ? arr[arr.count - 2] : nil);
    return fileName;
}
@end
