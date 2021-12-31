#ifndef COLOR_H
#define COLOR_H

#include <stdint.h>

#if !defined(RGB565_ORDER_RGB) && !defined(RGB565_ORDER_BGR)
#define RGB565_ORDER_RGB
#endif

typedef unsigned char byte;
typedef unsigned int uint;

// Colors
typedef struct RGB {
	byte red;
	byte green;
	byte blue;
	byte alpha;
} RGB;

typedef struct HSV {
	byte h;
	byte s;
	byte v;
	byte pad; // yay, more padding.
} HSV;

extern RGB HSV2RGB(HSV hsv);
extern HSV RGB2HSV(RGB rgb);
extern RGB RGBlerp(byte v, RGB rgbA, RGB rgbB);

// Macro for painless colors.
#define RGB_C(r, g, b) ((RGB) { .red = (byte) (r), .green = (byte) (g), .blue = (byte) (b), .alpha = 255 } )
#define HSV_C(hue, sat, val) ((HSV) { .h = (byte) (hue), .s = (byte) (sat), .v = (byte) (val), .pad = 0 } )

#define RGB(r, g, b) RGB_C(r, g, b)
#define HSV(h, s, v) HSV_C(h, s, v)

static inline uint16_t RGB2RGB565(RGB color) {
	byte b = (color.blue  * 249 + 1014) >> 11;
	byte g = (color.green * 243 +  505) >> 10;
	byte r = (color.red   * 249 + 1014) >> 11;

#if defined(RGB565_ORDER_RGB)
	return (uint16_t) ((r << 11) | (g << 5) | b);
#elif defined(RGB565_ORDER_BGR)
	return (uint16_t) ((b << 11) | (g << 5) | r);
#endif
}

static inline RGB RGB5652RGB(uint16_t color) {
	uint8_t r5 = (color >> 11) & 0x1F;
	uint8_t g6 = (color >> 5) & 0x3F;
	uint8_t b5 = (color & 0x1F);

	uint8_t r = ((r5 * 527) + 23) >> 6;
	uint8_t g = ((g6 * 259) + 33) >> 6;
	uint8_t b = ((b5 * 527) + 23) >> 6;

#if defined(RGB565_ORDER_RGB)
	return RGB(r, g, b);
#elif defined(RGB565_ORDER_BGR)
	return RGB(b, g, r);
#endif
}

static inline uint32_t RGB2UINT(RGB color) {
	return (color.red << 8*2) | (color.green << 8*1) | (color.blue << 8*0);
}

#endif
