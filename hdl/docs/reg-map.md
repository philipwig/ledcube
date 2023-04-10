# Reg map of ctrl and data interfaces

## Ctrl

```
0x40000000 ctrl_display
    ctrl_en = ctrl_display[0];
    ctrl_rst = ctrl_display[1];
0x40000000 ctrl_n_rows
0x40000004 ctrl_n_cols
0x40000008 ctrl_bitdepth
0x4000000C ctrl_lsb_blank
0x40000010 ctrl_brightness
0x40000014 ctrl_buffer
```

## Data

```
0x40010000 0
0x40010004 1
0x40010008 2
0x4001000C 3
.
.
.
0x40010080 31
0x40010084 32
0x40010088 33
.
.
.
```

Where each new entry is a new pixel
