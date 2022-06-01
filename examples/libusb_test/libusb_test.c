#include <stdio.h>
#include <stdlib.h>
#include </usr/include/libusb-1.0/libusb.h>

int main() {
	libusb_context *ctx;
	int err = libusb_init(&ctx);
	if (err)
		return 0;
	
	libusb_device **dev_list;
	
	ssize_t num_devs = libusb_get_device_list(ctx, &dev_list);

	printf("Number of Devices: %ld\n", num_devs);
}
