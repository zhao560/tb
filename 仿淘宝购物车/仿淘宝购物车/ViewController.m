//
//  ViewController.m
//  仿淘宝购物车
//
//  Created by 凉凉 on 2017/3/23.
//  Copyright © 2017年 凉凉. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
// 背景view
@property (nonatomic, strong) UIView *backView;
// 截取的当前屏幕
@property (nonatomic, strong) UIImageView *tempimgView;
// 遮罩层
@property (nonatomic, strong) UIView *maskView;
// 弹出的视图
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 个",indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 背景view
    self.backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    // 截取当前屏幕的img
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, [UIScreen mainScreen].scale);
    [self.view.window drawViewHierarchyInRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) afterScreenUpdates:NO];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 截取的屏幕
    self.tempimgView = [[UIImageView alloc]initWithFrame:self.backView.bounds];
    self.tempimgView.image = img;
    [self.backView addSubview:self.tempimgView];
    // 遮罩层
    self.maskView = [[UIView alloc]initWithFrame:self.backView.bounds];
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchMaskView)]];
    [self.backView addSubview:self.maskView];
    
    // 弹出的view
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height,  [UIScreen mainScreen].bounds.size.width, 200)];
    self.bottomView.backgroundColor = [UIColor redColor];
    [self.backView addSubview:self.bottomView];
    
    // 动画
    [UIView animateWithDuration: 0.35 animations: ^{
        self.tempimgView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
        CGRect frame = self.tempimgView.frame;
        frame.origin.y = 10;
        self.tempimgView.frame = frame;
        self.bottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width, 200);
    } completion: nil];
}

-(void)didTouchMaskView {
    [UIView animateWithDuration: 0.35 animations: ^{
        self.tempimgView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
        CGRect frame = self.tempimgView.frame;
        frame.origin.y = 0;
        self.tempimgView.frame = frame;
        self.bottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height,  [UIScreen mainScreen].bounds.size.width, 200);
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
