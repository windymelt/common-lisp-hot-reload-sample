このレポジトリはCommon LISPでホットリロードを行うのに必要な処理を書いたサンプルです．

## 前提

- 依存ライブラリ
  - [clack](https://github.com/fukamachi/clack)
  - [cffi](https://github.com/cffi/cffi)
- 実行環境
  - [roswell](https://github.com/roswell/roswell)
  - roswellを使わない場合でも実行は可能．`hot-reload-sample.asd`を読み込み，`(hot-reload-sample:main)`を実行すればよい．

## 動作

このサンプルを起動すると，`localhost:5000`にHTTPサーバが立ち上がります．
このサーバのPIDにSIGHUPを送信すると，サーバはホットリロードし，`hot-reload-sample`systemが再コンパイルされます．

例えば，サーバを起動した状態で`get-message`が返す文字列を変更してからSIGHUPを送信すると，HTTPリクエストに対する返答が変化します．

## 実行

```shell
git clone git@github.com:windymelt/common-lisp-hot-reload-sample.git
cd common-lisp-hot-reload-sample/
ros -S . -s hot-reload-sample -e '(hot-reload-sample:main)'
Hunchentoot server is started.
Listening on localhost:5000.
PID for this process is [11020]
Press enter key to exit...
# ここでSIGHUPを送信する
SIGHUP received. Reloading...
Reload done.
```
