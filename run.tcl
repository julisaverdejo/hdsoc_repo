##=============================================================================
## [Filename]       run.tcl
## [Project]        
## [Author]         
## [Language]       Tcl (Tool Command Language)
## [Created]        Nov 2024
## [Modified]       -
## [Description]    Tcl file fo run simulation
## [Notes]          This file is passed to the ./simv command 
##                  using the -ucli -do run.tcl flag
## [Status]         devel
## [Revisions]      -
##=============================================================================

fsdbDumpvars 0 "tb" +all +trace_process
run

