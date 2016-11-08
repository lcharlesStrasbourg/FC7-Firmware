# FC7-Firmware

FC7-TestBoard Firmware Project aimed to provide DAQ System for CMS Tracker Phase 2 Upgrade.

### Description

To be done.

### Requirements

* Vivado Design Suite
* FC7 Board
* ...

### Folder Structure

Project contains following folder structure (inherited from FC7 sys firmware):

* README.md - ...
* ./doc - documentation
* ./ipbus_2_0_v1 - IPBUS Sources
* ./fw - firmware
    * ./fw/prj - folder with projects (FC7, CPLD, MMC..)
        * ./fw/prj/fpga_fc7_daq_firmware - contains TCL script to create the project, later project files will be stored here
    * ./fw/src - sources (see General firmware sturcture in FC7 Manual)
        * ./fw/src/sys - system part of firmware
        * ./fw/src/usr - user part
            * ./fw/src/usr/usr - main user part files
                * **./fw/src/usr/usr/user_core.vhd** - file containing user modules structure, block signals have to be connected here
            * **./fw/src/usr/ucf** - contraints folder.
            * **./fw/src/usr/"BLOCK_NAME"** - folder containing files for specific block
                * **./fw/src/usr/"BLOCK_NAME"/"BLOCK_NAME"_core.vhd** - block description file

**NOTE:** Normally developer works on the bold entities in the folder structure.

### Running
- Clone the repository:
> `git clone https://github.com/CMS-Tracker-Phase2-DAQ/FC7-Firmware.git`
- Open Vivado Design Suite. At the bottom you can find Tcl console.
- Go to the project directory ( `cd ./FC7-Firmware/fw/prj/fpga_fc7_daq_firmware` ).
- Run Tcl script to create a Vivado project ( `source ./fpga_fc7_daq_firmware_create_vivado_project.tcl` ).

### Making a Contribution

- Fork the repository to your own GitHub account (from this page, upper right corner).
- Clone **your own copy** of the repository:
> `git clone https://github.com/*your_user_name*/FC7-Firmware.git`
-  To Run:
    - Open Vivado Design Suite. At the bottom you can find Tcl console.
    - Go to the project directory ( `cd ./FC7-Firmware/fw/prj/fpga_fc7_daq_firmware` ).
    - Run Tcl script to create a Vivado project ( `source ./fpga_fc7_daq_firmware_create_vivado_project.tcl` ).
- Develope a new module, make changes to the old ones, whatever. Don't forget to preserve the folder structure.
- When code is ready for merging, do a final push to your repository. **Make sure to run `File -> Write Project Tcl...` command and replace existing Tcl file**. 
- Do PULL Request to Merge with the MAIN Repository.


