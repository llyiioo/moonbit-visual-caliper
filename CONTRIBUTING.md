# Contributing

This hackathon repository is maintained by the repository owner. Contributions should keep the core library pure MoonBit unless an adapter package is intentionally added.

Before sending changes, run:

```bash
moon fmt
moon check --deny-warn
moon test --deny-warn
moon info
```

Generated `pkg.generated.mbti` changes should be reviewed when public APIs change.
