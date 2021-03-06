# Parse project name and directory from arguments
if { $argc != 2 } {
    puts "ERROR: The script requires the project name and directory to be input."
    return
} else {
    # The name of the project to create
    set proj_name [lindex $argv 0]
    puts "INFO: The project name is $proj_name"

    # The name of the project directory
    set proj_dir [lindex $argv 1]
    puts "INFO: The project directory is $proj_dir"
}

open_project $proj_dir/$proj_name.xpr
open_bd_design [get_files -norecurse design_1.bd]
write_bd_tcl -force scripts/block-design.tcl