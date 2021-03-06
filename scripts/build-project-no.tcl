# Paths of the required files
set constraints_path [file normalize "../src/constraints/snickerdoodle_constraints.xdc"]
set block_design_path [file normalize "../scripts/block-design.tcl"]

# Paths to the required directories
set ip_repo_path [file normalize "../src/ip-repo"]



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



# Check for paths and files needed for project creation
set status true

set files [list \
    "$constraints_path"\
    "$block_design_path"\
]

foreach ifile $files {
    if { ![file isfile $ifile] } {
        puts "ERROR: Could not find file $ifile"
        set status false
    }
}

set directory [list \
    "$ip_repo_path"\
]

foreach ipath $directory {
    if { ![file isdirectory $ipath] } {
        puts "ERROR: Could not access $ipath"
        set status false
    }
}

if {$status} {
    puts "INFO: Tcl file build_project.tcl is valid. All files required for project creation is accesable. "
} else {
    puts "ERROR: Tcl file build_project.tcl is not valid. Not all files required for project creation is accesable. "
    return
}



# Create project
# create_project -in_memory $proj_name $proj_dir -part xc7z020clg400-3

# Set board for the project
# set_property -name "board_part" -value "krtkl.com:snickerdoodle_black:part0:1.0" -objects [current_project]

# Set default language for the project
# set_property -name "target_language" -value "VHDL" -objects [current_project]



# Set IP repository paths
# set_property -name "ip_repo_paths" -value $ip_repo_path -objects [get_filesets sources_1]
set_property -name "ip_repo_paths" -value $ip_repo_path -objects [current_fileset]

# Rebuild user ip_repo's index before adding any source files
update_ip_catalog -rebuild

# Add/Import pin constraints file
# add_files -norecurse -fileset constrs_1 -files $constraints_path
read_xdc $constraints_path

# Create block diagram design_1 accoring to block_design tcl file
source $block_design_path

generate_target all [get_files -norecurse design_1.bd]

# Create wrapper files for the block diagram
read_vhdl -library work [make_wrapper -fileset sources_1 -import -top -files [get_files -norecurse design_1.bd]]


proc numberOfCPUs {} {
    # Windows puts it in an environment variable
    global tcl_platform env
    if {$tcl_platform(platform) eq "windows"} {
        puts "INFO: Using $env(NUMBER_OF_PROCESSORS) jobs"
        return $env(NUMBER_OF_PROCESSORS)
    }
 
    # Check for sysctl (OSX, BSD)
    set sysctl [auto_execok "sysctl"]
    if {[llength $sysctl]} {
        if {![catch {exec {*}$sysctl -n "hw.ncpu"} cores]} {
            puts "INFO: Using $cores jobs"
            return $cores
        }
    }
 
    # Assume Linux, which has /proc/cpuinfo, but be careful
    if {![catch {open "/proc/cpuinfo"} f]} {
        set cores [regexp -all -line {^processor\s} [read $f]]
        close $f
        if {$cores > 0} {
            puts "INFO: Using $cores jobs"
            return $cores
        }
    }
 
    # No idea what the actual number of cores is; exhausted all our options
    # Fall back to returning 1; there must be at least that because we're running on it!
    puts "INFO: Could not determine number of cores. Using 1 job"
    return 1
}

set path_out $proj_dir

################################################################################
# run synthesis
# report utilization and timing estimates
# write checkpoint design
################################################################################
# synth_design -top red_pitaya_top -flatten_hierarchy none -bufg 16 -keep_equivalent_registers
synth_design -top [lindex [find_top] 0] -part xc7z020clg400-3
# synth_design -top design_1_wrapper

write_checkpoint         -force   $path_out/post_synth
report_timing_summary    -file    $path_out/post_synth_timing_summary.rpt
report_power             -file    $path_out/post_synth_power.rpt

################################################################################
# run placement and logic optimization
# report utilization and timing estimates
# write checkpoint design
################################################################################

# opt_design
# power_opt_design
# place_design
# phys_opt_design
# write_checkpoint         -force   $path_out/post_place
# report_timing_summary    -file    $path_out/post_place_timing_summary.rpt
# #write_hwdef              -file    $path_sdk/red_pitaya.hwdef

# ################################################################################
# # run router
# # report actual utilization and timing,
# # write checkpoint design
# # run drc, write verilog and xdc out
# ################################################################################

# route_design
# write_checkpoint         -force   $path_out/post_route
# report_timing_summary    -file    $path_out/post_route_timing_summary.rpt
# report_timing            -file    $path_out/post_route_timing.rpt -sort_by group -max_paths 100 -path_type summary
# report_clock_utilization -file    $path_out/clock_util.rpt
# report_utilization       -file    $path_out/post_route_util.rpt
# report_power             -file    $path_out/post_route_power.rpt
# report_drc               -file    $path_out/post_imp_drc.rpt
# #write_verilog            -force   $path_out/bft_impl_netlist.v
# #write_xdc -no_fixed_only -force   $path_out/bft_impl.xdc

# ################################################################################
# # generate a bitstream
# ################################################################################

# set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
# write_bitstream -force $path_out/red_pitaya.bit

# ################################################################################
# # generate the .bin file for flashing via 'cat red_pitaya.bin > /dev/xdevcfg'
# ################################################################################

# set_property BITSTREAM.GENERAL.COMPRESS FALSE [current_design]
# write_bitstream -force $path_out/red_pitaya_uncompressed.bit
# write_cfgmem -force -format BIN -size 2 -interface SMAPx32 -disablebitswap -loadbit "up 0x0 $path_out/red_pitaya_uncompressed.bit" red_pitaya.bin

# ################################################################################
# # generate system definition
# ################################################################################

# write_sysdef             -hwdef   $path_sdk/red_pitaya.hwdef \
#                          -bitfile $path_out/red_pitaya.bit \
#                          -file    $path_sdk/red_pitaya.sysdef

exit