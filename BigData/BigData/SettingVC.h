//
//  SettingVC.h
//  BigData
//
//  Created by midoks on 2017/1/9.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SettingVC : NSDocument <NSTableViewDataSource, NSTableViewDelegate, NSPathControlDelegate, NSTextFieldDelegate>{
    
    IBOutlet NSTableView *_tableView;
    NSMutableArray *_list;
    
    IBOutlet NSPathControl *startPath;
    IBOutlet NSPathControl *stopPath;
    IBOutlet NSPathControl *restartPath;
}

@end
