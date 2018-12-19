//
//  SFFileManager.h
//  SFDBFileManager
//
//  Created by cnlive-lsf on 2017/3/16.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFFileManager : NSObject
/**
 init method
 单利初始化方法
 @return instancetype
 */
+(instancetype _Nonnull)shareInstance;

/**
 return home path
 返回沙盒主目录
 @return NSString
 */
- (NSString *_Nonnull)sf_getHomeDirectoryPath;

/**
 return documents path
 返回documents路径

 @return NSString
 */
- (NSString *_Nonnull)sf_getDocumentsPath;

/**
 return Library path
 返回Liarary路径
 @return NSString
 */
- (NSString *_Nonnull)sf_getLibraryPath;

/**
 return Caches path
 返回Caches路径
 @return NSString
 */
- (NSString *_Nonnull)sf_getCachePath;

/**
 return Tmp path
 返回tmp路径
 @return NSString
 */
- (NSString *_Nonnull)sf_getTmpPath;

/**
 return blunle file path

 @param fileName file name
 @param type file type
 @return NSString
 */
- (NSString *_Nonnull)sf_getBlunleFilePath:(NSString *_Nonnull)fileName type:(NSString *_Nullable)type;

/**
 copy bundle file to path
 拷贝bundle文件到指定路径
 @param file 文件名称和类型
 @param path 指定目录
 @return YES 完成 NO失败
 */
- (BOOL)sf_copyBundleFile:(NSString *_Nonnull)file toPath:(NSString *_Nonnull)path;

/**
 the file is extise in this path

 @param path <#path description#>
 @return <#return value description#>
 */
- (BOOL)sf_fileExist:(NSString *_Nullable)path;

/**
 copy file from path1 to path2

 @param filePath path1
 @param toPath path2
 @return YES 完成 NO失败
 */
- (BOOL)sf_copyFilePath:(NSString *_Nonnull)filePath toPath:(NSString *_Nonnull)toPath;

/**
 delete file with path

 @param filePath file Path
 @return YES 完成 NO失败
 */
- (BOOL)sf_deleteFileWithPath:(NSString *_Nullable)filePath;

/**
 create doc at path

 @param docName doc-name
 @param path path
 @return YES 完成 NO失败
 */
- (BOOL)sf_createDocumentBy:(NSString *_Nonnull)docName path:(NSString *_Nonnull)path;

/**
 delete doc at path

 @param path doc-path
 @return YES 完成 NO失败
 */
- (BOOL)sf_deleteDocumentWithPath:(NSString *_Nullable)path;

/**
 return all files in path

 @param path doc-path
 @return NSArray
 */
- (NSArray *_Nullable)sf_getAllFilesInPath:(NSString *_Nullable)path;

/**
 delete all files in path

 @param path doc-path
 @return YES 完成 NO失败
 */
- (BOOL)sf_deleteAllFilesInPath:(NSString *_Nullable)path;

/**
 remove file.extension at doc-path

 @param extension extension
 @param path doc-path
 */
- (void)sf_removeFilesWithExtension:(NSString *_Nullable)extension atPath:(NSString *_Nullable)path;

/**
 async-read flies data

 @param path flie-path
 @param callBack read resulet
 */
- (void)sf_asyncReadDataAtPath:(NSString *_Nullable)path callBack:(void(^_Nullable)(NSData *_Nullable data))callBack;

/**
 create file at path

 @param fileName file-name
 @param path doc-path
 @return YES 完成 NO失败
 */
- (BOOL)sf_createFile:(NSString *_Nullable)fileName path:(NSString *_Nullable)path;
@end
