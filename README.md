# reusable-workflows

管理がめんどくさくなってきたので、
いままで作った GitHub Actions の actions と reusable-workflows をここに置く。

主に自分用。ドキュメントはだんだんと充実させていく

## 愚痴

Dependabot が action.yml をサブディレクトリに置くと見てくれない...
いま .github/workflows/\*.yml がないので、reusable-workflows を追加したら
Dependabotも修正すること。

pypa/gh-action-pypi-publish は今のところ
PyPIのTrusted Publishing機能ではサポートされていないそうです。
[Reusable workflows on GitHub](https://docs.pypi.org/trusted-publishers/troubleshooting/#reusable-workflows-on-github)

↑の理由で[書いたけどいまのところ動かないやつ](.github/workflows/publish-testpypi.yml)
