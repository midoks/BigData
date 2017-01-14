//
//  AppDelegate.m
//  BigData
//
//  Created by midoks on 2017/1/7.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "AppDelegate.h"
#import "NSCommon.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate




#pragma mark - 程序加载 start -
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [self setBarStatus];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}
#pragma mark - 程序加载 end -


#pragma mark - 调试 -
- (IBAction)bgDebugAction:(id)sender {
    NSString *rootDir   = [NSCommon getRootDir];
    NSString *debug = [NSString stringWithFormat:@"%@scripts/debug.sh", rootDir];
    [[NSTask launchedTaskWithLaunchPath:@"/bin/sh" arguments:[NSArray arrayWithObjects:@"-c", debug, nil]] waitUntilExit];
}

#pragma mark - 显示主界面 -
- (IBAction)showMain:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:sender];
}

#pragma mark - 设置状态栏 -
-(void)setBarStatus
{
    statusBarItem = [[NSStatusBar systemStatusBar] statusItemWithLength:23.0];
    statusBarItem.image = [NSImage imageNamed:@"bigdata.png"];
    statusBarItem.alternateImage = [NSImage imageNamed:@"bigdata.png"];
    statusBarItem.menu = statusBarItemMenu;
    [statusBarItem setHighlightMode:YES];
}

@end
