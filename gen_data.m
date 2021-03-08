vowels = ['a', 'i', 'u', 'e', 'o', 'n', '-'];   %音の種類
p = 128;                                        %LPCの次数
N = 512;                                        %フレーム長
nshift = 128;                                   %フレームシフト長
preemph = [1 -0.97];                            %プリエンファシスの係数
w = hamming(N);                                 %窓関数

X = {};                                         %LPC係数保存用のセル配列
Y = {};                                         %ラベル保存用のセル配列
n = 1;                                          %データの番号

%母音毎のループ
for i = 1:length(vowels)
    %音声の読み込み
    [x, Fs] = audioread(append('audio\',vowels(i),'.wav'));

    %音声の長さ
    L = length(x);

    %フレーム毎のループ
    for t = 1:nshift:L-N
        %フレームの切り出し
        %→プリエンファシス
        %→窓かけ
        frame = filter(preemph,1,x(t:t+N-1)).*w;

        %LPC係数計算
        A = lpc(frame,p);

        %特徴量をセル配列に保存
        %LPC係数の2番目から最後を取り出す
        %→転置(よくわからないけど転置したらうまくいった)
        X{n,1} = A(2:end).';

        %ラベルの保存
        %categoricalな値であると示す
        Y{n,1} = categorical(cellstr(vowels(i)));

        %データ番号の更新;
        n = n + 1;
    end
end

%保存
save("data\data",'X',"Y")