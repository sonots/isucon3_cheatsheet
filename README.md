isucon3_prepare
===============

欲しいチートシート:

- mysql.conf (done. hirose.cnf ぱくり済み)
- nginx.conf (done. keepalive off as default) nginx memcached plugin => did not try. 
- virnish => virnish でやるなら nginx memcached plugin は不要？
- redis ruby コードチートシート
- erb => slim (はやいはずだけど、キモにはならないかな)
- unicorn or puma or passenger どれ？ => unicorn.conf チートシート done

アイデア：

- mysql のデータファイルを tmpfs においたらめっちゃはやそう => レギュレーションの「サーバの設定およびデータ構造は任意のタイミングでのサーバ再起動に耐えること」にひっかかるのでだめっぽい T T
- AMIが提供されるだけなので、インスタンス１つではなく、複数立ちあげてそれぞれで別作業をするのも可。ただ、他に展開するためにAMI保存しようとするとその間なにも作業できなくなるので、手で移植か？
- アプリに newrelic か rack-mini-profiler 仕込んだほうがいいかも

# 当日の行動

- 予選 10月5日(土) 11:00 - 19:00
- 遅くとも 10:30 にはヒカリエに集まる. 席を近くにする(モニタ欲しいなら移動. その場合もっと早く集まる)
- ご飯は食べておく and 飲み物とか買っておく
- なお、土曜日に会社に来るのに事前に何か言っておく必要はないっぽい

