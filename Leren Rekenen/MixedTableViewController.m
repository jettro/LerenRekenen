//
// Created by jcoenradie on 12/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MixedTableViewController.h"


@implementation MixedTableViewController {

}

- (id)init {
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        UILabel *greeting = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 25)];
        greeting.text = @"Oefenen van gemengde tafels.";
        [self.view addSubview:greeting];
    }

    return self;
}

@end