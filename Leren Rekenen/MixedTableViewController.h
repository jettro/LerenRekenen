//
// Created by jcoenradie on 12/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface MixedTableViewController : UIViewController {

}

@property(nonatomic, readwrite) int table;
@property(nonatomic, readwrite) int currentAssignment;
@property(nonatomic, readwrite) UILabel *assignmentLabel;
@property(nonatomic, readwrite) UITextField *assignmentAnswer;

@end