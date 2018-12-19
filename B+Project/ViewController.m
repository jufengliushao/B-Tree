//
//  ViewController.m
//  B+Project
//
//  Created by shaofeng liu on 2018/12/16.
//  Copyright © 2018年 shaofeng liu. All rights reserved.
//

#import "ViewController.h"
#import "FileWriteReadManager.h"
#import "BAddTreeManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[FileWriteReadManager shareInsatance] createFile];
    NSArray *arr = [[FileWriteReadManager shareInsatance] readData:11];
    for (LeafModel *leaf in arr) {
        [[BAddTreeManager shareInsatance] insertNode:leaf];
    }
    ResultModel *m = [[BAddTreeManager shareInsatance] searchNodeWithIndex:5];
    NSLog(@"");
    // Do any additional setup after loading the view, typically from a nib.
}



@end
