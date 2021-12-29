# Steps to get a completely working petalinux image

Start by creating a petalinx project

```bash
petalinux-create --type project --template zynq --name <PROJECT NAME>
```

Here the name of my project is uiotest so the command looks like this

```bash
petalinux-create --type project --template zynq --name uiotest
```

Next you want to add the hardware description that you get from vivado so that petalinux knows about your pl configuration. I always make a folder within my petaliux project to store these files to make sure I dont overwrite them in case i need to rebuild from them

```bash
mkdir hw-description
cp ../ledcube/tmp/* hw-description/
```

Then you run the command to actually get the project config from the files

```bash
petalinux-config --get-hw-description hw-description/
```

Once this runs a configuration menu will come up. This will allow you to configure your zynq system. There are a bunch of options here. 

![Untitled](Steps%20to%20get%20a%20completely%20working%20petalinux%20image%201c8b421e1fca47198a214cee8c3836fe/Untitled.png)

We are concerned with "Image Packaging Configuration". Go into that and change the root filesystem type to EXT4. This is required for booting off of an sd card

You can also turn off "Copy final images to tftboot" since we wont be using that feature

![Untitled](Steps%20to%20get%20a%20completely%20working%20petalinux%20image%201c8b421e1fca47198a214cee8c3836fe/Untitled%201.png)

Now I would build the project just to get the long wait out of the way. WARNING this will take a LOOOOOONG time. So sit back and find something else to do while it works

Once that is done we can finish configuring the kernel to make sure our uio drivers are enabled. 

```bash
petalinux-config -c kernel
```

![Untitled](Steps%20to%20get%20a%20completely%20working%20petalinux%20image%201c8b421e1fca47198a214cee8c3836fe/Untitled%202.png)

Go to "Device Drivers" →"Userspace I/O Drivers" and change "Userspace I/O platform driver with generic IRQ" handling to a <*> by moving over it and pressing y

![Untitled](Steps%20to%20get%20a%20completely%20working%20petalinux%20image%201c8b421e1fca47198a214cee8c3836fe/Untitled%203.png)

Now exit by pressing esc a bunch or using the Exit option at the bottom a bunch. Then it will work some magic. Now go find the "system-user.dtsi" file and put the following text in it. The file should be located at "project-spec → meta-user → recipes-bsp → device-tree → files → system-user.dtsi"

```bash
/include/ "system-conf.dtsi"
/ {
	chosen {
		bootargs = "console=ttyPS0,115200 earlycon root=/dev/mmcblk0p2 rw rootwait earlyprintk uio_pdrv_genirq.of_id=generic-uio";
		stdout-path = "serial0:115200n8";
	};
};

&axi_bram_ctrl_0{
    compatible = "generic-uio";
};

```

This will add this configuration options to the device tree when you recompile the project. The actual stuff that you put here is quite a long story and needs some more explanation.

the bootargs line is mostly default except that we add "uio_pdrv_genirq.of_id=generic-uio" to the end of it. I think this is matching the interrupts to the generic-uio driver. It dosent work without the line so ya. 

The second section starting with "&axi_bram_ctrl_0" is modifiying the device tree entry for our bram on the fpga. The default configuration does not include the line "compatible = "generic-uio"" which tells the linux kernel that our bram uses the generic uio driver. This associates our bram with the generic-uio driver with the block ram on the fpga.

Now we can rebuild the project 

```bash
petalinux-build
```

Once thats done run the following command to package all of the necessary stuff so that you can put in on the sd card for the board.

```bash
petalinux-package --boot --fsbl --fpga --u-boot --force
```

Now to actually get these files onto the sd card to boot the board use the following commands. These will copy the files from the "images/linux" folder to a correctly formatted SD card attached to "/media/philip/BOOT"

Run these commands from the base petalinux project directory

```bash
sudo cp images/linux/BOOT.BIN /media/philip/BOOT/
sudo cp images/linux/image.ub /media/philip/BOOT/
sudo cp images/linux/system.dtb /media/philip/BOOT/
```

```bash
sudo tar xvf /<petalinux project dir>/images/linux/rootfs.tar.gz -C /media/rootfs/
```

Once it is connected, use the following command to open up the serial terminal on desktop

```bash
gtkterm -c snickerdoodle
```