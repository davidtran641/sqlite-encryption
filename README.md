# sqlite-encyption
This is a demostration of sqlite3's encryption feature on iOS. The free version of [Sqlite](https://www.sqlite.org/download.html) library doesn't provide encrytion feature. 

iOS has provided a sqlite3 dynamic library a long with the system without exposing encryption feature.

How ever, the library still support encryption. One way to do it programatically is define the header of this function:

```
int sqlite3_key_v2(sqlite3 *db, const char *zDb, const void *pKey, int nKey);
```

After opening the database:
```
int res = sqlite3_open(dbPath.UTF8String, &db);
```

and then calling the `sqlite3_key_v2` function:
```
int keyRes = sqlite3_key_v2(db, NULL, key.UTF8String, (int)key.length);
```

The database will be encrypted. For more detail, check the `ViewController.openDB` function.

Notice that this function only  run successfully on iOS 13+.

On iOS 12 and bellow, it just return error 21 (SQLITE_MISUSE - Library used incorrectly).

Tested on simulator:
- iOS 14.4: works
- iOS 13: TBD
- iOS 11.0.1: Return error 21