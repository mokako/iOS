/*
 MenuUIView.h
 MenuWindow
 
 Created by moca on 2014/02/10.
 Copyright (c) 2014年 mokako. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
 
 
 THIS SOFTWARE IS PROVIDED BY THE AUTHOR(S) ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE AUTHOR(S) BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "MenuUIView.h"

@implementation MenuUIView

-(id)init
{
    self = [super init];
    if(self)
    {
        ary0 = [[NSArray alloc]initWithObjects:@"Menu",@"Block",@"JOKER",@"NEXT", nil];
        ary1 = [[NSArray alloc]initWithObjects:@"SubMenu",@"TEXT",@"JOKER",@"NEXT",@"BACK", nil];
        ary2 = [[NSArray alloc]initWithObjects:@"SubMenu",@"Block",@"IMAGE",@"BACK", nil];
        [self initializeTableView];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ary0 = [[NSArray alloc]initWithObjects:@"Menu",@"LINK",@"MUSIC",@"NEXT", nil];
        ary1 = [[NSArray alloc]initWithObjects:@"SubMenu",@"TEXT",@"RESULT",@"NEXT",@"BACK", nil];
        ary2 = [[NSArray alloc]initWithObjects:@"SubMenu",@"TEXT",@"IMAGE",@"BACK", nil];
        [self initializeTableView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)initializeTableView
{
    //３個のtableViewを作成します。
    NSLog(@"ok");
    UITableView *a = [self createTable:CGRectMake(0,0,100,self.frame.size.height) tag:1];
    UITableView *b = [self createTable:CGRectMake(100,0,100,self.frame.size.height) tag:2];
    UITableView *c = [self createTable:CGRectMake(200,0,100,self.frame.size.height) tag:3];
    
    [self addSubview:a];
    [self addSubview:b];
    [self addSubview:c];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag == 1)
    {
        return  ary0.count;
    }else if(tableView.tag == 2){
        return ary1.count;
    }else if (tableView.tag == 3){
        return ary2.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:@"identifier"];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13.0];
            NSLog(@"%ld",(long)indexPath.row);
            if(tableView.tag == 1)
            {
                cell.textLabel.text = [ary0 objectAtIndex:indexPath.row];
            }else if(tableView.tag == 2){
                cell.textLabel.text = [ary1 objectAtIndex:indexPath.row];
            }else{
                cell.textLabel.text = [ary2 objectAtIndex:indexPath.row];
            }
        }
    return cell;
}

-(UITableView *)createTable:(CGRect)rect tag:(NSInteger)tag
{
    UITableView *table = [[UITableView alloc] initWithFrame:rect  style:UITableViewStylePlain];
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.tag = tag;
    table.rowHeight = 50.0;
    table.showsVerticalScrollIndicator = NO;
    return table;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:tableView.tag];
    [self.delegate receiveTableRow:selectedIndexPath];
}

@end
