//
//  AppDelegate.m
//  BigData
//
//  Created by midoks on 2017/1/7.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [self setBarStatus];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}


#pragma mark NSPathControlDelegate
- (IBAction)openCellDir:(id)sender
{
    NSLog(@"dddd");
//    NSURL *pathstring = [[_serverPath clickedPathComponentCell] URL];
//    NSString *dir = [[pathstring absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
//    [[NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:[NSArray arrayWithObjects:dir, nil]] waitUntilExit];
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

#pragma mark - 显示主界面 -
- (IBAction)showMain:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:sender];
}



@end
