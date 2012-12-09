//
// Created by jcoenradie on 12/9/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SelectTableViewController.h"


@implementation SelectTableViewController {
    UITextField *tableTextField;
}
@synthesize selectedTable;
@synthesize tableSelected;

- (id)init {
    self = [super init];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 150, 25)];
        label.text = @"Kies een tafel";
        [self.view addSubview:label];
        tableTextField = [[UITextField alloc] initWithFrame:CGRectMake(160, 50, 40, 25)];
        [tableTextField becomeFirstResponder];
        [tableTextField setKeyboardType:UIKeyboardTypeNumberPad];
        tableTextField.borderStyle = UITextBorderStyleRoundedRect;
        tableTextField.text = selectedTable;

        [self.view addSubview:tableTextField];
        UIButton *chooseTableBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [chooseTableBtn setFrame:CGRectMake(220, 40, 80, 30)];
        [chooseTableBtn setTitle:@"Kies" forState:UIControlStateNormal];
        [chooseTableBtn addTarget:self action:@selector(closeModal:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:chooseTableBtn];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)closeModal:(id)sender {
    NSString *table = tableTextField.text;
    tableSelected(table);

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end