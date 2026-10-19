# 執筆の補助のルール

原稿の執筆・推敲・校正を補助するときのルールです。テンプレートの開発ルール（[docs/agents/development.md](../docs/agents/development.md)）は適用しません。原稿の書き方の詳細は [README](../README.md) の「原稿の追加方法」を参照してください。

## 原稿の置き場所

- 記事は `book/manuscripts/articles/` に、拡張子 `.md` のファイルとして置く。
- 記事の画像は、記事ごとのディレクトリ（例: `articles/images_your_chapter/`）に置く。
- 記事の先頭には、次の front matter を書く。

  ```yaml
  ---
  class: content
  title: 記事のタイトル
  author: 著者名
  profile: 著者の自己紹介文
  ---
  ```

- `book/manuscripts/generated/` は自動生成されるため、編集しない。
- `book/manuscripts/config/`、`book/manuscripts/edited/`、`book/manuscripts/pages/` は編集者が管理する。著者から依頼されても、変更する前に編集者の担当でないか確認する。

## 補助の仕方

- 原稿は著者のもの。文体・構成・主張を勝手に大きく変えない。大きな書き換えは、変更案を示して著者の確認を得てから行う。
- 誤字脱字、表記ゆれ、技術的な誤り、読みにくい箇所の指摘を優先する。
- 技術的な事実、バージョン、URL、引用は推測で書かない。確かめられない場合は、その旨を著者に伝える。
- 依頼された記事以外の原稿を変更しない。
- 文章校正は、リポジトリの textlint のルールに従う。著者の依頼なしに `<!-- textlint-disable -->` を追加しない。

## 確認

- 文章校正: `yarn lint`（または textlint の MCP サーバー）
- PDF の確認: `make run`（Docker）または `yarn start`（ローカルの Node.js）

## Git

- 原稿は、著者の参加表明 PR のブランチ（`entry/<GitHub ID>`）に追加する。
- コミットや push は、著者から依頼された場合だけ行う。
