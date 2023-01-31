//
//  ViewController.m
//  IDCard
//
//  Created by Loyalwind on 2021/11/21.
//

#import "ViewController.h"
#import "WJScanIDCardManager.h"
#import "UIImage+WJExtension.h"

@interface ViewController ()
@property(nonatomic, weak) IBOutlet UILabel *nameLabel;
@property(nonatomic, weak) IBOutlet UILabel *genderLabel;
@property(nonatomic, weak) IBOutlet UILabel *nationLabel;
@property(nonatomic, weak) IBOutlet UILabel *birthLabel;
@property(nonatomic, weak) IBOutlet UILabel *addressLabel;
@property(nonatomic, weak) IBOutlet UILabel *codeLabel;
@property(nonatomic, weak) IBOutlet UILabel *issueLabel; //签发机关;
@property(nonatomic, weak) IBOutlet UILabel *validLabel;
@property(nonatomic, weak) IBOutlet UIImageView *frontImageView;
@property(nonatomic, weak) IBOutlet UIImageView *backImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor cyanColor];
    btn.frame = CGRectMake(100, 100, 100, 30);
    [btn addTarget:self action:@selector(goToScanRecgniseIdCard:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"扫描身份证" forState:UIControlStateNormal];
    [self.view addSubview:btn];
}
- (BOOL)prefersStatusBarHidden { return NO; }
- (BOOL)shouldAutorotate { return YES;}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (void)goToScanRecgniseIdCard:(id)sender{
    // 附带授权码的 初始化方法
    __weak __typeof(ViewController *)weakSelf = self;
    [[WJScanIDCardManager sharedManager] startScanIDCardWithCompeletion:^(WJIDInfo *idInfo) {
        if (!idInfo)return;
        [weakSelf updateIDInfo:idInfo];
    }];
}

- (void)updateIDInfo:(WJIDInfo *)idInfo {
    if (idInfo.type == WJIDInfoTypeBack) {
        [self updateBackIDInfo:idInfo];
    } else {
        [self updateFrontIDInfo:idInfo];
    }
}
- (void)updateFrontIDInfo:(WJIDInfo *)idInfo {
    NSString *code = idInfo.code;
    self.codeLabel.text = [NSString stringWithFormat:@"身份证:%@", code];
    [self.codeLabel sizeToFit];
    
    NSString *name = idInfo.name;
    self.nameLabel.text = [NSString stringWithFormat:@"名字:%@", name];
    [self.nameLabel sizeToFit];
    
    NSString *gender = idInfo.gender;
    self.genderLabel.text = [NSString stringWithFormat:@"性别:%@", gender];
    [self.genderLabel sizeToFit];
    
    NSString *nation = idInfo.nation;
    self.nationLabel.text = [NSString stringWithFormat:@"民族:%@", nation];
    [self.nationLabel sizeToFit];
    
    NSString *birth = idInfo.birth;
    self.birthLabel.text = [NSString stringWithFormat:@"出生:%@", birth];
    [self.birthLabel sizeToFit];
    
    NSString *address = idInfo.address;
    self.addressLabel.text = [NSString stringWithFormat:@"住址:%@", address];
    [self.addressLabel sizeToFit];
    
    UIImage *btnImage = [UIImage image:idInfo.curImage rotation:-90];
    self.frontImageView.image = btnImage;
}

- (void)updateBackIDInfo:(WJIDInfo *)idInfo {
    NSString *issue = idInfo.issue;
    self.issueLabel.text = [NSString stringWithFormat:@"签发机关:%@", issue];
    [self.issueLabel sizeToFit];
    
    NSString *valid = idInfo.valid;
    self.validLabel.text = [NSString stringWithFormat:@"有效期限:%@", valid];
    [self.validLabel sizeToFit];
    
    UIImage *btnImage = [UIImage image:idInfo.curImage rotation:-90];
    self.backImageView.image = btnImage;
}
@end
