# Sqlite encyption 
This is a demostration of sqlite3's encryption feature on iOS. The free version of [Sqlite](https://www.sqlite.org/download.html) library doesn't provide encrytion feature. 

### Hack the library
iOS has provided a sqlite3 dynamic library a long with the system without exposing encryption feature. How ever, the library still contains encryption underlying. One way to access this is defining the header of the encryption function some where and start using it:

```
int sqlite3_key_v2(sqlite3 *db, const char *zDb, const void *pKey, int nKey);
```


### Useage
```
// Open db
int res = sqlite3_open(dbPath.UTF8String, &db);

// Encrypt db  with your key
NSString *key = "key123";
int keyRes = sqlite3_key_v2(db, NULL, key.UTF8String, (int)key.length);
```

The database will then be encrypted. For more detail, check the `ViewController.openDB` function.

### Supported version
Notice that this function only  run successfully on iOS 13+.

On iOS 12 and bellow, it just return error 21 (SQLITE_MISUSE - Library used incorrectly).

Tested on simulator:
- iOS 14.4: works
- iOS 13: works
- iOS 11.0.1: Returns error 21

## Appendix
- There is a [opensource](https://opensource.apple.com/source/apache_mod_php/apache_mod_php-131/php/ext/sqlite3/libsqlite/sqlite3.c.auto.html) version of sqlite3 from Apple. It does refer the `sqlite_key_v2` function in some part of source code, but i can't find the implementation of `sqlite_key_v2`

- Sqlite3 is [opensource](https://sqlite.org/src/doc/trunk/README.md), but there's no encryption (`sqlite_key_v2`) feature in the free version

- SqliteCipher's implementation for reference: https://github.com/sqlcipher/sqlcipher/blob/0663d8500204e14bd2bb0ca25162d91e4555528d/src/crypto.c#L865
