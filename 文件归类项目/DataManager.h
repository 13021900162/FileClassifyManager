//
//  DataManager.h
//  文件归类项目
//
//  Created by Jack.Boy on 15/6/18.
//  Copyright (c) 2015年 RL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property (nonatomic, retain) NSMutableArray * filePathArr; //文件路径数组
@property (nonatomic, retain) NSMutableArray * fileArr;//文件名称数组

+(DataManager *)sharedDataManager;

@end
