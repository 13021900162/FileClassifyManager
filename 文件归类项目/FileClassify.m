//
//  FileClassify.m
//  文件归类项目
//
//  Created by Jack.Boy on 15/6/18.
//  Copyright (c) 2015年 RL. All rights reserved.
//

#import "FileClassify.h"
#import "DataManager.h"
/*
    将当前目录下不同的“文件”进行归类！！
 */

#define SOURCE_PATH @"/Users/Mac/Desktop"

@implementation FileClassify

// 入口
+(void)enter
{
    NSLog(@"整理文件的工作 Now Begin");
    [self readDirectory];
}

// 读取文件目录，区分有多少不同的文件格式
+(void)readDirectory
{
    NSFileManager * fm = [NSFileManager defaultManager];
    
    NSError * error = nil;
    if([fm fileExistsAtPath:SOURCE_PATH]){
        // 浅度遍历，只遍历当前目录
        NSArray * fileArr = [fm contentsOfDirectoryAtPath:SOURCE_PATH error:&error];
        if(!error && fileArr.count > 0){
            // 遍历成功
            // 去查看到底有几种类型的文件
            [self praseFile:fileArr];
        }
        else{
            NSLog(@"遍历该文件目录失败，或者该文件目录下没有任何文件");
        }
    }
}

+(void)praseFile:(NSArray *)arr
{
    /*
     (
     ".DS_Store",
     "1402789580862162351.png",
     "2007118192311804_2.jpg",
     "2007119124413448_2.jpg",
     "20100404_09de7a322753654dc6d186gqC78Q8cM8.png",
     "20121101145346_nRx3K.thumb.600_0.gif",
     "20121212161025_YGFjR.gif",
     "300001054794129041580438110_950.jpg",
     "54.png",
     "574e9258d109b3de76576b48cebf6c81800a4c22.jpg",
     "demo.txt",
     "OOOPIC_SHIJUNHONG_20090809ad6104071d324dda.jpg",
     "\U5b66\U751f\U610f\U89c1\U53cd\U9988.rtf"
     )
     */
    
    DataManager * dm = [DataManager sharedDataManager];
    
    for(int i = 0;i < arr.count; i++){
        NSString * fileName = [arr objectAtIndex:i];
        NSRange range = [fileName rangeOfString:@".DS"];
        NSRange range2 = [fileName rangeOfString:@"."];
        if(range.location == NSNotFound && range2.location != NSNotFound){
            // 排除了隐藏文件的可能 “.DS_Store”
            // 拼接初始的文件详细路径
            NSString * filePath = [NSString stringWithFormat:@"%@/%@", SOURCE_PATH, fileName];
            // 此时所有的文件的具体路径都存了下来
            [dm.filePathArr addObject:filePath];
            [dm.fileArr addObject:fileName];
        }
    }
    
    // 提高容错 （有可操作的文件，则执行）
    if(dm.fileArr.count > 0){
        [self createFileDirectory];
    }
    else{
        NSLog(@"Good Job，没有需要归类的文件了...");
    }
}

// 创建归类的文件目录
+(void)createFileDirectory
{
    DataManager * dm = [DataManager sharedDataManager];
    NSFileManager * fm = [NSFileManager defaultManager];

    for(int i = 0; i < dm.fileArr.count; i++){
        NSString * fileName = [dm.fileArr objectAtIndex:i];
//        NSLog(@"fileName = %@", fileName);
        // 一定程度上排除了文件名字中包含有‘.’的情况
        
        NSString * sufStr;
        if(fileName.length > 6){
            sufStr = [fileName substringFromIndex:fileName.length - 6];
        }
        else{
            sufStr = fileName;
        }
        
        NSRange range = [sufStr rangeOfString:@"."];
        if(range.location != NSNotFound){
            NSString * dirName = [sufStr substringFromIndex:range.location + 1];
            NSString * dirPath = [NSString stringWithFormat:@"%@/%@", SOURCE_PATH, dirName];
//            NSLog(@"%@", dirPath);
            if(![fm fileExistsAtPath:dirPath]){
                [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            // 移动文件
            NSString * sourcePath = dm.filePathArr[i];
            NSString * desPath = [NSString stringWithFormat:@"%@/%@/%@", SOURCE_PATH, dirName, fileName];
//            NSLog(@"source = %@", sourcePath);
            if([fm fileExistsAtPath:sourcePath]){
                [fm moveItemAtPath:sourcePath toPath:desPath error:nil];
            }
            else{
                NSLog(@"move 失败");
            }
        }
    }
    
    NSLog(@"Well Done,该目录已经整理完毕");
}

@end
