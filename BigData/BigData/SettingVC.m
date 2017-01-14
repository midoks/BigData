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

@interface SettingVC() <NSUserNotificationCenterDelegate>
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
        [_tableView setUsesAlternatingRowBackgroundColors:NO];
        [_tableView.headerView setHidden:YES];//使用隐藏的效果会出现表头的高度
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //plist操作
        [self reloadListData];
    }
    
    
    
    //startPath = [NSString stringWithFormat:@"file://%@", @"/Users/midoks"];
    return  self;
}

-(void)reloadListData
{
    _list = [[NSMutableArray alloc] init];
    //NSString *rPath = [NSCommon getRootDir];
    NSString *pplist = [[NSBundle mainBundle] pathForResource:@"common" ofType:@"plist"];
    NSMutableDictionary *listContent = [[NSMutableDictionary alloc] initWithContentsOfFile:pplist];
    
    for (NSInteger i=0; i<[listContent count]; i++) {
        NSString *pos = [NSString stringWithFormat:@"%ld", i];
        NSMutableDictionary *t = [listContent objectForKey:pos];
        
        //        if ([[t objectForKey:@"hostname"] isEqual:@"localhost"])
        //        {
        //            NSString *urlstr = [NSString stringWithFormat:@"%@htdocs/www/", str];
        //            [[listContent objectForKey:pos] setObject:urlstr forKey:@"path"];
        //        }
        [_list addObject:t];
    }
    
    
    NSLog(@"%@", _list);
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
    
    [startPath setURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@", @"/Users/midoks"]]];
    
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setPrompt: @"choose"];
    [panel setCanChooseDirectories:YES];    //可以打开目录
    [panel setCanChooseFiles:YES];          //能选择文件
    
    [panel beginSheetModalForWindow:[self windowForSheet] completionHandler:^(NSInteger result) {
        
        //[startPath setURL:[panel URL]];
        
        
        //
        //        NSInteger row = [_tableView selectedRow];
        //        if (row > -1) {
        //            NSString *path = [[[panel URL] absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        //            [[_list objectAtIndex:row] setObject:path forKey:@"path"];
        //        }
    }];
}


-(BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:
(NSTableColumn *)tableColumn row:(NSInteger)row{
    return YES;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectTableColumn:(NSTableColumn *)tableColumn{
    return YES;
}


-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [_list count];
}

//-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
//
//}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSMutableDictionary *v = [_list objectAtIndex:row];
    
    NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    [cell.textField setStringValue:[v objectForKey:@"projectName"]];
    [cell.textField setEditable:NO];
    [cell.textField setDrawsBackground:NO];
    
    return cell;
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

#pragma mark - 添加项目 -
- (IBAction)add:(id)sender {
    
    NSString *projectName = [NSString stringWithFormat:@"PN%lu", (unsigned long)[_list count]];
    
    [_list addObject:[[ProjectModel alloc]  setWithName:projectName
                                              startPath:@"start.sh"
                                               stopPath:@"stop.sh"
                                            restartPath:@"restart.sh"]];
    
    [self savePlist];
    [_tableView reloadData];
    
    [_tableView selectRowIndexes:[[NSIndexSet alloc] initWithIndex:[_list count]-1] byExtendingSelection:YES];
    [self userCenter:@"add ok"];
    
}

#pragma mark - 删除项目 -
- (IBAction)delete:(id)sender {
    
    NSInteger row = [_tableView selectedRow];
    if (row != -1) {
        
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
        
        [self savePlist];
        [_list removeObjectAtIndex:row];
        [_tableView reloadData];
        
        [self userCenter:@"delete"];
    }
    
    if ([_list count] > 0){
        [_tableView selectRowIndexes:[[NSIndexSet alloc] initWithIndex:0] byExtendingSelection:YES];
    }
}

@end
