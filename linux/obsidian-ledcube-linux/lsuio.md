Took bitbake recipe from https://github.com/carlesfernandez/meta-gnss-sdr/tree/master/recipes-devtools/lsuio

Create app in petalinux
`petalinux-create -t apps --name lsuio --enable`

Then delete everything copy in the `lsuio_0.2.0.bb` file.
Change the `SECTION` line to `SECTION = "PETALINUX/apps"` (maybe needed?)

Check compile with `petalinux-build -c lsuio`

## lsuio usage
Run `lsuio -vm`
`-v` verbose output
`-m` test if nmap works

Might have to run with sudo for nmap to work
