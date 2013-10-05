isucon3_prepare
===============

欲しいチートシート:

- mysql.conf (done. hirose.cnf ぱくり済み)
- nginx.conf (done. keepalive off as default) nginx memcached plugin => did not try. 
- virnish => virnish でやるなら nginx memcached plugin は不要？
- redis/resque ruby コードチートシート
- erb => slim (はやいはずだけど、キモにはならないかな)
- unicorn or puma or passenger どれ？ => unicorn.conf チートシート done

アイデア：

- mysql のデータファイルを tmpfs においたらめっちゃはやそう => レギュレーションの「サーバの設定およびデータ構造は任意のタイミングでのサーバ再起動に耐えること」にひっかかるのでだめっぽい T T
- AMIが提供されるだけなので、インスタンス１つではなく、複数立ちあげてそれぞれで別作業をするのも可。ただ、他に展開するためにAMI保存しようとするとその間なにも作業できなくなるので、手で移植か？
- アプリに newrelic か rack-mini-profiler 仕込んだほうがいいかも

cf. http://blog.nomadscafe.jp/2012/11/isucon2-5.html

- kazeburo さんは worker に HTML を保存させてそれを serve するようにしたらしい https://github.com/kazeburo/isucon2_hack/blob/master/perl/worker.pl
- nginx にアクセス時に gzip 圧縮するのではなく、その HTML をあらかじめ gzip 圧縮して配信したらしい 
- トラッフィク多すぎたので delay を入れたとな ...

cf. http://www.seeds-std.co.jp/seedsblog/163.html

* memcached の中に入ってるキーを一覧するperlワンライナー

```
perl -MCache::Memcached -e '$s="localhost:11211";$m=new Cache::Memcached({servers=>[$s]});$res=$m->stats("items");$i=$res->{hosts}{$s}{items};@a=split("€n",$i);while(){if($_=~/items:([0-9]+)/){$s{$1}=$_}};foreach $key (keys %s){$cm="cachedump $key 100";$res=$m->stats($cm);print "--- €n".$cm."€n";print $res->{hosts}{$s}{$cm}}'
```

* 再起動時にキャッシュに突っ込むシェルスクリプト

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


# 当日の行動

- 予選 10月5日(土) 11:00 - 19:00 => 10月6日(日) 11:00 - 19:00 に変更しました
- 遅くとも 10:30 にはヒカリエに集まる. 席を近くにする(モニタ欲しいなら移動. その場合もっと早く集まる)
- ご飯は食べておく and 飲み物とか買っておく
- なお、土曜日に会社に来るのに事前に何か言っておく必要はないっぽい

