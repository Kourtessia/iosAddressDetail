//
//  AKViewController.h
//  AddContact
//
//  Created by Kourtessia on 16.03.14.
//  Copyright (c) 2014 Kourtessia. All rights reserved.
//

#define TAG_TEXT_FIELD 10000
#define CELL_REUSE_IDENTIFIER @"CustomTextCell"

@interface AKAddContactViewController : UITableViewController

@property (nonatomic, copy) NSArray *contents;

@end
