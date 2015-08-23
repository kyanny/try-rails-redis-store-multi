- cache_store のサーバが落ちてても Rails アプリケーションは落ちない（単に Rails.cache.get の結果が nil になるだけ？）
- session_store のサーバが落ちてると Rails アプリケーションごと落ちる
- session\_store に redis_store を指定した場合、 servers: 'uri' と servers: {host: port:} と servers: [{host: port:}, {host: port:}] 形式で指定可能
- だが、 redis の master-slave レプリケーションだと slave にはデフォルト設定では書き込みできないのでランダムに `READONLY You can't write against a read only slave.` になるので意味ない
- redis クラスタ構成にすればいけそうだが、正直そうまでして redis にこだわることもない（ふつうに memcached 使えば何も考えず複数台分散してくれる）

app/config/initializers/session_store.rb

```
$ redis-server --port 7777 --slaveof 127.0.0.1 6379
```

1. session\_store を memcache に変更し、複数ホストを並べる。勝手に複数台で分散してくれるので可用性があがる。 memcached サーバが一台でも残ってれば他がダウンしてもアプリは落ちない。全部ダウンしたらアプリも落ちる。 aws tokyo リージョンなら複数の availability zone を使って二台か三台立てておけばよい。多くの web アプリは memcached 再起動によるセッションデータの揮発は仕方ないと割り切って採用している。
2. session\_store を cookie store （Rails 4 デフォルト）に変える。セッション用のサーバが不要なので同じ原因でアプリが落ちることは無くなる。セッションデータがユーザーのブラウザの cookie に保存されるので、 cookie 消したりシークレットウィンドウを使ったり別ブラウザ使ったりするとフォームで途中までやってた操作内容とかが消える（引き継がれない）
3. redis のクラスタリング構成にして複数台構成にする。大掛かりすぎるし memcached なら同じことがもっと簡単にできる。 redis cluster は 3 系からの機能で 2 系ではまだ実験的扱いっぽいので運用コストは高まる。永続化してくれる点で memcached に勝る。
4. どうしてもセッションの内容を絶対に失いたくないなら session\_store 先を RDBMS (PostgreSQL, MySQL) に変更する。古いセッションを定期的に削除するバッチが別途必要。
