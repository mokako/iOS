/*
 ViewController.m
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

#import "ViewController.h"
#import "MenuUIView.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@interface ViewController ()<MenuUIViewDelegate>
@property (nonatomic)MenuUIView *menuView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [self initializeView];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initializeView
{
    self.menuView = [[MenuUIView alloc]initWithFrame:CGRectMake(0,20,self.view.bounds.size.width,self.view.bounds.size.height - 20)];
    self.menuView.tag = 200;
    self.menuView.delegate = self;
    [self.view addSubview:self.menuView];
    UIView *rootView = [[UIView alloc]initWithFrame:CGRectMake(0,20,self.view.bounds.size.width,self.view.bounds.size.height - 20)];
    rootView.tag = 100;
    rootView.backgroundColor = RGB(54, 54, 54);
    
    UIView *tab = [[UIView alloc]initWithFrame:CGRectMake(0,0,30,50)];
    tab.backgroundColor = RGBA(200, 200, 200, 0.6);
    tab.tag = 200;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTab:)];
    [tab addGestureRecognizer:tap];
    
    [rootView addSubview:tab];
    [self.view addSubview:rootView];
    
    
}


-(void)receiveTableRow:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if(indexPath.row == 3){
            [self slideTab:-100.0];
        }
    }else if(indexPath.section == 2){
        if(indexPath.row == 3){
            [self slideTab:-200.0];
        }else if(indexPath.row == 4){
            [self slideTab:0.0];
        }
    }else{
        if(indexPath.row == 3){
            [self slideTab:-100.0];
        }
    }
}


-(void)tapTab:(UIView *)sender
{
    [UIView animateWithDuration:0.2f
                     animations:^{
                         UIView *view = [self.view viewWithTag:100];
                         if(view.frame.origin.x == 0){
                             view.frame = CGRectMake(100,20,view.bounds.size.width, view.bounds.size.height);
                         }else if(view.frame.origin.x == 100){
                             view.frame = CGRectMake(0,20,view.bounds.size.width, view.bounds.size.height);
                         }

                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)slideTab:(CGFloat)position
{
    [UIView animateWithDuration:0.2f
                     animations:^{
                         UIView *view = [self.view viewWithTag:200];
                         view.frame = CGRectMake(position,20,view.bounds.size.width, view.bounds.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}

@end
