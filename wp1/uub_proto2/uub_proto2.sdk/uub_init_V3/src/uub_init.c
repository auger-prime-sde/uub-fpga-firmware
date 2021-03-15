/*
 * uub_init.c
 *  Intitialization for UUB V3 layout
 *  Created on: may 2019
 *      Author: Roberto Assiro
 */

// UUB initialization file
#include <fcntl.h>
#include <stdio.h>
#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <linux/types.h>
#include <linux/spi/spidev.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>


#define IIC_SLAVE_SI5347         0x6C  // The slave address Cleaner Jitter on I2C-1
#define BUF_SIZE                35 // Tansmit and receive buffer size
#define RCV_BUF_SIZE           256 // Tansmit and receive buffer size
#define nb_initData_SI5347    1560 // Nb init data for SI5347 component

//static u8 RecvBuffer[RCV_BUF_SIZE] = {0x00}; /* Buffer for Receiving Data */

char fake1[2];
char fake2[2];

char set[]={0xFE,0x01,0x00,0x1E,0x02};

char buf[]=
  { 0x0B,0x24,0xD8,0x0B,0x25,0x00,                                              // bank 0xB
    0x00,0x0B,0x6C,0x00,0x16,0x0F,0x00,0x17,0x3C,0x00,0x18,0xFF,0x00,0x19,0xFF, // bank 0
    0x00,0x1A,0xFF,0x00,0x20,0x00,0x00,0x2B,0x0A,0x00,0x2C,0x01,0x00,0x2D,0x01,
    0x00,0x2E,0xE4,0x00,0x2F,0x00,0x00,0x30,0x00,0x00,0x31,0x00,0x00,0x32,0x00,
    0x00,0x33,0x00,0x00,0x34,0x00,0x00,0x35,0x00,0x00,0x36,0xE4,0x00,0x37,0x00,
    0x00,0x38,0x00,0x00,0x39,0x00,0x00,0x3A,0x00,0x00,0x3B,0x00,0x00,0x3C,0x00,
    0x00,0x3D,0x00,0x00,0x3F,0x11,0x00,0x40,0x04,0x00,0x41,0x0D,0x00,0x42,0x00,
    0x00,0x43,0x00,0x00,0x44,0x00,0x00,0x45,0x0C,0x00,0x46,0x32,0x00,0x47,0x00,
    0x00,0x48,0x00,0x00,0x49,0x00,0x00,0x4A,0x32,0x00,0x4B,0x00,0x00,0x4C,0x00,
    0x00,0x4D,0x00,0x00,0x4E,0x05,0x00,0x4F,0x00,0x00,0x51,0x03,0x00,0x52,0x00,
    0x00,0x53,0x00,0x00,0x54,0x00,0x00,0x55,0x03,0x00,0x56,0x00,0x00,0x57,0x00,
    0x00,0x58,0x00,0x00,0x59,0x03,0x00,0x5A,0x00,0x00,0x5B,0x00,0x00,0x5C,0x40,
    0x00,0x5D,0x01,0x00,0x5E,0x00,0x00,0x5F,0x00,0x00,0x60,0x00,0x00,0x61,0x00,
    0x00,0x62,0x00,0x00,0x63,0x00,0x00,0x64,0x00,0x00,0x65,0x00,0x00,0x66,0x00,
    0x00,0x67,0x00,0x00,0x68,0x00,0x00,0x69,0x00,0x00,0x92,0x00,0x00,0x93,0x00,
    0x00,0x94,0x00,0x00,0x95,0x00,0x00,0x96,0x00,0x00,0x97,0x00,0x00,0x98,0x00,
    0x00,0x99,0x00,0x00,0x9A,0x01,0x00,0x9B,0x03,0x00,0x9C,0x00,0x00,0x9D,0x00,
    0x00,0x9E,0x02,0x00,0x9F,0x00,0x00,0xA0,0x00,0x00,0xA1,0x00,0x00,0xA2,0x01,
    0x00,0xA3,0xB8,0x00,0xA4,0x32,0x00,0xA5,0x01,0x00,0xA6,0x00,0x00,0xA7,0x00,
    0x00,0xA8,0x00,0x00,0xA9,0x00,0x00,0xAA,0x00,0x00,0xAB,0x00,0x00,0xAC,0x00,
    0x00,0xAD,0x00,0x00,0xAE,0x00,0x00,0xAF,0x00,0x00,0xB0,0x00,0x00,0xB1,0x00,
    0x00,0xB2,0x00,0x00,0xB3,0x00,0x00,0xB4,0x00,0x00,0xB5,0x00,0x00,0xB6,0x00,
    0x01,0x02,0x01,0x01,0x08,0x02,0x01,0x09,0x09,0x01,0x0A,0x3D,0x01,0x0B,0x00, // bank 1
    0x01,0x0C,0x01,0x01,0x12,0x02,0x01,0x13,0x09,0x01,0x14,0x3D,0x01,0x15,0x00,
    0x01,0x16,0x01,0x01,0x17,0x02,0x01,0x18,0x09,0x01,0x19,0x3D,0x01,0x1A,0x00,
    0x01,0x1B,0x01,0x01,0x1C,0x02,0x01,0x1D,0x09,0x01,0x1E,0x3D,0x01,0x1F,0x00,
    0x01,0x20,0x01,0x01,0x26,0x02,0x01,0x27,0x09,0x01,0x28,0x3D,0x01,0x29,0x00,
    0x01,0x2A,0x01,0x01,0x2B,0x02,0x01,0x2C,0x09,0x01,0x2D,0x3D,0x01,0x2E,0x00,
    0x01,0x2F,0x01,0x01,0x30,0x01,0x01,0x31,0x09,0x01,0x32,0x3B,0x01,0x33,0x00,
    0x01,0x34,0x00,0x01,0x3A,0x01,0x01,0x3B,0x09,0x01,0x3C,0x3B,0x01,0x3D,0x00,
    0x01,0x3E,0x00,0x01,0x3F,0x00,0x01,0x40,0x00,0x01,0x41,0x40,0x01,0x42,0xFF,
    0x02,0x02,0x00,0x02,0x03,0x00,0x02,0x04,0x00,0x02,0x05,0x00,0x02,0x06,0x00, // bank 2
    0x02,0x08,0x3C,0x02,0x09,0x00,0x02,0x0A,0x00,0x02,0x0B,0x00,0x02,0x0C,0x00,
    0x02,0x0D,0x00,0x02,0x0E,0x01,0x02,0x0F,0x00,0x02,0x10,0x00,0x02,0x11,0x00,
    0x02,0x12,0x00,0x02,0x13,0x00,0x02,0x14,0x00,0x02,0x15,0x00,0x02,0x16,0x00,
    0x02,0x17,0x00,0x02,0x18,0x00,0x02,0x19,0x00,0x02,0x1A,0x00,0x02,0x1B,0x00,
    0x02,0x1C,0x00,0x02,0x1D,0x00,0x02,0x1E,0x00,0x02,0x1F,0x00,0x02,0x20,0x00,
    0x02,0x21,0x00,0x02,0x22,0x00,0x02,0x23,0x00,0x02,0x24,0x00,0x02,0x25,0x00,
    0x02,0x26,0x00,0x02,0x27,0x00,0x02,0x28,0x00,0x02,0x29,0x00,0x02,0x2A,0x00,
    0x02,0x2B,0x00,0x02,0x2C,0x00,0x02,0x2D,0x00,0x02,0x2E,0x00,0x02,0x2F,0x00,
    0x02,0x31,0x01,0x02,0x32,0x01,0x02,0x33,0x01,0x02,0x34,0x01,0x02,0x35,0x00,
    0x02,0x36,0x00,0x02,0x37,0x00,0x02,0x38,0x00,0x02,0x39,0x94,0x02,0x3A,0x00,
    0x02,0x3B,0x00,0x02,0x3C,0x00,0x02,0x3D,0x00,0x02,0x3E,0x80,0x02,0x40,0x00,
    0x02,0x41,0x00,0x02,0x42,0x00,0x02,0x43,0x00,0x02,0x44,0x00,0x02,0x45,0x00,
    0x02,0x46,0x00,0x02,0x4A,0x02,0x02,0x4B,0x00,0x02,0x4C,0x00,0x02,0x50,0x02,
    0x02,0x51,0x00,0x02,0x52,0x00,0x02,0x53,0x02,0x02,0x54,0x00,0x02,0x55,0x00,
    0x02,0x56,0x02,0x02,0x57,0x00,0x02,0x58,0x00,0x02,0x5C,0x02,0x02,0x5D,0x00,
    0x02,0x5E,0x00,0x02,0x5F,0x02,0x02,0x60,0x00,0x02,0x61,0x00,0x02,0x62,0x00,
    0x02,0x63,0x00,0x02,0x64,0x00,0x02,0x68,0x00,0x02,0x69,0x00,0x02,0x6A,0x00,
    0x02,0x6B,0x30,0x02,0x6C,0x00,0x02,0x6D,0x00,0x02,0x6E,0x00,0x02,0x6F,0x00,
    0x02,0x70,0x00,0x02,0x71,0x00,0x02,0x72,0x00,
    0x03,0x02,0x00,0x03,0x03,0x00,0x03,0x04,0x00,0x03,0x05,0x80,0x03,0x06,0x12, // bank 3
    0x03,0x07,0x00,0x03,0x08,0x00,0x03,0x09,0x00,0x03,0x0A,0x00,0x03,0x0B,0xF0,
    0x03,0x0D,0x00,0x03,0x0E,0x00,0x03,0x0F,0x00,0x03,0x10,0x80,0x03,0x11,0x00,
    0x03,0x12,0x00,0x03,0x13,0x00,0x03,0x14,0x00,0x03,0x15,0x00,0x03,0x16,0x80,
    0x03,0x18,0x00,0x03,0x19,0x00,0x03,0x1A,0x00,0x03,0x1B,0x80,0x03,0x1C,0x00,
    0x03,0x1D,0x00,0x03,0x1E,0x00,0x03,0x1F,0x00,0x03,0x20,0x00,0x03,0x21,0x80,
    0x03,0x23,0x00,0x03,0x24,0x00,0x03,0x25,0x00,0x03,0x26,0x80,0x03,0x27,0x00,
    0x03,0x28,0x00,0x03,0x29,0x00,0x03,0x2A,0x00,0x03,0x2B,0x00,0x03,0x2C,0x80,
    0x03,0x39,0x00,0x03,0x3B,0x00,0x03,0x3C,0x00,0x03,0x3D,0x00,0x03,0x3E,0x00,
    0x03,0x3F,0x00,0x03,0x40,0x00,0x03,0x41,0x00,0x03,0x42,0x00,0x03,0x43,0x00,
    0x03,0x44,0x00,0x03,0x45,0x00,0x03,0x46,0x00,0x03,0x47,0x00,0x03,0x48,0x00,
    0x03,0x49,0x00,0x03,0x4A,0x00,0x03,0x4B,0x00,0x03,0x4C,0x00,0x03,0x4D,0x00,
    0x03,0x4E,0x00,0x03,0x4F,0x00,0x03,0x50,0x00,0x03,0x51,0x00,0x03,0x52,0x00,
    0x04,0x02,0x01,0x04,0x08,0x10,0x04,0x09,0x22,0x04,0x0A,0x09,0x04,0x0B,0x08, // bank 4
    0x04,0x0C,0x1F,0x04,0x0D,0x3F,0x04,0x0E,0x10,0x04,0x0F,0x24,0x04,0x10,0x09,
    0x04,0x11,0x08,0x04,0x12,0x1F,0x04,0x13,0x3F,0x04,0x15,0x00,0x04,0x16,0x00,
    0x04,0x17,0x00,0x04,0x18,0x00,0x04,0x19,0xB4,0x04,0x1A,0x00,0x04,0x1B,0x00,
    0x04,0x1C,0x00,0x04,0x1D,0x00,0x04,0x1E,0x00,0x04,0x1F,0x80,0x04,0x21,0x31,
    0x04,0x22,0x01,0x04,0x23,0xE3,0x04,0x24,0xA5,0x04,0x25,0x9B,0x04,0x26,0x04,
    0x04,0x27,0x00,0x04,0x28,0x00,0x04,0x29,0x00,0x04,0x2A,0x00,0x04,0x2B,0x01,
    0x04,0x2C,0x0F,0x04,0x2D,0x03,0x04,0x2E,0x15,0x04,0x2F,0x13,0x04,0x31,0x00,
    0x04,0x32,0x42,0x04,0x33,0x03,0x04,0x34,0x00,0x04,0x36,0x0C,0x04,0x37,0x00,
    0x04,0x38,0x01,0x04,0x39,0x00,
    0x05,0x02,0x01,0x05,0x08,0x00,0x05,0x09,0x00,0x05,0x0A,0x00,0x05,0x0B,0x00, // bank 5
    0x05,0x0C,0x00,0x05,0x0D,0x00,0x05,0x0E,0x00,0x05,0x0F,0x00,0x05,0x10,0x00,
    0x05,0x11,0x00,0x05,0x12,0x00,0x05,0x13,0x00,0x05,0x15,0x00,0x05,0x16,0x00,
    0x05,0x17,0x00,0x05,0x18,0x80,0x05,0x19,0x00,0x05,0x1A,0x00,0x05,0x1B,0x00,
    0x05,0x1C,0x00,0x05,0x1D,0x00,0x05,0x1E,0x00,0x05,0x1F,0x80,0x05,0x21,0x21,
    0x05,0x22,0x01,0x05,0x23,0x00,0x05,0x24,0x00,0x05,0x25,0x00,0x05,0x26,0x00,
    0x05,0x27,0x00,0x05,0x28,0x00,0x05,0x29,0x00,0x05,0x2A,0x01,0x05,0x2B,0x01,
    0x05,0x2C,0x0F,0x05,0x2D,0x03,0x05,0x2E,0x00,0x05,0x2F,0x00,0x05,0x31,0x00,
    0x05,0x32,0x00,0x05,0x33,0x04,0x05,0x34,0x00,0x05,0x36,0x0E,0x05,0x37,0x00,
    0x05,0x38,0x00,0x05,0x39,0x00,
    0x06,0x02,0x01,0x06,0x08,0x00,0x06,0x09,0x00,0x06,0x0A,0x00,0x06,0x0B,0x00, // bank 6
    0x06,0x0C,0x00,0x06,0x0D,0x00,0x06,0x0E,0x00,0x06,0x0F,0x00,0x06,0x10,0x00,
    0x06,0x11,0x00,0x06,0x12,0x00,0x06,0x13,0x00,0x06,0x15,0x00,0x06,0x16,0x00,
    0x06,0x17,0x00,0x06,0x18,0x80,0x06,0x19,0x00,0x06,0x1A,0x00,0x06,0x1B,0x00,
    0x06,0x1C,0x00,0x06,0x1D,0x00,0x06,0x1E,0x00,0x06,0x1F,0x80,0x06,0x21,0x21,
    0x06,0x22,0x01,0x06,0x23,0x00,0x06,0x24,0x00,0x06,0x25,0x00,0x06,0x26,0x00,
    0x06,0x27,0x00,0x06,0x28,0x00,0x06,0x29,0x00,0x06,0x2A,0x00,0x06,0x2B,0x01,
    0x06,0x2C,0x0F,0x06,0x2D,0x03,0x06,0x2E,0x00,0x06,0x2F,0x00,0x06,0x31,0x00,
    0x06,0x32,0x00,0x06,0x33,0x04,0x06,0x34,0x00,0x06,0x36,0x0E,0x06,0x37,0x00,
    0x06,0x38,0x00,0x06,0x39,0x00,
    0x07,0x02,0x01,0x07,0x09,0x00,0x07,0x0A,0x00,0x07,0x0B,0x00,0x07,0x0C,0x00, // bank 7
    0x07,0x0D,0x00,0x07,0x0E,0x00,0x07,0x0F,0x00,0x07,0x10,0x00,0x07,0x11,0x00,
    0x07,0x12,0x00,0x07,0x13,0x00,0x07,0x14,0x00,0x07,0x16,0x00,0x07,0x17,0x00,
    0x07,0x18,0x00,0x07,0x19,0x80,0x07,0x1A,0x00,0x07,0x1B,0x00,0x07,0x1C,0x00,
    0x07,0x1D,0x00,0x07,0x1E,0x00,0x07,0x1F,0x00,0x07,0x20,0x80,0x07,0x22,0x21,
    0x07,0x23,0x01,0x07,0x24,0x00,0x07,0x25,0x00,0x07,0x26,0x00,0x07,0x27,0x00,
    0x07,0x28,0x00,0x07,0x29,0x00,0x07,0x2A,0x00,0x07,0x2B,0x00,0x07,0x2C,0x01,
    0x07,0x2D,0x0F,0x07,0x2E,0x03,0x07,0x2F,0x00,0x07,0x30,0x00,0x07,0x32,0x00,
    0x07,0x33,0x00,0x07,0x34,0x04,0x07,0x35,0x00,0x07,0x37,0x0E,0x07,0x38,0x00,
    0x07,0x39,0x00,0x07,0x3A,0x00,
    0x09,0x0E,0x02,0x09,0x43,0x00,0x09,0x49,0x01,0x09,0x4A,0x01,                // bank 9
    0x0A,0x03,0x01,0x0A,0x04,0x00,0x0A,0x05,0x01,                               // bank A
    0x0B,0x44,0xEF,0x0B,0x45,0x0E,0x0B,0x46,0x00,0x0B,0x47,0x00,0x0B,0x48,0x0E,
    0x0B,0x4A,0x0E,                                                             // bank B
    0x04,0x14,0x01,                                                             // bank 4
    0x00,0x1C,0x01,                                                             // bank 0
    0x0B,0x24,0xDB,0x0B,0x25,0x02};                                             // bank B

char ADC_LVDS[3] = { 0x00, 0x14, 0xA0 }; // ADC bus configuration LVDS interleave
char ADC_LVDS_INV[3] = { 0x00, 0x14, 0xA4 }; // ADC bus configuration LVDS interleave and inverted inputs enabled
char ADC_RESET[3] = { 0x00, 0x00, 0x3C }; // ADC reset
char ADC_VREF[3] = { 0x00, 0x18, 0x04 }; // ADC VREF setting
char ADC_PDWN[3] = { 0x00, 0x08, 0x00 }; // ADC PDWN setting normal operation
char ADC_DIG_RES[3] = { 0x00, 0x08, 0x03 }; // ADC PWRD reset setting
char ADC_DELAY[3] = { 0x00, 0x17, 0x25 }; // ADC delay

char cmd2channel[3] = { 0x00, 0x05, 0x03 }; // Select the 2 channels for previous cmd
char cmdchannelA[3] = { 0x00, 0x05, 0x01 }; // Select the channel A for previous cmd
char cmdchannelB[3] = { 0x00, 0x05, 0x02 }; // Select the channel B for previous cmd

char TestModeMS[3] = { 0x00, 0x0D, 0x01 }; // ADC Test Mode Middle Scale
char TestModeFS[3] = { 0x00, 0x0D, 0x02 }; // ADC Test Mode Full Scale
char NormalMode[3] = { 0x00, 0x0D, 0x00 }; // ADC Normal mode
char TestModeRM[3] = { 0x00, 0x0D, 0x5F }; // ADC Test Mode Ramp
char TestModeA5[3] = { 0x00, 0x0D, 0x44 }; // ADC Test Mode AAA555

char TstUser1LSB[3] = { 0x00, 0x19, 0x55 }; // User defined pattern 1 LSB
char TstUser1MSB[3] = { 0x00, 0x1A, 0xAA }; // User defined pattern 1 MSB
char TestModeUM[3] = { 0x00, 0x0D, 0x08 }; // ADC Test Mode USER1
char AdcDelay[5] = { 0x00 };           // Calculated ADC delay table

static uint8_t mode = 0;
static uint8_t bits = 8;
static uint32_t speed = 5000000;

static void pabort(const char *s) {
	perror(s);
	abort();
}

int verifyCommand(int fd, char *command) {
	struct spi_ioc_transfer xfer[2];
	unsigned char buf[3];
	int status, address;

	memset(xfer, 0, sizeof xfer);
	memset(buf, 0, sizeof buf);

	address = ((0x1f & command[0])<<16)|command[1];

	/* Read one byte register */
	buf[0] = 0x80 | (0x1f & command[0]);
	buf[1] = command[1];

	xfer[0].tx_buf = (unsigned long) buf;
	xfer[0].len = 2;

	xfer[1].rx_buf = (unsigned long) buf;
	xfer[1].len = 1;

	status = ioctl(fd, SPI_IOC_MESSAGE(2), xfer);
	if (status < 0) {
		perror("SPI_IOC_MESSAGE");
		return 1;
	}
	// printf("Address Written Read : %04x %02x %02x\n", address, command[2], buf[0]);
	return (buf[0] != command[2]);
}

int main() {
	int file, k;
	char filename[20];


	// enable of front-end prova effettuata il 5 luglio
/*	system ("slowc -d 1");	// enable on
	printf("Front end power... OK\n\r");
	sleep(2);*/

// JITTER CLEANER INITIALIZATION

	int addr = 0x6C; /* The I2C address Jitter cleaner*/
	printf("Initialization of Jitter Cleaner..... ");
	snprintf(filename, 19, "/dev/i2c-1");
	file = open(filename, O_RDWR);
	if (file < 0) {
			exit(1);
	}

	if (ioctl(file, I2C_SLAVE, addr) < 0) {
			exit(2);
	}

	write(file, set, sizeof(set)); // Hard reset generated
	usleep (500); //RITARDO DA SOSTITUIRE CON LETTURA DEVICE READY

// register initialization for accessing to the Page 0x0 to make hard RESET
	for ( k = 0; k < nb_initData_SI5347; k=k+3)
	    {
		fake1[0]=0x01;
		fake1[1]=buf[k];
		fake2[0]=buf[k+1];
		fake2[1]=buf[k+2];
		write(file, fake1,sizeof(fake1));
		write(file, fake2,sizeof(fake2));
	    }

	printf("OK\n\r");


//********************************************
//*    Is Jitter Cleaner Ready ?
//********************************************

	usleep (200000);


//********************************************
//		ADC power up
//********************************************
	system ("slowc -L 3");
	usleep (100000);
	system ("slowc -L 1");
	printf("Initialization of ADCs power supply... OK\n\r");
	usleep (500000);

	// ADC POWER DOWN PIN
	system ("power_down > /dev/null &");	// attivo il pwd pin degli adc
	printf("Initialization of ADCs PWD... OK\n\r");

//////////////////////// SPI CONFIGURATION ///////////////////////////////////////
	int i, fd;
	int ret = 0;
	int adc_ok = 1;
	printf("Initialization of ADCs on SPI-0... ");
	for (i = 0; i < 5; i++) {
		snprintf(filename, 19, "/dev/spidev32766.%d", i);
		fd = open(filename, O_RDWR);
		if (fd < 0)
			pabort("can't open device");
		// spi mode
		ret = ioctl(fd, SPI_IOC_WR_MODE, &mode);
		if (ret == -1)
			pabort("can't set spi mode");

		ret = ioctl(fd, SPI_IOC_RD_MODE, &mode);
		if (ret == -1)
			pabort("can't get spi mode");

		// bits per word
		ret = ioctl(fd, SPI_IOC_WR_BITS_PER_WORD, &bits);
		if (ret == -1)
			pabort("can't set bits per word");

		ret = ioctl(fd, SPI_IOC_RD_BITS_PER_WORD, &bits);
		if (ret == -1)
			pabort("can't get bits per word");

		// max speed hz
		ret = ioctl(fd, SPI_IOC_WR_MAX_SPEED_HZ, &speed);
		if (ret == -1)
			pabort("can't set max speed hz");

		ret = ioctl(fd, SPI_IOC_RD_MAX_SPEED_HZ, &speed);
		if (ret == -1)
			pabort("can't get max speed hz");

		if (write(fd, cmd2channel, sizeof(cmd2channel))
				!= sizeof(cmd2channel)) {
			exit(3);
		}
		adc_ok &= verifyCommand(fd, cmd2channel);
		if (write(fd, ADC_DIG_RES, sizeof(ADC_DIG_RES))
				!= sizeof(ADC_DIG_RES)) {
			exit(3);
		}
		adc_ok &= verifyCommand(fd, ADC_DIG_RES);
		if (write(fd, ADC_PDWN, sizeof(ADC_PDWN)) != sizeof(ADC_PDWN)) {
			exit(3);
		}
		adc_ok &= verifyCommand(fd, ADC_PDWN);
		if (write(fd, ADC_RESET, sizeof(ADC_RESET)) != sizeof(ADC_RESET)) {
			exit(3);
		}
		ret = verifyCommand(fd, ADC_RESET);


		// inversion
	//	if (write(fd, ADC_LVDS, sizeof(ADC_LVDS)) != sizeof(ADC_LVDS)) {	// ADC input not inverted
		if (write(fd, ADC_LVDS_INV, sizeof(ADC_LVDS_INV))!= sizeof(ADC_LVDS_INV)) {	// ADC input inverted
			exit(3);
		}

	//	adc_ok &= verifyCommand(fd, ADC_LVDS);
		adc_ok &= verifyCommand(fd, ADC_LVDS_INV);

		if (write(fd, ADC_VREF, sizeof(ADC_VREF)) != sizeof(ADC_VREF)) {
			exit(3);
		}
		adc_ok &= verifyCommand(fd, ADC_VREF);
		if (write(fd, NormalMode, sizeof(NormalMode)) != sizeof(NormalMode)) {
			exit(3);
		}
		adc_ok = verifyCommand(fd, NormalMode);
	}
	close(fd);
	usleep(100);

	printf("OK\n\r");

system ("stty -F /dev/ttyUL1 9600");
system ("stty -F /dev/ttyUL2 115200");
system ("stty -F /dev/ttyPS0 38400");
printf("Initialization of UARTs: ttyUL1, ttyPS0, ttyUL2... OK\n\r");

// Userspace I/O settings - november 2016
system ("modprobe uio");
system ("modprobe uio_pdrv_genirq");
printf("Initialization of UIO... OK\n\r");

// Clock setting - DAC7551 init - (removed on UUB_V3)
//system ("dac7551");

// WATCHDOG - february 2018 - NEW WATCHDOG SYSTEM UUB V2
system ("slowc -w 0 > /dev/null &");	// attivo il watchdog sullo slowc
system ("watchd > /dev/null &");		// lancio processo di gestione watchdog
printf("Initialization of Watchdog... OK\n\r");


system ("check-boot");		// control if started from recovery to run auto fixing

}


