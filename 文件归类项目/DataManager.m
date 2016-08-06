//
//  DataManager.m
//  文件归类项目
//
//  Created by Jack.Boy on 15/6/18.
//  Copyright (c) 2015年 RL. All rights reserved.
//

#import "DataManager.h"

/*
    这个类用作存储数据
*/

static DataManager * manager = nil;
@implementation DataManager

+(DataManager *)sharedDataManager
{
    if(manager == nil){
        manager = [[DataManager alloc] init];
        
        // 存储数据
        manager.filePathArr = [[NSMutableArray alloc] init];
        manager.fileArr = [[NSMutableArray alloc] init];
    }
    return manager;
}

@end
