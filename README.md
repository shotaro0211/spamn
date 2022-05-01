# SPAMNの使用技術

*   スマートコントラクト
    *   Solidity
*   フロントエンド
    *   Flutter Web

# スマートコントラクト解説

## 主要メソッド

*   addQuestions
    *   問題作成メソッド
    *   Question構造体を作成
        *   title : String : 問題文
        *   choices : String\[] : 選択肢
        *   answer : uint : 答え
        *   description : String : 解説
        *   owner : address : 問題作成者アドレス
        *   value : uint256 : 正解報酬
        *   answered : bool : 答えたかどうか
        *   corrected : bool : 正解したかどうか
*   setAnswer
    *   問題回答メソッド
    *   引数
        *   tokenId
        *   answer : uint : 答え
    *   メソッドの流れ
        *   問題NFTを所有してるかどうか（require）
        *   問題NFTが回答済みかどうか(require)
        *   問題を正解しているかどうか
            *   正解した場合
                *   正解報酬を回答者へ
                *   NFTはBurnへ
            *   不正解の場合
                *   正解報酬を問題作成者へリターン

# フロントエンド解説

*   ページ一覧
    *   ウォレット未接続ページ
        *   Connectする
            *   ウォレットがない場合
                *   metamaskインストールページ
            *   mobileブラウザの場合
                *   metamaskアプリに遷移
            *   networkがない場合
                *   自動ネットワーク追加
    *   トップページ
        *   問題コレクション
            *   問題を作成する
            *   問題を受け取る
    *   問題作成ページ
        *   問題作成フォーム
    *   問題回答ページ
        *   問題回答フォーム
