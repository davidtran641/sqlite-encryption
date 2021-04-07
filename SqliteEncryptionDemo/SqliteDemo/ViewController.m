//
//  ViewController.m
//  SqliteDemo
//
//  Created by ductran on 8/4/21.
//

#import "ViewController.h"
#import <sqlite3.h>

/// Declare the function so that it can be runable
/// The actual implementation was in sqlite3 library already
int sqlite3_key_v2(sqlite3 *db, const char *zDb, const void *pKey, int nKey);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self openDB];
}

- (void)openDB {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE)[0];
    
    NSString *dbPath = [dir stringByAppendingPathComponent:@"db.sqlite"];
    NSLog(@"DbPath: %@", dbPath);
    
    sqlite3 *db;
    int res = sqlite3_open(dbPath.UTF8String, &db);
    if (res != SQLITE_OK) {
        NSLog(@"Can't open db");
        return;
    }
    
    NSString *key =  @"key123";
    
    // This function will run on iOS 13+, and return error on iOS<13
    int keyRes = sqlite3_key_v2(db, NULL, key.UTF8String, (int)key.length);
    if (keyRes != SQLITE_OK) {
        NSLog(@"Encrypt database failed: %d", keyRes);
    }
    
    const char *stm = "CREATE TABLE IF NOT EXISTS CONTACT \
    (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
    
    char *errMsg;
    if (sqlite3_exec(db, stm, NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog(@"Create table failed: %s", errMsg);
    } else {
        NSLog(@"Create table success");
    }
    
    sqlite3_close(db);
    
}

@end
