/*
   uio_helper.c
   UIO helper functions.

   Copyright (C) 2007 Hans J. Koch

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License version 2 as
   published by the Free Software Foundation.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/

#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>

#include <dirent.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

#include "uio_helper.h"

int uio_get_mem_size(struct uio_info_t* info, int map_num)
{
	int ret;
	char filename[64];
	info->maps[map_num].size = UIO_INVALID_SIZE;
	sprintf(filename, "/sys/class/uio/uio%d/maps/map%d/size",
		info->uio_num, map_num);
	FILE* file = fopen(filename,"r");
	if (!file) return -1;
	ret = fscanf(file,"0x%x",&info->maps[map_num].size);
	fclose(file);
	if (ret<0) return -2;
	return 0;
}

int uio_get_mem_addr(struct uio_info_t* info, int map_num)
{
	int ret;
	char filename[64];
	info->maps[map_num].addr = UIO_INVALID_ADDR;
	sprintf(filename, "/sys/class/uio/uio%d/maps/map%d/addr",
		info->uio_num, map_num);
	FILE* file = fopen(filename,"r");
	if (!file) return -1;
	ret = fscanf(file,"0x%x",&info->maps[map_num].addr);
	fclose(file);
	if (ret<0) return -2;
	return 0;
}


int line_from_file(char *filename, char *linebuf)
{
	char *s;
	int i;
	memset(linebuf, 0, UIO_MAX_NAME_SIZE);
	FILE* file = fopen(filename,"r");
	if (!file) return -1;
	s = fgets(linebuf,UIO_MAX_NAME_SIZE,file);
	if (!s) return -2;
	for (i=0; (*s)&&(i<UIO_MAX_NAME_SIZE); i++) {
		if (*s == '\n') *s = 0;
		s++;
	}
	return 0;
}

int uio_get_name(struct uio_info_t* info)
{
	char filename[64];
	sprintf(filename, "/sys/class/uio/uio%d/name", info->uio_num);

	return line_from_file(filename, info->name);
}

int uio_get_version(struct uio_info_t* info)
{
	char filename[64];
	sprintf(filename, "/sys/class/uio/uio%d/version", info->uio_num);

	return line_from_file(filename, info->version);
}

int uio_get_all_info(struct uio_info_t* info)
{
	int i;
	if (!info)
		return -1;
	if ((info->uio_num < 0)||(info->uio_num > UIO_MAX_NUM))
		return -1;
	for (i = 0; i < MAX_UIO_MAPS; i++) {
		uio_get_mem_size(info, i);
		uio_get_mem_addr(info, i);
	}
	uio_get_name(info);
	uio_get_version(info);
	return 0;
}

void uio_free_info(struct uio_info_t* info)
{
	struct uio_info_t *p1,*p2;
	p1 = info;
	while (p1) {
		p2 = p1->next;
		free(p1);
		p1 = p2;
	}
}

int uio_num_from_filename(char* name)
{
	enum scan_states { ss_u, ss_i, ss_o, ss_num, ss_err };
	enum scan_states state = ss_u;
	int i=0, num = -1;
	char ch = name[0];
	while (ch && (state != ss_err)) {
		switch (ch) {
			case 'u': if (state == ss_u) state = ss_i;
				  else state = ss_err;
				  break;
			case 'i': if (state == ss_i) state = ss_o;
				  else state = ss_err;
				  break;
			case 'o': if (state == ss_o) state = ss_num;
				  else state = ss_err;
				  break;
			default:  if (  (ch>='0') && (ch<='9')
				      &&(state == ss_num) ) {
					if (num < 0) num = (ch - '0');
					else num = (num * 10) + (ch - '0');
				  }
				  else state = ss_err;
		}
		i++;
		ch = name[i];
	}
	if (state == ss_err) num = -1;
	return num;
}

struct uio_info_t* info_from_name(char* name, int filter_num)
{
	struct uio_info_t* info;
	int num = uio_num_from_filename(name);
	if (num < 0)
		return NULL;
	if ((filter_num >= 0) && (num != filter_num))
		return NULL;

	info = (struct uio_info_t *) malloc(sizeof(struct uio_info_t));
	if (!info)
		return NULL;
	memset(info,0,sizeof(struct uio_info_t));
	info->uio_num = num;

	return info;
}

struct uio_info_t* uio_find_devices(int filter_num)
{
	struct dirent **namelist;
	struct uio_info_t *infolist = NULL, *infp, *last;
	int n;

	n = scandir("/sys/class/uio", &namelist, 0, alphasort);
	if (n < 0)
		return NULL;

	while(n--) {
		infp = info_from_name(namelist[n]->d_name, filter_num);
		free(namelist[n]);
		if (!infp)
			continue;
		if (!infolist)
			infolist = infp;
		else
			last->next = infp;
		last = infp;
	}
	free(namelist);

	return infolist;
}