- cache_store のサーバが落ちてても Rails アプリケーションは落ちない（単に Rails.cache.get の結果が nil になるだけ？）
- session_store のサーバが落ちてると Rails アプリケーションごと落ちる
- session\_store に redis_store を指定した場合、 servers: 'uri' と servers: {host: port:} と servers: [{host: port:}, {host: port:}] 形式で指定可能
- だが、 redis の master-slave レプリケーションだと slave にはデフォルト設定では書き込みできないのでランダムに `READONLY You can't write against a read only slave.` になるので意味ない
- redis クラスタ構成にすればいけそうだが、正直そうまでして redis にこだわることもない（ふつうに memcached 使えば何も考えず複数台分散してくれる）

```
$ redis-server --port 7777 --slaveof 127.0.0.1 6379
```
