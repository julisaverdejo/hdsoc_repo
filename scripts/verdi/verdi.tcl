##=============================================================================
## [Filename]       verdi.tcl
## [Project]        
## [Author]         
## [Language]       Tcl (Tool Command Language)
## [Created]        
## [Modified]       -
## [Description]    This file is used to configure waveforms
## [Notes]          -
## [Status]         stable
## [Revisions]      -
##=============================================================================

# Activate Signal List Panel
srcSignalView -on
verdiSetActWin -dock widgetDock_<Signal_List>

# Add Digital Signals

# Add Analog Signals

# Zoom to fit
verdiSetActWin -win $_nWave2
wvZoomAll -win $_nWave2
