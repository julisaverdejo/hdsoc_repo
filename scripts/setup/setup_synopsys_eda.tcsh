#!/usr/bin/env tcsh

# see /cds/env/setenv_synopsys_2024_25.csh 

# Setup environment variables
setenv CAD_ROOT /eda
setenv SYNOPSYS_ROOT $CAD_ROOT/synopsys/2024-25/RHELx86
setenv VCS_ARCH_OVERRIDE linux

# Run the corresponding script for each tool
foreach f ( `ls $SYNOPSYS_ROOT/../scripts/*.csh` )
	source $f
end

# Synopsys License
setenv SNPSLMD_LICENSE_FILE 5280@sunba2
setenv SNPS_LICENSE_FILE 5280@sunba2

# Extras
setenv GIT_ROOT `git rev-parse --show-toplevel`

