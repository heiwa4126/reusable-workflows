---
name: github-actions-security
description: Provides security rules and best practices for GitHub Actions workflows and custom actions. Use when writing, reviewing, or auditing GitHub Actions YAML files — especially to prevent script injection, supply chain attacks, privilege escalation, and secret leakage.
---

# GitHub Actions セキュリティスキル

## Script Injection 対策

### ルール: `run:` セクション内で `${{ }}` を直接展開しない

**NG 例:**
```yaml
- run: echo "Title: ${{ github.event.issue.title }}"
```

**OK 例:**
```yaml
- env:
    ISSUE_TITLE: ${{ github.event.issue.title }}
  run: echo "Title: $ISSUE_TITLE"
```

**理由:**
`${{ }}` 式は GitHub Actions のテンプレートエンジンがシェルスクリプトに展開する前に評価されるため、
悪意あるユーザーが Issue タイトルなどに `;`, `&&`, バッククォートなどを含めることで任意のコードを実行できる。
環境変数経由で渡すことで、シェルが値をデータとして扱うため注入を防げる。

---

## その他の攻撃対策ルール

### ルール: サードパーティ Action はコミットハッシュで固定する

**NG 例:**
```yaml
- uses: actions/checkout@v4
```

**OK 例:**
```yaml
- uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
```

**理由:**
タグ (`v4`) は書き換え可能。悪意あるコードが混入したバージョンを参照させるサプライチェーン攻撃を防ぐため、
変更不可能なコミットハッシュで固定する。バージョンはコメントで明記しておく。

---

### ルール: `pull_request_target` の使用は慎重に

**NG 例:**
```yaml
on: pull_request_target
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4  # フォークのコードをチェックアウト
      - run: npm install && npm test  # フォークの任意コードが実行される
```

**OK 例 (必要な場合はシークレットへのアクセスを分離):**
```yaml
on: pull_request_target
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.event.pull_request.head.sha }}  # フォークのコードは実行しない
```

**理由:**
`pull_request_target` はベースリポジトリのコンテキストで実行されるため、シークレットにアクセスできる。
フォークの PR のコードを安易にチェックアウトして実行すると、悪意あるコードがシークレットを窃取できる。

---

### ルール: ワークフローに最小権限を設定する

**NG 例 (デフォルトの広い権限を使用):**
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "hello"
```

**OK 例:**
```yaml
permissions:
  contents: read  # ジョブに必要な権限のみ付与

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read  # ジョブ単位でも設定可能
    steps:
      - run: echo "hello"
```

**理由:**
不必要に広い権限 (`write-all` など) を与えると、万が一 Script Injection が成功した場合の被害が拡大する。
リポジトリ・ジョブ単位で必要最小限の権限のみ付与する (`read-only` を基本とする)。

---

### ルール: シークレットをログに出力しない

**NG 例:**
```yaml
- run: echo "TOKEN=${{ secrets.MY_TOKEN }}"
```

**OK 例:**
```yaml
- env:
    MY_TOKEN: ${{ secrets.MY_TOKEN }}
  run: |
    # シークレットを直接 echo しない
    curl -H "Authorization: Bearer $MY_TOKEN" https://api.example.com
```

**理由:**
GitHub Actions はシークレットの値をログでマスクするが、Base64 エンコードなど変換後の値はマスクされないことがある。
シークレットはログに出力しないことを原則とする。

---

### ルール: 外部からの入力値を使う `workflow_dispatch` では入力値を検証する

**NG 例:**
```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        type: string

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - run: deploy.sh ${{ inputs.environment }}  # 未検証の入力を直接使用
```

**OK 例:**
```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        type: choice
        options:
          - staging
          - production

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - env:
          ENVIRONMENT: ${{ inputs.environment }}
        run: |
          # choice 型で制限 + 環境変数経由で渡す
          deploy.sh "$ENVIRONMENT"
```

**理由:**
`workflow_dispatch` の `string` 型入力は任意の値を渡せるため Script Injection のリスクがある。
可能な限り `choice` 型で許容値を制限し、環境変数経由で渡す。
