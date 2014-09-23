isucon3_prepare
===============

# ISUCON3 レギュレーションと予選当時の流れ

- http://isucon.net/archives/cat_1024990.html
- https://gist.github.com/941/191180fd8e33aae121cb

# 当日の行動

- 予選 10月5日(土) 10:00 - 18:00 => 10月6日(日) 10:00 - 18:00 に変更しました
- 遅くとも 09:30 にはヒカリエに集まる. 席を近くにする(モニタは借りればよい.休みなので使ってない)
- ご飯は食べておく and 飲み物とか買っておく

# 次回に向けて（反省）

直せそうな所を見つけてすぐ直すよりも、一旦まとめて戦略を錬ってガッとやる方が上位にいけるっぽい
簡単な改修ポイントがみつかってもまだ手を出さず、最初は洗い出しに専念すること！！

- AMI3台立ち上げる。１台は本番機でインフラ担当が扱う。公開鍵を渡して登録してもらう。
- 本番機を初期設定する
- レギュレーションを読む
- メトリクスを取る仕込みを入れて time コマンドかまして１回ベンチ通す(ベンチ１回に何秒かかるか見る)

 - mysql で log-queries-not-using-indexes を出すようにしておく
 - HTTPリクエストのメトリクスをとえるプロファイラを仕込む (nginx のログで見る手もある)
 - SQLクエリのメトリクスをとれるプロファイラを仕込む (long_query_time = 0 で slow.log 出しておき、mysqlslowdump という手もある)
 - テンプレートエンジンのメトリクスをとれるプロファイラを仕込む
 - lsof してアプリがどこにアクセスしているのかとっておく
 - vmstat の結果をとっておく
 - iostat の結果をとっておく
 - テーブルのスキーマ、インデックス情報をとっておく (show create table memos, explain ....)
 - https://gist.github.com/sonots/0a6211ea5bb5fc1f795c

- 本番機をイメージ化して共有する(待ち時間発生。その間に下)
- メトリクスの結果とコードを見てチューニング箇所を考える
- アプリの画面を触りながら(*Chrome の Developer Tools 開きながら*)議論し、戦略を練る。
- (一人)用意しておいたミドルウェアの設定ファイルを適用していく
- (二人)ガッとやる
- 計測する. 外の情報にもアンテナを貼っておく(OK)

# 役に立つかもしれない情報

クエリチューニング:

- http://www.slideshare.net/kazeburo/isucon-summerclass2014action2final
- まずは検索カラムに index を貼る
- SELECT のカラムを * から必要なカラムに絞る。少数ならば index 貼ってしまって、covering index にしてしまう
- LIMIT ? OFFSET ? は IN に置き換える
- N+1 クエリはまとめて取得できるように書き換える
  - 典型例: 二つのテーブルを合体するためのN+1クエリ => Joinに直す


アイデア：

- アプリに newrelic か rack-mini-profiler 仕込んだほうがよさそう
- rubinius への置き換え => 使ったことないのでエラー出た時どうしたらいいかわからん
- mysql のデータファイルを tmpfs においたらはやそう

    - レギュレーションの「サーバの設定およびデータ構造は任意のタイミングでのサーバ再起動に耐えること」にひっかかるのでだめっぽい T T
    - シャットダウン時にディスクにおいて、起動時にディスクから tmpfs に cp するようにすればいいんじゃないのかな
    - 実際にやってみたが速くはなったが、varnish のほうが銀の弾丸度では上だな。アプリの処理を丸っと省けるからな。


cf. http://blog.nomadscafe.jp/2012/11/isucon2-5.html

- kazeburo さんは worker に HTML を保存させてそれを serve するようにしたらしい https://github.com/kazeburo/isucon2_hack/blob/master/perl/worker.pl
- nginx にアクセス時に gzip 圧縮するのではなく、その HTML をあらかじめ gzip 圧縮して配信したらしい 
- トラッフィク多すぎたので delay を入れたとな ...

cf. http://www.seeds-std.co.jp/seedsblog/163.html

memcached の中に入ってるキーを一覧するperlワンライナー

```
perl -MCache::Memcached -e '$s="localhost:11211";$m=new Cache::Memcached({servers=>[$s]});$res=$m->stats("items");$i=$res->{hosts}{$s}{items};@a=split("€n",$i);while(){if($_=~/items:([0-9]+)/){$s{$1}=$_}};foreach $key (keys %s){$cm="cachedump $key 100";$res=$m->stats($cm);print "--- €n".$cm."€n";print $res->{hosts}{$s}{$cm}}'
```

再起動時にキャッシュに突っ込むシェルスクリプト

```
#!/bin/sh

for i in `seq 1 1 3000`
do
    wget http://app01/article/$i -O -
done
```

デプロイ. てっとりはやく rsync でいいかもね

```
#!/bin/sh
rsync -Irp --exclude ".git" --progress . $HOST:isucon/webapp/ruby/
ssh -t $HOST sudo /etc/init.d/supervisord restart
```
