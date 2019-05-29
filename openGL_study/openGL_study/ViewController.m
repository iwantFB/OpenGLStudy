//
//  ViewController.m
//  openGL_study
//
//  Created by 胡斐 on 2019/5/28.
//  Copyright © 2019 jackson. All rights reserved.
//

/**
 
 声明: 该部分内容很大程度是参考 落影loyinglin 前辈的入门教程，是自己学习OpenGL ES的一个过程。
 在此感谢 落影loyinglin 提供的精彩教程。他的简书地址为 https://www.jianshu.com/u/815d10a4bdce
 除此之外，也会在注释上加上自己的理解和扩展。
 
 */

#import "ViewController.h"
#import "HFLesson1ViewController.h"

const NSString *titleKey = @"titleKey";
const NSString *actionKey = @"actionKey";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *lessonTableView;
@property (nonatomic, copy) NSArray *titleActionArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupUI];
}

#pragma mark- action
- (void)lesson1Action
{
    HFLesson1ViewController *lessonVC = [[HFLesson1ViewController alloc] init];
    [self.navigationController pushViewController:lessonVC animated:YES];
}

#pragma mark- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleActionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    NSDictionary *actionTitleDic = self.titleActionArr[indexPath.row];
    cell.textLabel.text = actionTitleDic[titleKey];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *actionTitleDic = self.titleActionArr[indexPath.row];
    SEL action = NSSelectorFromString(actionTitleDic[actionKey]);
    if([self respondsToSelector:action]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:action];
#pragma clang diagnostic pop
    }
}

#pragma mark- private method
- (void)_setupUI
{
    [self.view addSubview:self.lessonTableView];
}

#pragma mark- setter/getter
- (UITableView *)lessonTableView
{
    if(!_lessonTableView){
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _lessonTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) style:UITableViewStylePlain];
        _lessonTableView.rowHeight = 44;
        _lessonTableView.delegate = self;
        _lessonTableView.dataSource = self;
        [_lessonTableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"CELL"];
        _lessonTableView.tableFooterView = [UIView new];
    }
    return _lessonTableView;
}

- (NSArray *)titleActionArr
{
    return @[
             @{
                 titleKey : @"lesson1",
                 actionKey : NSStringFromSelector(@selector(lesson1Action))
                 }
             ];
}

@end
