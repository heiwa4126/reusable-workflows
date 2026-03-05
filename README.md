# reusable-workflows

管理がめんどくさくなってきたので、
いままで作った GitHub Actions の actions と reusable-workflows をここに置く。

主に自分用。ドキュメントはだんだんと充実させていく

## SKILL.md を追加した

[SKILL.md](.github/skills/github-actions-security/SKILL.md)

GitHub Copilot から `/github-actions-security` で実行できる。

あと `./lint.sh` も手動で実行すること。
`pinact run -u` もときどき実行。

## aqua.yaml

linter などをインストールする用

```sh
aqua i
```

でインストール

## 愚痴

Dependabot が action.yml をサブディレクトリに置くと見てくれない...
いま .github/workflows/\*.yml がないので、reusable-workflows を追加したら
Dependabot も修正すること。`directories:`にいちいち追加するのは面倒だ。

pypa/gh-action-pypi-publish は今のところ
PyPI の Trusted Publishing 機能ではサポートされていないそうです。
[Reusable workflows on GitHub](https://docs.pypi.org/trusted-publishers/troubleshooting/#reusable-workflows-on-github)

↑の理由で[書いたけどいまのところ動かないやつ](.github/workflows/publish-testpypi.yml)
