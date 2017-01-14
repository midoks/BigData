//
//  ProjectModel.h
//  BigData
//
//  Created by midoks on 2017/1/14.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectModel : NSObject

@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, strong) NSString *startPath;
@property (nonatomic, strong) NSString *stopPath;
@property (nonatomic, strong) NSString *restartPath;


-(NSMutableDictionary *)setWithName:(NSString *)projectName
                          startPath:(NSString *)startPath
                           stopPath:(NSString *)stopPath
                        restartPath:(NSString *)restartPath;

@end
