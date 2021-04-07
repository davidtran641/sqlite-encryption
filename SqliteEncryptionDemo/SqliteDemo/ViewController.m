//
//  ViewController.m
//  SqliteDemo
//
//  Created by ductran on 8/4/21.
//

#import "ViewController.h"
#import <sqlite3.h>

/// Declare the function so that this function can be callable.
/// The actual implementation was in sqlite3 library already.
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
        return;
    }
    
    [self createTable:db];
    [self useDB:db];
    
    sqlite3_close(db);
}

- (void) createTable: (sqlite3*) db {
    const char *stm = "CREATE TABLE IF NOT EXISTS Contact \
    (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT)";
    
    char *errMsg;
    if (sqlite3_exec(db, stm, NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog(@"Create table failed: %s", errMsg);
    } else {
        NSLog(@"Create table success");
    }
}

- (void) useDB: (sqlite3*) db  {
    const char *insertStm = "INSERT INTO Contact(name, email) VALUES ('Julia', 'j@email.com')";
    char *errMsgInsert;
    if (sqlite3_exec(db, insertStm, NULL, NULL, &errMsgInsert) != SQLITE_OK) {
        NSLog(@"Insert error: %s", errMsgInsert);
    } else {
        NSLog(@"Insert success");
    }
    
    const char *selectStm = "SELECT * FROM Contact WHERE 1";
    sqlite3_stmt *stmt;
    int selectCode = sqlite3_prepare_v2(db, selectStm, -1, &stmt, NULL);
    if (selectCode != SQLITE_OK ) {
        NSLog(@"Select error: %d", selectCode);
    } else {
        NSLog(@"Select result:");
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int userId = sqlite3_column_int(stmt, 0);
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            const unsigned char *email = sqlite3_column_text(stmt, 2);
            
            NSLog(@"User: %d, %s, %s", userId, name, email);
        }
        sqlite3_finalize(stmt);
    }
}

@end
