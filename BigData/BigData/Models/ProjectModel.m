//
//  ProjectModel.m
//  BigData
//
//  Created by midoks on 2017/1/14.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "ProjectModel.h"

@implementation ProjectModel

-(id)init
{
    if (self = [super init]) {
        _projectName    = @"p0";
        _startPath      = @"start.sh";
        _stopPath       = @"stop.sh";
        _restartPath    = @"restart.sh";
    }
    return self;
}


-(NSMutableDictionary *)setWithName:(NSString *)projectName
          startPath:(NSString *)startPath
           stopPath:(NSString *)stopPath
        restartPath:(NSString *)restartPath
{
    
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [info setObject:projectName forKey:@"projectName"];
    [info setObject:startPath forKey:@"startPath"];
    [info setObject:stopPath forKey:@"stopPath"];
    [info setObject:restartPath forKey:@"restartPath"];
    return info;
}


@end
