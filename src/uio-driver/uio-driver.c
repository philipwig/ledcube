#include "include/uio_helper.h"
#include "include/color.h"


#include <stdio.h>




// ********************** Config **************************


int get_x_width() {

}

int get_y_width() {

}

static void show_device(struct uio_info_t *info)
{
	char dev_name[16];
	sprintf(dev_name,"uio%d",info->uio_num);
	printf("%s: name=%s, version=%s, events=%d\n",
	       dev_name, info->name, info->version, info->event_count);
}

static int show_map(struct uio_info_t *info, int map_num)
{
	if (info->maps[map_num].size <= 0)
		return -1;

	printf("\tmap[%d]: addr=0x%08X, size=%d",
	       map_num,
	       info->maps[map_num].addr,
	       info->maps[map_num].size);

	printf(", mmap test: ");
	switch (info->maps[map_num].mmap_result) {
		case UIO_MMAP_NOT_DONE:
			printf("N/A");
			break;
		case UIO_MMAP_OK:
			printf("OK");
			break;
		default:
			printf("FAILED");
	}
	
	printf("\n");
	return 0;
}

static void show_dev_attrs(struct uio_info_t *info)
{
	struct uio_dev_attr_t *attr = info->dev_attrs;
	if (attr)
		printf("\tDevice attributes:\n");
	else
		printf("\t(No device attributes)\n");

	while (attr) {
		printf("\t%s=%s\n", attr->name, attr->value);
		attr = attr->next;
	}

}

static void show_maps(struct uio_info_t *info)
{
	int ret;
	int mi = 0;
	do {
		ret = show_map(info, mi);
		mi++;
	} while ((ret == 0)&&(mi < MAX_UIO_MAPS));
}

static void show_uio_info(struct uio_info_t *info)
{
	show_device(info);
	show_maps(info);
	show_dev_attrs(info);
}



int init() {
	struct uio_info_t *info_list, *p;
    int filter_num = -1;

    info_list = uio_find_devices(filter_num);
	if (!info_list)
		printf("No UIO devices found.\n");

	p = info_list;

	while (p) {
		uio_get_all_info(p);
		uio_get_device_attributes(p);
		uio_mmap_test(p);
		show_uio_info(p);
		p = p->next;
	}

	uio_free_info(info_list);
}







// *************** Display Functions ************************


int set_pixel(int x, int y, RGB color) {

}

int get_pixel(int x, int y) {

}

int fill_display(RGB color) {

}

int clear_display() {

}




