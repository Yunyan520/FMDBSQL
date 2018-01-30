# FMDBSQL

对于iOS开发者，尤其是初级开发者来说，SQL的使用无疑是个头疼的问题，并不是有多难，而是一坨一坨的语句就让人头皮发麻，作者在开发过程中由于要向数据库中存入很多的数据，虽然已经用了FMDB神器，看着一堆SQL语句依然头疼，于是一咬牙一跺脚，把FMDB再封装一层，实现API调用

既然基于`FMDB`，那就必须导入这个神器，作者是使用的`cocoapods`导入的FMDB三方库，至于怎么安装并使用cocoapods，这里不再讲解，请自行查阅资料
```sh
pod 'FMDB', '~> 2.7.2'   导入FMDB
```
先从创建表格说起，由于创建每个表格需要的参数名称、数量都有差别，毫无疑问要想统一方法，则需要传递不定长的参数，灵感来源于UIAlertView传递参数的方法，于是创建表格的方法就写成了这个样子
```objc
- (void)createRSSTable:(NSString*)tableName objs:(NSString*)firstObj, ...NS_REQUIRES_NIL_TERMINATION;
```
but  参数是传进来了，怎么来拿到这些参数从而写出SQL语句呢？接着往下看，实际上这些参数都被存入的一个链表之中，而不是数组，iOS提供了方法供我们来遍历这些参数，于是我们就可以把这些参数放到我们熟悉的数组中NSMutableArray *objs = [[NSMutableArray alloc] init];

```objc
​    //参数链表指针

​    va_listlist;

​    //遍历开始

​    va_start(list, firstObj);

​    //知道读取到下一个时nil时结束递增

​    for(NSString*str = firstObj; str !=nil; str =va_arg(list,NSString*)) {

​        NSLog(@"%@",str);

​        [objsaddObject:str];

​    }

​    //结束遍历

​    va_end(list);

//拿到参数数组就可以来拼接SQL语句了，首先来拼接参数语句

NSMutableString *sql = [[NSMutableString alloc] init];

​    for(NSIntegeri =0;i < objs.count; i++)

​    {

​        if(i < objs.count-1)

​        {

​            [sqlappendFormat:@"%@", [NSString stringWithFormat:@"%@ varchar(256),",objs[i]]];

​        }

​        else

​        {

​            [sqlappendFormat:@"%@", [NSString stringWithFormat:@"%@ varchar(256)",objs[i]]];

​        }

​    }
```
最后拼接完成的SQL语句就成了这个样子
```objc
NSString* priceAlertSql = [NSStringstringWithFormat:@"create table if not exists %@(%@)",tableName,sql];
```
好了，完整的语句有了，我们就可以来创建表格，老规矩，调用FMDB里的方法
```objc
BOOLisTableSuccess = [_fmdbexecuteUpdate:priceAlertSql];
```
最后记得关闭数据库
```objc
[_fmdb close];
```
接下来问题来了，表格是创建成功了，我们怎么去像特定的表格中进行插入删除等操作，如果把字段和值都传进去岂不是很啰嗦？作者是这么干的，创建一个全局字典，把表名和字段存进一个字典不就搞定了吗？这样只需要根据表格名字来拿到这些字段不就可以进行下一步的操作了，代码如下
```objc
[_tableObjDicsetObject:objsforKey:tableName];
```
这里只写了创建表格的封装，在demo里面封装了插入数据，删除数据，更改表格中的数据方法，剩下的查找方法还没来得及去写，思路基本都是这个思路，请猴子们自行脑补，最后也会附上`demo`地址

因为本人也是iOS菜鸟一枚，文章和代码依然有很多不足，甚至漏洞，还请大家海涵，有好的思路也可留言，一起探讨，共同进步，大神请绕道，当然如果大神能留下自己的建议或者批评，本人将不胜感激！
