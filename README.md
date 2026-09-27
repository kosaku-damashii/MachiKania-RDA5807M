# MachiKania-RDA5807M
Class library for RDA5807M FM Radio Tuner on MachiKania type P/PU

<img width="3648" height="2736" alt="DSC02559" src="https://github.com/user-attachments/assets/338995ee-c0d9-41e9-9171-38a2aaa67707" />

## 概要
FMラジオモジュールRRD-102V2.0（RDA5807M搭載）を制御し、FMラジオを聴くためのクラスライブラリ。<BR>
MachiKania type P/PU のGROVE(I2C)端子に繋げて使う。<BR>
<BR>
## 配線図
MachiKania type P開発基板上にI2Cのプルアップ抵抗が付いている前提。<BR>
L-OUTとR-OUTがモジュールの説明書と違うと思うが、ICのデータシートを正とするならばこうなるはず（テスターで確認済）<BR>
アンテナには長めのジャンパー線でも良いが長い方が受信感度が良い。<BR>
<img width="1515" height="425" alt="image" src="https://github.com/user-attachments/assets/d74703ed-c11a-47fb-9d52-8367c3ef9441" />
<BR>
## ファイルについて
RDA5807MK.BAS 自体を実行するとサンプルプログラムが実行されます。。<BR>
ライブラリとして使う場合は、「LIB」フォルダーの下に「RDA5807M」というフォルダーを作成し、その中に、「RDA5807M.BAS」を入れて使用してください。<BR>
　/LIB/RDA5807M/RDA5807M.BAS<BR>
 
## サンプルプログラムの操作方法
MachiKania type P/PU本体の<BR>
+ 上下キー：音量調整<BR>
+ 左右キー：放送局をシーク<BR>
+ FIREキー：終了（キーボードを繋げている場合はキーボードのキーを、繋げていない場合はSTARTキーを押してください）<BR>
<BR>
選局や音量が確定した後は、MachiKaniaなどのマイコン側のプログラムを切り替えたりリセットしてもラジオは聴くことができます。<BR>
その場合、シグナル強度が低いとマイコン側の動きによってノイズが発生する場合があります。シグナル強度が強い場合はあまり気にならないと思います。<BR>
<BR>
## ユニバーサル基板を使って作る
部品の選定や加工方法については下記の図を参照。<BR>
表面と裏面で配線が交差している部分があるので、ユニバーサル基板は、片面基板か、両面基板の場合はスルーホール（穴が表裏で繋がっている）ではなく表裏が繋がっていないタイプの基板を使うと良い。もしスルーホールの基板を使う場合は裏面の配線と交差した部分がショートしないようにテープやチューブなどで絶縁すること。<BR>
イヤホンとアンテナを繋げるが、アンテナ用のジャックにはミニジャックの延長コードなどを繋げると良い。<BR>
<img width="1991" height="1143" alt="image" src="https://github.com/user-attachments/assets/0108cc2c-1d95-4464-8e57-ae80d0a0a59c" />

