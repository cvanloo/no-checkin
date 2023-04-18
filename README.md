# Pre-Commit Hooks

```sh
git clone https://github.com/cvanloo/commit-hooks.git

# in your own git project directory:
cp [commit-hooks/]no-checkin.janet .git/hooks/pre-commit

# or when using [pre-commit](https://pre-commit.com/):
cp [commit-hooks/].pre-commit-config.yaml .
pre-commit install
```
