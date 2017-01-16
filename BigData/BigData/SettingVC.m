//
//  SettingVC.m
//  BigData
//
//  Created by midoks on 2017/1/9.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "SettingVC.h"
#import "NSCommon.h"
#import "ProjectModel.h"


# define judgeSelected() \
NSInteger row = [_tableView selectedRow]; \
if (row == -1) { \
[NSCommon alert:@"选择项目" delayedClose:1]; \
[_tableView selectRowIndexes:[[NSIndexSet alloc] initWithIndex:0] byExtendingSelection:YES]; \
return; \
}

@interface SettingVC() <NSUserNotificationCenterDelegate,NSTextFieldDelegate>
@end

@implementation SettingVC

- (id)init
{
    if (self = [super init]) {
        
        [_tableView setGridColor:[NSColor blackColor]];
        [_tableView setRowSizeStyle:NSTableViewRowSizeStyleLarge];
        [_tableView setGridStyleMask:(NSTableViewSolidHorizontalGridLineMask | NSTableViewSolidVerticalGridLineMask)];
        [[_tableView cell] setLineBreakMode:NSLineBreakByTruncatingTail];
        [[_tableView cell] setTruncatesLastVisibleLine:YES];
        [_tableView setColumnAutoresizingStyle:NSTableViewSequentialColumnAutoresizingStyle];
        [_tableView setUsesAlternatingRowBackgroundColors:YES];
        [_tableView.headerView setHidden:YES];//使用隐藏的效果会出现表头的高度
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //plist操作
        [self reloadListData];
    }
    
    [NSCommon delayedRun:0.2 callback:^{
        if ([_list count] > 0){
            [_tableView selectRowIndexes:[[NSIndexSet alloc] initWithIndex:0] byExtendingSelection:YES];
        }
    }];
    
    return  self;
}

-(void)reloadListData
{
    _list = [[NSMutableArray alloc] init];
    
    NSString *pplist = [[NSBundle mainBundle] pathForResource:@"common" ofType:@"plist"];
    NSMutableDictionary *listContent = [[NSMutableDictionary alloc] initWithContentsOfFile:pplist];
    
    for (NSInteger i=0; i<[listContent count]; i++) {
        NSString *pos = [NSString stringWithFormat:@"%ld", i];
        NSMutableDictionary *t = [listContent objectForKey:pos];
        [_list addObject:t];
    }
    
    [_tableView reloadData];
}

-(void)savePlist
{
    NSString *pathplist = [[NSBundle mainBundle] pathForResource:@"common" ofType:@"plist"];
    NSMutableDictionary *dictplist  = [[NSMutableDictionary alloc] init];
    NSUInteger c = 0;
    for (NSDictionary *i in _list)
    {
        NSMutableDictionary *serverinfo = [[NSMutableDictionary alloc] init];
        [serverinfo setObject:[i objectForKey:@"projectName"] forKey:@"projectName"];
        [serverinfo setObject:[i objectForKey:@"startPath"] forKey:@"startPath"];
        [serverinfo setObject:[i objectForKey:@"stopPath"] forKey:@"stopPath"];
        [serverinfo setObject:[i objectForKey:@"restartPath"] forKey:@"restartPath"];
        [dictplist setObject:serverinfo forKey:[NSString stringWithFormat:@"%ld", c]];
        ++c;
    }
    [dictplist writeToFile:pathplist atomically:YES];
}


- (IBAction)openCellDir:(id)sender
{
    NSPathControl *clickPath = (NSPathControl *)sender;
    NSURL *pathstring = [[clickPath clickedPathComponentCell] URL];
    NSString *dir = [[pathstring absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    [[NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:[NSArray arrayWithObjects:dir, nil]] waitUntilExit];
}

- (IBAction)openActionFile:(id)sender {
    judgeSelected();
    
    NSButton *goBtn = (NSButton *)sender;
    NSString *pathStr = @"";
    
    if(goBtn.tag == 0){
        pathStr = [[startPath URL] absoluteString];
    } else if (goBtn.tag == 1){
        pathStr = [[stopPath URL] absoluteString];
    } else {
        pathStr = [[restartPath URL] absoluteString];
    }
    NSString *dir = [pathStr stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    [[NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:[NSArray arrayWithObjects:dir, nil]] waitUntilExit];
}

- (IBAction)selectDir:(id)sender {
    
    judgeSelected();
    
    NSButton *selectBtn = (NSButton *)sender;
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setPrompt: @"choose"];
    [panel setCanChooseDirectories:YES];    //可以打开目录
    [panel setCanChooseFiles:YES];          //能选择文件
    
    [panel beginSheetModalForWindow:[self windowForSheet] completionHandler:^(NSInteger result) {
        
        NSString *path = [[[panel URL] absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        if (selectBtn.tag == 0){
            [startPath setURL:[panel URL]];
            [[_list objectAtIndex:row] setObject:path forKey:@"startPath"];
        } else if (selectBtn.tag == 1) {
            [stopPath setURL:[panel URL]];
            [[_list objectAtIndex:row] setObject:path forKey:@"stopPath"];
        } else if (selectBtn.tag == 2) {
            [restartPath setURL:[panel URL]];
            [[_list objectAtIndex:row] setObject:path forKey:@"restartPath"];
        } else {
            [restartPath setURL:[panel URL]];
            [[_list objectAtIndex:row] setObject:path forKey:@"restartPath"];
        }
        
        [self savePlist];
        [_tableView reloadData];
        
        [_tableView selectRowIndexes:[[NSIndexSet alloc] initWithIndex:row] byExtendingSelection:YES];
    }];
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectTableColumn:(NSTableColumn *)tableColumn
{
    return YES;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [_list count];
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSMutableDictionary *v = [_list objectAtIndex:row];
    
    NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    [cell.textField setStringValue:[v objectForKey:@"projectName"]];
    [cell.textField setEditable:NO];
    [cell.textField setDrawsBackground:NO];
    
    return cell;
}

#pragma mark - 选择触动 -
-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger row = [_tableView selectedRow];
    if (row > -1) {
        
        NSString *_startPath = [NSString stringWithFormat:@"file://%@", [[_list objectAtIndex:row] objectForKey:@"startPath"]];
        [startPath setURL:[NSURL URLWithString:_startPath]];
        
        NSString *_stopPath = [NSString stringWithFormat:@"file://%@", [[_list objectAtIndex:row] objectForKey:@"stopPath"]];
        [stopPath setURL:[NSURL URLWithString:_stopPath]];
        
        NSString *_restartPath = [NSString stringWithFormat:@"file://%@", [[_list objectAtIndex:row] objectForKey:@"restartPath"]];
        [restartPath setURL:[NSURL URLWithString:_restartPath]];
        
        [pName setStringValue:[[_list objectAtIndex:row] objectForKey:@"projectName"]];
    } else {
        NSString *rPath = [NSCommon getRootDir];
        NSString *_startPath    = [NSString stringWithFormat:@"%@scripts/start.sh", rPath];
        _startPath = [NSString stringWithFormat:@"file://%@", _startPath];
        NSString *_stopPath     = [NSString stringWithFormat:@"%@scripts/stop.sh", rPath];
        _stopPath = [NSString stringWithFormat:@"file://%@", _stopPath];
        NSString *_restartPath  = [NSString stringWithFormat:@"%@scripts/restart.sh", rPath];
        _restartPath = [NSString stringWithFormat:@"file://%@", _restartPath];
        
        [startPath setURL:[NSURL URLWithString:_startPath]];
        [stopPath setURL:[NSURL URLWithString:_stopPath]];
        [restartPath setURL:[NSURL URLWithString:_restartPath]];
        
        [pName setStringValue:@"未设置"];
    }
    
    [pName setSelectable:YES];
    [pName setEditable:YES];
}


#pragma mark - 用户通知 -
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

-(void)userCenter:(NSString *)content
{
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    for (NSUserNotification *notify in [[NSUserNotificationCenter defaultUserNotificationCenter] scheduledNotifications])
    {
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification:notify];
    }
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"通知中心";
    notification.informativeText = content;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:notification];
}

- (IBAction)modPname:(id)sender
{
    judgeSelected();

    if (row > -1) {
        
        NSString *pNameValue = pName.stringValue;
        if ([pNameValue isEqualToString:@""]){
            [NSCommon alert:@"不能为空" delayedClose:1];
        } else {
            [[_list objectAtIndex:row] setObject:pNameValue forKey:@"projectName"];
            [pName setSelectable:NO];
        }
        
        [self savePlist];
        [_tableView reloadData];
    }
}

#pragma mark - 添加项目 -
- (IBAction)add:(id)sender {
    
    NSString *rPath = [NSCommon getRootDir];
    NSString *projectName   = [NSString stringWithFormat:@"PN%lu", (unsigned long)[_list count]+1];
    NSString *_startPath    = [NSString stringWithFormat:@"%@scripts/start.sh", rPath];
    NSString *_stopPath     = [NSString stringWithFormat:@"%@scripts/stop.sh", rPath];
    NSString *_restartPath  = [NSString stringWithFormat:@"%@scripts/restart.sh", rPath];
    
    
    [_list addObject:[[ProjectModel alloc]  setWithName:projectName
                                              startPath:_startPath
                                               stopPath:_stopPath
                                            restartPath:_restartPath]];
    
    [self savePlist];
    [_tableView reloadData];
    
    [_tableView selectRowIndexes:[[NSIndexSet alloc] initWithIndex:[_list count]-1] byExtendingSelection:YES];
    NSString *msg = [NSString stringWithFormat:@"添加%@服务成功!", projectName];
    [self userCenter:msg];
    
}

#pragma mark - 删除项目 -
- (IBAction)delete:(id)sender {
    
    NSInteger row = [_tableView selectedRow];
    if (row > -1) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"删除设置"];
        [alert setInformativeText:@"你是否确认删除有设置路径的配置"];
        [alert addButtonWithTitle:@"确定"];
        [alert addButtonWithTitle:@"取消"];
        [alert setAlertStyle:NSAlertStyleInformational];
        NSModalResponse r = [alert runModal];
        
        if (r != 1000) {
            return;
        }
        
        NSString *projectName = [[_list objectAtIndex:row] objectForKey:@"projectName"];
        NSString *msg = [NSString stringWithFormat:@"删除%@服务成功!", projectName];
        
        [_list removeObjectAtIndex:row];
        [self savePlist];
        [_tableView reloadData];
        [self userCenter:msg];
    }
    
    if ([_list count] > 0){
        [_tableView selectRowIndexes:[[NSIndexSet alloc] initWithIndex:0] byExtendingSelection:YES];
    }
}

#pragma mark - 启动服务 -
- (IBAction)start:(id)sender {
    judgeSelected();
    
    NSMutableDictionary *list = [_list objectAtIndex:row];
    if ( [startStatus.stringValue isEqualToString:@"start"] ){
    
        
        NSString *startPathFile = [list objectForKey:@"startPath"];
        
        [[NSTask launchedTaskWithLaunchPath:@"/bin/sh" arguments:[NSArray arrayWithObjects:@"-c", startPathFile, nil]] waitUntilExit];
        
        [startStatus setStringValue:@"stop"];
    } else if ([startStatus.stringValue isEqualToString:@"stop"]) {
        
        NSString *startPathFile = [list objectForKey:@"stopPath"];
        [[NSTask launchedTaskWithLaunchPath:@"/bin/sh" arguments:[NSArray arrayWithObjects:@"-c", startPathFile, nil]] waitUntilExit];
        
        [startStatus setStringValue:@"start"];
    }
    
    
}

- (IBAction)reStart:(id)sender {
    judgeSelected();
    
    NSLog(@"%@", @"restart");
}



@end
