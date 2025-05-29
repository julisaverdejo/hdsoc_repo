# hdsoc_repo

## Setup

```bash
setenv GIT_ROOT `git rev-parse --show-toplevel`
setenv TB_WORK $GIT_ROOT/work/tb
mkdir -p $TB_WORK && cd $TB_WORK
ln -sf $GIT_ROOT/scripts/makefiles/Makefile.vcs Makefile
ln -sf $GIT_ROOT/scripts/setup/setup_synopsys_eda.tcsh
source setup_synopsys_eda.tcsh
make
```

## Notes


## References
