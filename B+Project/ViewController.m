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
#import "MBProgressHUD.h"
@interface ViewController (){
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UITextField *searchtf;
@property (weak, nonatomic) IBOutlet UITextField *insertIndextf;
@property (weak, nonatomic) IBOutlet UITextField *insertAttrtf;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[FileWriteReadManager shareInsatance] createFile];
    NSArray *arr = [[FileWriteReadManager shareInsatance] readData:11];
    for (LeafModel *leaf in arr) {
        [[BAddTreeManager shareInsatance] insertNode:leaf];
    }
    
    NSLog(@"");
    // Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)judgement:(NSString *)msg{
    // account
    NSString *checkString = msg;
    NSString *pattern = @"-?[1-9]\\d*";
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regular matchesInString:checkString options:0 range:NSMakeRange(0, checkString.length)];
    if (results.count == 0) {
        return NO;
    }
    return YES;
}

- (void)showText:(NSString *)text delay:(CGFloat)time{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(text, @"null");
    [hud hideAnimated:YES afterDelay:time];
}

- (void)searchFunction{
    ResultModel *m = [[BAddTreeManager shareInsatance] searchNodeWithIndex:[self.searchtf.text integerValue]];
    NSString *msg = m.isFind ? [NSString stringWithFormat:@"查找成功！%ld-%@", m.result.index, m.result.a_attribute] : [NSString stringWithFormat:@"没有找到：%@", self.searchtf.text];
    [self showText:msg delay:3];
}

- (void)writeNewData{
    LeafModel *newLeaf = [[BAddTreeManager shareInsatance] insertFileNode:[self.insertIndextf.text integerValue] msg:self.insertAttrtf.text];
    [[FileWriteReadManager shareInsatance] writeLeafData:newLeaf];
    [self showText:@"数据插入成功" delay:3];
}


#pragma mark - action

- (IBAction)searchaction:(id)sender {
     // 查询操作
    if (self.searchtf.text.length < 1) {
        [self showText:@"请输入数据" delay:2];
        return;
    }
    if (![self judgement:self.searchtf.text]) {
        [self showText:@"请输入正确的数字" delay:2];
        return;
    }
    [self searchFunction];
}

- (IBAction)insertaction:(id)sender {
    // 插入操作
    if (self.insertIndextf.text.length < 1 || self.insertAttrtf.text.length < 1) {
        [self showText:@"请输入数据" delay:2];
        return;
    }
    if (![self judgement:self.insertIndextf.text]) {
        [self showText:@"请输入正确的数字" delay:2];
        return;
    }
    [self writeNewData];
}

@end
