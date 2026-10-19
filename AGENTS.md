# AGENTS.md

このリポジトリで作業するエージェントの入り口です。このリポジトリでは、目的のまったく異なる 2 種類の作業でエージェントが使われます。最初に作業の種類を判断し、該当するファイルのルールだけに従ってください。

## プロジェクト

- Markdown の原稿から、Vivliostyle で技術同人誌の電子版 PDF と印刷入稿用 PDF を生成するリポジトリです。
- daigirin-template はテンプレートで、各書籍のリポジトリはこのテンプレートから作られます。

## 作業の種類

| 作業の種類 | 例 | 従うルール |
| --- | --- | --- |
| 執筆の補助 | 原稿の執筆・推敲・校正、記事や画像の追加、front matter の記述 | [book/AGENTS.md](book/AGENTS.md) |
| テンプレートの開発 | `scripts/`、`book/theme/`、`book/*.config.js`、`.github/`、`Makefile`、Docker、README など、PDF を作る仕組みの変更 | [docs/agents/development.md](docs/agents/development.md) |

- 執筆の補助では、テンプレートの開発ルール（[docs/agents/development.md](docs/agents/development.md)）を読まず、適用しない。
- テンプレートの開発を始める前に、[docs/agents/development.md](docs/agents/development.md) を読んで従う。
- どちらか判断できないとき、または両方にまたがるときは、作業を始める前にユーザーに確認する。

## 共通のルール

- 説明・コメント・ドキュメントは日本語で書く。識別子、パス、コマンドは英語表記のままにする。
- 依頼された範囲の外にあるファイルを変更しない。特に、ほかの著者の原稿を変更しない。
- 認証情報や個人情報をファイルやコミットに含めない。
