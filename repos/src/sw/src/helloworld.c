/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "sensor_config.h"
//#include "xgpio_l.h"
#include "sleep.h"
#include "xiic.h"
#include "xil_exception.h"
#include "xil_cache.h"
#include "adv7533.h"
//#include "xscugic.h"
#include "xilinx-gamma-coeff.h"
#include "xdsitxss.h"
#include "xv_gamma_lut.h"
//#include "xiicps.h"
#define TXT_RED     "\x1b[31m"
#define TXT_GREEN   "\x1b[32m"
#define TXT_YELLOW  "\x1b[33m"
#define TXT_BLUE    "\x1b[34m"
#define TXT_MAGENTA "\x1b[35m"
#define TXT_CYAN    "\x1b[36m"
#define TXT_RST   "\x1b[0m"



uint8_t const dev_ID_h_ = 0x56;
uint8_t const dev_ID_l_ = 0x40;
uint16_t const reg_ID_h = 0x300A;
uint16_t const reg_ID_l = 0x300B;

#include <xvidc.h>


#define IIC_SENSOR_DEV_ID	XPAR_AXI_IIC_1_SENSOR_DEVICE_ID

#define VPROCSSCSC_BASE	XPAR_PROCESSING_SS_V_PROC_SS_CSC_BASEADDR
#define DEMOSAIC_BASE	XPAR_PROCESSING_SS_V_DEMOSAIC_0_S_AXI_CTRL_BASEADDR
#define VGAMMALUT_BASE	XPAR_PROCESSING_SS_V_GAMMA_LUT_0_S_AXI_CTRL_BASEADDR

#define PAGE_SIZE	16

#define EEPROM_TEST_START_ADDRESS	128

#define FRAME_BASE	0x10000000
#define CSIFrame	0x20000000
#define ScalerFrame	0x30000000

#define XVPROCSS_DEVICE_ID	XPAR_DSI_DISPLAY_PATH_V_PROC_SS_0_DEVICE_ID
#define VDMA_NUM_FSTORES	XPAR_AXIVDMA_0_NUM_FSTORES
#define XDSITXSS_DEVICE_ID	XPAR_DSITXSS_0_DEVICE_ID
#define XDSITXSS_INTR_ID	XPAR_FABRIC_MIPI_DSI_TX_SUBSYSTEM_0_INTERRUPT_INTR
#define DSI_BYTES_PER_PIXEL	(3)
#define DSI_H_RES		(1024)
#define DSI_V_RES		(768)
#define DSI_DISPLAY_HORI_VAL	(DSI_H_RES * DSI_BYTES_PER_PIXEL)
#define DSI_DISPLAY_VERT_VAL	(DSI_V_RES)
#define DSI_HBACK_PORCH			(0x208)
#define DSI_HFRONT_PORCH		(0x4E)
#define DSI_SYNC_WIDTH			(0x1BA)
#define DSI_VSYNC_WIDTH			(0x06)
#define DSI_VBACK_PORCH			(0x1D)
#define DSI_VFRONT_PORCH		(0x03)

#define ACTIVE_LANES_1	1
#define ACTIVE_LANES_2	2
#define ACTIVE_LANES_3	3
#define ACTIVE_LANES_4	4

XDsiTxSs DsiTxSs;

#define BIT(nr)   (1UL << (nr))
/* DSI D-PHY Layer Registers */
#define D0W_DPHYCONTTX		0x0004
#define CLW_DPHYCONTRX		0x0020
#define D0W_DPHYCONTRX		0x0024
#define D1W_DPHYCONTRX		0x0028
#define COM_DPHYCONTRX		0x0038
#define CLW_CNTRL		0x0040
#define D0W_CNTRL		0x0044
#define D1W_CNTRL		0x0048
#define DFTMODE_CNTRL		0x0054

/* DSI PPI Layer Registers */
#define PPI_STARTPPI		0x0104
#define PPI_BUSYPPI		0x0108
#define PPI_LINEINITCNT		0x0110
#define PPI_LPTXTIMECNT		0x0114
#define PPI_CLS_ATMR		0x0140
#define PPI_D0S_ATMR		0x0144
#define PPI_D1S_ATMR		0x0148
#define PPI_D0S_CLRSIPOCOUNT	0x0164
#define PPI_D1S_CLRSIPOCOUNT	0x0168
#define CLS_PRE			0x0180
#define D0S_PRE			0x0184
#define D1S_PRE			0x0188
#define CLS_PREP		0x01A0
#define D0S_PREP		0x01A4
#define D1S_PREP		0x01A8
#define CLS_ZERO		0x01C0
#define D0S_ZERO		0x01C4
#define D1S_ZERO		0x01C8
#define PPI_CLRFLG		0x01E0
#define PPI_CLRSIPO		0x01E4
#define HSTIMEOUT		0x01F0
#define HSTIMEOUTENABLE		0x01F4

/* DSI Protocol Layer Registers */
#define DSI_STARTDSI		0x0204
#define DSI_BUSYDSI		0x0208
#define DSI_LANEENABLE		0x0210
# define DSI_LANEENABLE_CLOCK		BIT(0)
# define DSI_LANEENABLE_D0		BIT(1)
# define DSI_LANEENABLE_D1		BIT(2)

#define DSI_LANESTATUS0		0x0214
#define DSI_LANESTATUS1		0x0218
#define DSI_INTSTATUS		0x0220
#define DSI_INTMASK		0x0224
#define DSI_INTCLR		0x0228
#define DSI_LPTXTO		0x0230
#define DSI_MODE		0x0260
#define DSI_PAYLOAD0		0x0268
#define DSI_PAYLOAD1		0x026C
#define DSI_SHORTPKTDAT		0x0270
#define DSI_SHORTPKTREQ		0x0274
#define DSI_BTASTA		0x0278
#define DSI_BTACLR		0x027C

/* DSI General Registers */
#define DSIERRCNT		0x0300
#define DSISIGMOD		0x0304

/* DSI Application Layer Registers */
#define APLCTRL			0x0400
#define APLSTAT			0x0404
#define APLERR			0x0408
#define PWRMOD			0x040C
#define RDPKTLN			0x0410
#define PXLFMT			0x0414
#define MEMWRCMD		0x0418

/* LCDC/DPI Host Registers */
#define LCDCTRL			0x0420
#define HSR			0x0424
#define HDISPR			0x0428
#define VSR			0x042C
#define VDISPR			0x0430
#define VFUEN			0x0434

/* DBI-B Host Registers */
#define DBIBCTRL		0x0440

/* SPI Master Registers */
#define SPICMR			0x0450
#define SPITCR			0x0454

/* System Controller Registers */
#define SYSSTAT			0x0460
#define SYSCTRL			0x0464
#define SYSPLL1			0x0468
#define SYSPLL2			0x046C
#define SYSPLL3			0x0470
#define SYSPMCTRL		0x047C

/* GPIO Registers */
#define GPIOC			0x0480
#define GPIOO			0x0484
#define GPIOI			0x0488

/* I2C Registers */
#define I2CCLKCTRL		0x0490

/* Chip/Rev Registers */
#define IDREG			0x0080

/* Debug Registers */
#define WCMDQUEUE		0x0500
#define RCMDQUEUE		0x0504

#define	VIDEO_BASEADDR		0x80000000+0x05000000
#define OV5640_I2C_SLAVE_ADDR 0x78 >> 1
void delay_ms(u32 ms_count) {
  u32 count;
  for (count = 0; count < ((ms_count * 40000) + 1); count++) {
    asm("nop");
  }
}

//int imx219_write(u16 addr, u8 data)
//{
//	u8 buf[3];
//
//	buf[0] = addr >> 8;
//	buf[1] = addr & 0xff;
//	buf[2] = data;
//
//	while (TransmitFifoFill(&iic) || XIicPs_BusIsBusy(&iic)) { //while (XIicPs_BusIsBusy(&iic)) {
//		usleep(1);
//		xil_printf("waiting for transmit...\r\n");
//	}
//
//	if (XIicPs_MasterSendPolled(&iic, buf, 3, OV5640_I2C_SLAVE_ADDR) != XST_SUCCESS) {
//		xil_printf("imx219 write failed, addr: %x\r\imx219_write(", addr);
//		return XST_FAILURE;
//	}
//	usleep(1000);
//
//	return XST_SUCCESS;
//}
//
//int imx219_read(u16 addr, u8 *data) {
//	u8 buf[2];
//
//	buf[0] = addr >> 8;
//	buf[1] = addr & 0xff;
//
//	if (XIicPs_MasterSendPolled(&iic, buf, 2, OV5640_I2C_SLAVE_ADDR) != XST_SUCCESS) {
//		xil_printf("imx219 write failed\r\n");
//		return XST_FAILURE;
//	}
//	if (XIicPs_MasterRecvPolled(&iic, data, 1, OV5640_I2C_SLAVE_ADDR) != XST_SUCCESS) {
//		xil_printf("imx219 receive failed\r\n");
//		return XST_FAILURE;
//	}
//	return XST_SUCCESS;
//}

u32 iic_read_cam(u32 daddr,  u32 raddr, u32 display) {
	u32 rdata;
	Xil_Out32((XPAR_IIC_1_BASEADDR + 0x100), 0x002); // reset tx fifo
	Xil_Out32((XPAR_IIC_1_BASEADDR + 0x100), 0x001); // enable iic
	Xil_Out32((XPAR_IIC_1_BASEADDR + 0x108), (0x100 | (daddr<<1))); // select
	Xil_Out32((XPAR_IIC_1_BASEADDR + 0x108), raddr >> 8); // address
	Xil_Out32((XPAR_IIC_1_BASEADDR + 0x108), raddr & 0xff); // address
	Xil_Out32((XPAR_IIC_1_BASEADDR + 0x108), (0x101 | (daddr<<1))); // select
	Xil_Out32((XPAR_IIC_1_BASEADDR + 0x108), 0x201); // data
	while ((Xil_In32(XPAR_IIC_1_BASEADDR + 0x104) & 0x40) == 0x40) {delay_ms(1);}
	delay_ms(10);
	rdata = Xil_In32(XPAR_IIC_1_BASEADDR + 0x10c) & 0xff;
	if (display == 1) {
	xil_printf("iic_read: addr(%02x) data(%02x)\n\r", raddr, rdata);
	}
	delay_ms(10);
	return(rdata);
}

void iic_write_cam(u32 daddr, u32 waddr, u32 wdata) {
	Xil_Out32((XPAR_IIC_1_BASEADDR + 0x100), 0x002); // reset tx fifo
	Xil_Out32((XPAR_IIC_1_BASEADDR + 0x100), 0x001); // enable iic
	Xil_Out32((XPAR_IIC_1_BASEADDR + 0x108), (0x100 | (daddr<<1))); // select
	Xil_Out32((XPAR_IIC_1_BASEADDR + 0x108), (waddr >> 8) & 0xff); // address
	Xil_Out32((XPAR_IIC_1_BASEADDR + 0x108), waddr & 0xff); // address
	Xil_Out32((XPAR_IIC_1_BASEADDR + 0x108), (0x200 | wdata)); // data
	while ((Xil_In32(XPAR_IIC_1_BASEADDR + 0x104) & 0x80) == 0x00)
	{delay_ms(1);}
	delay_ms(10);
	//delay_ms(1);
}

void EnableDSI(void)
{
	XDsiTxSs_Activate(&DsiTxSs, XDSITXSS_DSI, XDSITXSS_ENABLE);
}

void InitDSI(void)
{
	XDsi_VideoTiming Timing = { 0 };

	/* Disable DSI core only. So removed DPHY register interface in design*/
	XDsiTxSs_Activate(&DsiTxSs, XDSITXSS_DSI, XDSITXSS_DISABLE);

	XDsiTxSs_Reset(&DsiTxSs);

	if (!XDsiTxSs_IsControllerReady(&DsiTxSs)) {
		xil_printf("DSI Controller NOT Ready!!!!\r\n");
		return;
	}

	/* Set the DSI Timing registers */
	Timing.HActive = DSI_DISPLAY_HORI_VAL;
	Timing.VActive = DSI_DISPLAY_VERT_VAL;
	Timing.HBackPorch = DSI_HBACK_PORCH;
	Timing.HFrontPorch = DSI_HFRONT_PORCH;
	Timing.HSyncWidth = DSI_SYNC_WIDTH;

	Timing.VSyncWidth = DSI_VSYNC_WIDTH;
	Timing.VBackPorch = DSI_VBACK_PORCH;
	Timing.VFrontPorch = DSI_VFRONT_PORCH;

	XDsiTxSs_SetCustomVideoInterfaceTiming(&DsiTxSs,
						XDSI_VM_NON_BURST_SYNC_PULSES,
						&Timing);

	usleep(1000000);
}

u32 SetupDSI(void)
{
	XDsiTxSs_Config *DsiTxSsCfgPtr = NULL;
	u32 Status;
	u32 PixelFmt;

	DsiTxSsCfgPtr = XDsiTxSs_LookupConfig(XDSITXSS_DEVICE_ID);

//	DsiTxSsCfgPtr->DeviceId = 0;
//	DsiTxSsCfgPtr->BaseAddr = 0x1010000000;
//	DsiTxSsCfgPtr->HighAddr = 0x101001FFFF;
//	DsiTxSsCfgPtr->DsiLanes = 2;
//	DsiTxSsCfgPtr->DataType = 0x3E;
//	DsiTxSsCfgPtr->DsiByteFifo = 2048;
//	DsiTxSsCfgPtr->CrcGen = 1;
//	DsiTxSsCfgPtr->DsiPixel = 1;
//	DsiTxSsCfgPtr->DphyLinerate = 800;
//	DsiTxSsCfgPtr->DphyInfo.AddrOffset = 1;
//	DsiTxSsCfgPtr->DphyInfo.DeviceId = 0;
//	DsiTxSsCfgPtr->DphyInfo.IsPresent = 0x00010000;
//	DsiTxSsCfgPtr->DsiInfo.AddrOffset = 1;
//	DsiTxSsCfgPtr->DsiInfo.DeviceId = 0;
//	DsiTxSsCfgPtr->DsiInfo.IsPresent = 0x00000000;

	xil_printf("Address is %x\n\r", DsiTxSsCfgPtr->BaseAddr);

	if (!DsiTxSsCfgPtr) {
		xil_printf(TXT_RED "DSI Tx SS Device Id not found\r\n" TXT_RST);
		return XST_FAILURE;
	}

	Status = XDsiTxSs_CfgInitialize(&DsiTxSs, DsiTxSsCfgPtr,
			DsiTxSsCfgPtr->BaseAddr);
	if (Status != XST_SUCCESS) {
		xil_printf(TXT_RED "DSI Tx Ss Cfg Init failed status = %d \
				\r\n" TXT_RST, Status);
		return Status;
	}

	PixelFmt = XDsiTxSs_GetPixelFormat(&DsiTxSs);
	xil_printf("the PixelFmt is %x\n\r",PixelFmt);
	if (PixelFmt != 0x3E) {
		xil_printf(TXT_RED "DSI Pixel format is not correct ");
		switch (PixelFmt) {
			case 0x0E:
				xil_printf("Packed RGB565");
				break;
			case 0x1E:
				xil_printf("Packed RGB666");
				break;
			case 0x2E:
				xil_printf("Loosely packed RGB666");
				break;
			case 0x3E:
				xil_printf("Packed RGB888");
				break;
			case 0x0B:
				xil_printf("Compressed Pixel Stream");
				break;
			default:
				xil_printf("Invalid data type");
		}
		xil_printf("\r\n");
		xil_printf("Expected is 0x3E for RGB888\r\n" TXT_RST);
		return XST_FAILURE;
	}

	return Status;
}


int gamma_lut_init() {
	XV_gamma_lut gamma_lut;
	XV_gamma_lut_Config *gamma_lut_config;
//XPAR_AXI_VDMA_0_DEVICE_ID
	if ( (gamma_lut_config = XV_gamma_lut_LookupConfig(XPAR_V_GAMMA_LUT_0_DEVICE_ID)) == NULL) {
		xil_printf("XV_gamma_lut_LookupConfig() failed\r\n");
		return XST_FAILURE;
	}
	if (XV_gamma_lut_CfgInitialize(&gamma_lut, gamma_lut_config, gamma_lut_config->BaseAddress)) {
		xil_printf("XV_gamma_lut_CfgInitialize() failed\r\n");
		return XST_FAILURE;
	}

	XV_gamma_lut_Set_HwReg_width(&gamma_lut, 1920);
	XV_gamma_lut_Set_HwReg_height(&gamma_lut, 1080);
    XV_gamma_lut_Set_HwReg_video_format(&gamma_lut, 0); // RGB

	if (XV_gamma_lut_Write_HwReg_gamma_lut_0_Words(&gamma_lut, 0, (int *) xgamma10_04,
			sizeof(xgamma10_10)/sizeof(int)) != sizeof(xgamma10_10)/sizeof(int)) {
		xil_printf("Gamma correction LUT write failed\r\n");
		return XST_FAILURE;
	}
	if (XV_gamma_lut_Write_HwReg_gamma_lut_1_Words(&gamma_lut, 0, (int *) xgamma10_04,
			sizeof(xgamma10_10)/sizeof(int)) != sizeof(xgamma10_10)/sizeof(int)) {
		xil_printf("Gamma correction LUT write failed\r\n");
		return XST_FAILURE;
	}
	if (XV_gamma_lut_Write_HwReg_gamma_lut_2_Words(&gamma_lut, 0, (int *) xgamma10_04,
			sizeof(xgamma10_10)/sizeof(int)) != sizeof(xgamma10_10)/sizeof(int)) {
		xil_printf("Gamma correction LUT write failed\r\n");
		return XST_FAILURE;
	}


	printf("GAMMA LUT end\n\r");


	XV_gamma_lut_EnableAutoRestart(&gamma_lut);
	XV_gamma_lut_Start(&gamma_lut);

	xil_printf("Gamma correction LUT initialized\r\n");

	return XST_SUCCESS;
}

int main()
{
    init_platform();
    int	i;
	u32	test,Status;
//	XIicPs_Config *iic_config;
//	u8 bit_mask;
	u8 addr[2];
	u8 camera_model_id[2];
	unsigned char u8TxData[8], id1[6], id0[6];

	/* Initialize ICache */
//	Xil_ICacheInvalidate();
//	Xil_ICacheDisable();
//
//	/* Initialize DCache */
//	Xil_DCacheInvalidate();
//	Xil_DCacheDisable();
    print("Hello World\n\r");

//    if ( (iic_config = XIicPs_LookupConfig(XPAR_PSU_I2C_1_DEVICE_ID)) == NULL) {
//  		xil_printf("XIicPs_LookupConfig() failed\r\n");
//  		return XST_FAILURE;
//  	}
//      if (XIicPs_CfgInitialize(&iic, iic_config, iic_config->BaseAddress) != XST_SUCCESS) {
//  		xil_printf("XIicPs_CfgInitialize() failed\r\n");
//  		return XST_FAILURE;
//  	}
//
//  	if (XIicPs_SelfTest(&iic) != XST_SUCCESS) {
//  		xil_printf("XIicPs_SelfTest() failed\r\n");
//  		return XST_FAILURE;
//  	}
//
//  	if (XIicPs_SetSClk(&iic, 200000) != XST_SUCCESS) {
//  		xil_printf("XIicPs_SetSClk failed\r\n");
//  		return XST_FAILURE;
//  	}


//    camera_model_id[1] = iic_read_cam(OV5640_I2C_SLAVE_ADDR,0x300B,1);
//	usleep(10);
//	camera_model_id[0] = iic_read_cam(OV5640_I2C_SLAVE_ADDR,0x300A,1);



    print("rx subsyst start\n\r");
	Xil_Out32((XPAR_MIPI_CSI2_RX_SUBSYST_0_BASEADDR + 0x00), 0x2);
	Xil_Out32((XPAR_MIPI_CSI2_RX_SUBSYST_0_BASEADDR + 0x00), 0x1);
	Xil_Out32((XPAR_MIPI_CSI2_RX_SUBSYST_0_BASEADDR + 0x04), 0x9);
	print("rx subsyst end\n\r");
//
	print("DEMOSAIC start\n\r");
	Xil_Out32((XPAR_XV_DEMOSAIC_0_S_AXI_CTRL_BASEADDR + 0x10), 1024);
	Xil_Out32((XPAR_XV_DEMOSAIC_0_S_AXI_CTRL_BASEADDR + 0x18), 768);
	Xil_Out32((XPAR_XV_DEMOSAIC_0_S_AXI_CTRL_BASEADDR + 0x28), 0x3);
	Xil_Out32((XPAR_XV_DEMOSAIC_0_S_AXI_CTRL_BASEADDR + 0x00), 0x0);
	Xil_Out32((XPAR_XV_DEMOSAIC_0_S_AXI_CTRL_BASEADDR + 0x00), 0x81);
	print("DEMOSAIC end\n\r");


	print("GAMMA LUT start\n\r");
	u32 count;
	Xil_Out32((XPAR_V_GAMMA_LUT_0_S_AXI_CTRL_BASEADDR + 0x10), 1024 );
	Xil_Out32((XPAR_V_GAMMA_LUT_0_S_AXI_CTRL_BASEADDR + 0x18), 768 );
	Xil_Out32((XPAR_V_GAMMA_LUT_0_S_AXI_CTRL_BASEADDR + 0x20), 0x0   );

	for(count=0; count < 0x800; count += 2)
	{
		Xil_Out16((XPAR_V_GAMMA_LUT_0_S_AXI_CTRL_BASEADDR + 0x800 + count), xgamma10_07[count /2]);
	}

	for(count=0; count < 0x800; count += 2)
	{
		Xil_Out16((XPAR_V_GAMMA_LUT_0_S_AXI_CTRL_BASEADDR + 0x1000 + count), xgamma10_07[count /2]);
	}

	for(count=0; count < 0x800; count += 2)
	{
		Xil_Out16((XPAR_V_GAMMA_LUT_0_S_AXI_CTRL_BASEADDR + 0x1800 + count), xgamma10_07[count /2]);
	}

	Xil_Out32((XPAR_V_GAMMA_LUT_0_S_AXI_CTRL_BASEADDR + 0x00), 0x81   );
//	gamma_lut_init();
	print("GAMMA LUT end\n\r");



    // Poll PLL Lock bit
	u8TxData[0] = 0x30;
	u8TxData[1] = 0x0B;

	XIic_Send(XPAR_AXI_IIC_1_BASEADDR,OV5640_I2C_SLAVE_ADDR, u8TxData,2,XIIC_REPEATED_START);
	XIic_Recv(XPAR_AXI_IIC_1_BASEADDR,OV5640_I2C_SLAVE_ADDR, id1,1,XIIC_STOP);
	usleep(10);

	u8TxData[0] = 0x30;
	u8TxData[1] = 0x0A;

	XIic_Send(XPAR_AXI_IIC_1_BASEADDR,OV5640_I2C_SLAVE_ADDR, u8TxData,2,XIIC_REPEATED_START);
	XIic_Recv(XPAR_AXI_IIC_1_BASEADDR,OV5640_I2C_SLAVE_ADDR, id0,1,XIIC_STOP);


	xil_printf("ID = %x,%x\r\n",id0[0],id1[0]);
	if (id0[0] != dev_ID_h_ || id1[0] != dev_ID_l_) {
		xil_printf("could not read camera id\r\n");
		return XST_FAILURE;
	}
	else {
		xil_printf("I2C communication established with IMX219\r\n");
	}


//	//[1]=0 System input clock from pad; Default read = 0x11
//	iic_write_cam(OV5640_I2C_SLAVE_ADDR,0x3103, 0x11);
//	//[7]=1 Software reset; [6]=0 Software power down; Default=0x02
//	iic_write_cam(OV5640_I2C_SLAVE_ADDR,0x3008, 0x82);

	u8TxData[0] = 0x31;
	u8TxData[1] = 0x03;
	u8TxData[2] = 0x11;
	XIic_Send(XPAR_AXI_IIC_1_BASEADDR,OV5640_I2C_SLAVE_ADDR, u8TxData,3,XIIC_STOP);

	u8TxData[0] = 0x30;
	u8TxData[1] = 0x08;
	u8TxData[2] = 0x82;
	XIic_Send(XPAR_AXI_IIC_1_BASEADDR,OV5640_I2C_SLAVE_ADDR, u8TxData,3,XIIC_STOP);

	xil_printf("reset\r\n");

	usleep(1000000);


	for (i=0;i<sizeof(cfg_init_)/sizeof(cfg_init_[0]); ++i)
	{
		u8TxData[0] = cfg_init_[i].addr >> 8;
		u8TxData[1] = cfg_init_[i].addr & 0xff;
		u8TxData[2] = cfg_init_[i].data;
		XIic_Send(XPAR_AXI_IIC_1_BASEADDR,OV5640_I2C_SLAVE_ADDR, u8TxData,3,XIIC_STOP);
//		iic_write_cam(OV5640_I2C_SLAVE_ADDR,cfg_init_[i].addr,cfg_init_[i].data);
	}

	xil_printf("init\r\n");

	usleep(1000000);

	u8TxData[0] = 0x30;
	u8TxData[1] = 0x08;
	u8TxData[2] = 0x42;
	XIic_Send(XPAR_AXI_IIC_1_BASEADDR,OV5640_I2C_SLAVE_ADDR, u8TxData,3,XIIC_STOP);
//	iic_write_cam(OV5640_I2C_SLAVE_ADDR,0x3008, 0x42);

	for (i=0;i<sizeof(cfg_XGA_30fps_)/sizeof(cfg_XGA_30fps_[0]); ++i)
	{
		u8TxData[0] = cfg_XGA_30fps_[i].addr >> 8;
		u8TxData[1] = cfg_XGA_30fps_[i].addr & 0xff;
		u8TxData[2] = cfg_XGA_30fps_[i].data;
		XIic_Send(XPAR_AXI_IIC_1_BASEADDR,OV5640_I2C_SLAVE_ADDR, u8TxData,3,XIIC_STOP);
//		iic_write_cam(OV5640_I2C_SLAVE_ADDR,cfg_XGA_30fps_[i].addr,cfg_XGA_30fps_[i].data);
	}

	xil_printf("cfg_XGA_30fps\r\n");

//	u8TxData[0] = 0x30;
//	u8TxData[1] = 0x08;
//	u8TxData[2] = 0x02;
//	XIic_Send(XPAR_AXI_IIC_1_BASEADDR,OV5640_I2C_SLAVE_ADDR, u8TxData,3,XIIC_STOP);
////	iic_write_cam(OV5640_I2C_SLAVE_ADDR,0x3008, 0x02);
//
//	usleep(1000000);
//
//	u8TxData[0] = 0x30;
//	u8TxData[1] = 0x08;
//	u8TxData[2] = 0x42;
//	XIic_Send(XPAR_AXI_IIC_1_BASEADDR,OV5640_I2C_SLAVE_ADDR, u8TxData,3,XIIC_STOP);
////	iic_write_cam(OV5640_I2C_SLAVE_ADDR,0x3008, 0x42);

	xil_printf("reset\r\n");

	for (i=0;i<sizeof(cfg_advanced_awb_)/sizeof(cfg_advanced_awb_[0]); ++i)
	{
		u8TxData[0] = cfg_advanced_awb_[i].addr >> 8;
		u8TxData[1] = cfg_advanced_awb_[i].addr & 0xff;
		u8TxData[2] = cfg_advanced_awb_[i].data;
		XIic_Send(XPAR_AXI_IIC_1_BASEADDR,OV5640_I2C_SLAVE_ADDR, u8TxData,3,XIIC_STOP);
//		iic_write_cam(OV5640_I2C_SLAVE_ADDR,cfg_advanced_awb_[i].addr,cfg_advanced_awb_[i].data);
	}

	xil_printf("cfg_advanced_awb\r\n");

	u8TxData[0] = 0x30;
	u8TxData[1] = 0x08;
	u8TxData[2] = 0x02;
	XIic_Send(XPAR_AXI_IIC_1_BASEADDR,OV5640_I2C_SLAVE_ADDR, u8TxData,3,XIIC_STOP);
//	iic_write_cam(OV5640_I2C_SLAVE_ADDR,0x3008, 0x02);

//    XGpio_WriteReg(XPAR_AXI_GPIO_RESET_BASEADDR, XGPIO_TRI_OFFSET, 0x00000000);
//    XGpio_WriteReg(XPAR_AXI_GPIO_RESET_BASEADDR, XGPIO_DATA_OFFSET,0x1);



//	print("VPROCSSCSC start\n\r");
//	Xil_Out32((0x85000000 + 0x0010), 0x0   );
//	Xil_Out32((0x85000000 + 0x0018), 0x0   );
//	Xil_Out32((0x85000000 + 0x0050), 0x1000);
//	Xil_Out32((0x85000000 + 0x0058), 0x0   );
//	Xil_Out32((0x85000000 + 0x0060), 0x0   );
//	Xil_Out32((0x85000000 + 0x0068), 0x0   );
//	Xil_Out32((0x85000000 + 0x0070), 0x1000);
//	Xil_Out32((0x85000000 + 0x0078), 0x0   );
//	Xil_Out32((0x85000000 + 0x0080), 0x0   );
//	Xil_Out32((0x85000000 + 0x0088), 0x0   );
//	Xil_Out32((0x85000000 + 0x0090), 0x1000);
//	Xil_Out32((0x85000000 + 0x0098), 0x0   );
//	Xil_Out32((0x85000000 + 0x00a0), 0x0   );
//	Xil_Out32((0x85000000 + 0x00a8), 0x0   );
//	Xil_Out32((0x85000000 + 0x00b0), 0x0   );
//	Xil_Out32((0x85000000 + 0x00b8), 0xff  );
//	Xil_Out32((0x85000000 + 0x0020), 1920 );
//	Xil_Out32((0x85000000 + 0x0028), 1080 );
//	Xil_Out32((0x85000000 + 0x0000), 0x81  );
//	print("VPROCSSCSC end\n\r");

//
////	while(1)
////	{
//	test = Xil_In32((XPAR_XV_DEMOSAIC_0_S_AXI_CTRL_BASEADDR + 0x00));
//	        printf("the DEMOSAIC status is = %x!!\n\r", test);
////	}


//	while(1)
//	{
//		iic_read_cam(0x10, 0x10, 1);
//		iic_read_cam(0x10, 0x40, 1);
//		iic_read_cam(0x10, 0x44, 1);
//		iic_read_cam(0x10, 0x60, 1);
//		iic_read_cam(0x10, 0x68, 1);
//	}


    Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x030), 0x0000008b); // enable circular mode
    	Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x0ac), VIDEO_BASEADDR); // start address
    	//Xil_Out32(XPAR_AXI_VDMA_0_BASEADDR + 0x30, 0x4);
    	Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x0b0), VIDEO_BASEADDR+0x10000000); // start address
    	//Xil_Out32(XPAR_AXI_VDMA_0_BASEADDR + 0x30, 0x4);
    	Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x0b4), VIDEO_BASEADDR+0x20000000); // start address
    	//Xil_Out32(XPAR_AXI_VDMA_0_BASEADDR + 0x30, 0x4);
//    	Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x0b8), VIDEO_BASEADDR+0x0000000); // start address
    	//Xil_Out32(XPAR_AXI_VDMA_0_BASEADDR + 0x30, 0x4);
    	Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x0a8), (1024 * 4)); // h offset (1024 * 4) bytes
    	Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x0a4), (1024 * 4)); // h size (720 * 4)  bytes
    	Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x0a0), 768); // v size (480)

        xil_printf	("VDMA S2MM Starting OK\n\r");
//        test = Xil_In32((XPAR_AXI_VDMA_0_BASEADDR + 0x034));
        printf("the S2MM0 status is = %x!!\n\r", test);

        test	=0x0;
//    while((test	&	0xfffff)!=0x11000)
//    {
//        test = Xil_In32((XPAR_AXI_VDMA_0_BASEADDR + 0x034));
//        printf("the S2MM0 status is = %x!!\n\r", test);
//        delay_ms(10);
//        ////// HDMI Configuation
//    }
//            hdmi_config();
//    sleep(1);
//    Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x030), 0x00000004); // enable circular mode
//    //****************************multi-scaler****************************//
//    xil_printf	("Scaler Start\n\r");
//    u32 LineRate;
//    u32 PixeRate;
//    Xil_Out32((0xFF0A0000) + (0x00000018), (u32)(0xFFFF0000));
//    Xil_Out32((0xFF0A0000) + (0x000002C4), (u32)(0xFFFFFFFF));
//    Xil_Out32((0xFF0A0000) + (0x000002C8), (u32)(0xFFFFFFFF));
//    Xil_Out32((0xFF0A0000) + (0x0000004C), (u32)(0x00000001));
//    Xil_Out32((0xFF0A0000) + (0x0000004C), (u32)(0x00000000));
//    Xil_Out32((0xFF0A0000) + (0x0000004C), (u32)(0x00000001));
//
//    Xil_Out32(0x0080060000 + 0x00010,0x01);
//    Xil_Out32(0x0080060000 + 0x00100,1920);
//    Xil_Out32(0x0080060000 + 0x00108,1024);
//    Xil_Out32(0x0080060000 + 0x00118,1080);
//    Xil_Out32(0x0080060000 + 0x00120,768);
//    LineRate = (u32)((float)(1080*65536+ 768/2)/(float)768);
//    PixeRate = (u32)((float)(1920*65536+ 1024/2)/(float)1024);
//    Xil_Out32(0x0080060000 + 0x00128,LineRate);
//    Xil_Out32(0x0080060000 + 0x00130,PixeRate);
//    Xil_Out32(0x0080060000 + 0x00138,10);
//    Xil_Out32(0x0080060000 + 0x00150,10);
//    Xil_Out32(0x0080060000 + 0x00158,1920*4);
//    Xil_Out32(0x0080060000 + 0x00160,1024*4);
//    Xil_Out32(0x0080060000 + 0x00170,VIDEO_BASEADDR);
//    Xil_Out32(0x0080060000 + 0x00190,VIDEO_BASEADDR + 0x30000000);
//    Xil_Out32(0x0080060000 + 0x00200, VIDEO_BASEADDR+0x10000000);
//    Xil_Out32(0x0080060000 + 0x00300, VIDEO_BASEADDR+0x20000000);
//    Xil_Out32((0x0080060000 + 0x0004), 0x01  );
//    Xil_Out32((0x0080060000 + 0x0008), 0x01  );
//    Xil_Out32((0x0080060000 + 0x0000), 0x01  );
//    xil_printf	("Scaler End\n\r");
    //*********************************end********************************//

        //// MM2S

    sleep(1);

            Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x000), 0x0000008b); // enable circular mode
                Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x05c), VIDEO_BASEADDR+0x0000000); // start address
                Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x060), VIDEO_BASEADDR+0x10000000); // start address
                Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x064), VIDEO_BASEADDR+0x20000000); // start address
//                Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x068), VIDEO_BASEADDR+0x000000); // start address
                Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x058), (1024 * 4)); // h offset (1024 * 4) bytes
                Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x054), (1024 * 4)); // h size (720 * 4) bytes
                Xil_Out32((XPAR_AXI_VDMA_0_BASEADDR + 0x050), 768); // v size (480)


            test	=0x0;


//            while(test!=0x11000)
            {
            test = Xil_In32((XPAR_AXI_VDMA_0_BASEADDR + 0x004));

            printf("the MM2S status is = %x!!\n\r", test);
            }
            printf("OK\n\r");

//    		Xil_Out32((0x81000000 + 0x000), 0x07ffff07);
//    		printf("VTC OK\n\r");



	Xil_Out32((XPAR_MIPI_DSI_TX_SUBSYSTEM_0_BASEADDR + 0x000),0x2);
		delay_ms(200);
		test = Xil_In32((XPAR_MIPI_DSI_TX_SUBSYSTEM_0_BASEADDR + 0x000));
		xil_printf("0x000 status is = %x!!\n\r", test);//*/
		Status = SetupDSI();
		test = Xil_In32((XPAR_MIPI_DSI_TX_SUBSYSTEM_0_BASEADDR + 0x000));
		xil_printf("0x000 status is = %x!!\n\r", test);//*/
		if (Status != XST_SUCCESS) {
			xil_printf(TXT_RED "SetupDSI failed status = %x.\r\n" TXT_RST,
					 Status);
			return XST_FAILURE;
		}

	InitDSI();
	test = Xil_In32((XPAR_MIPI_DSI_TX_SUBSYSTEM_0_BASEADDR + 0x000));
	xil_printf("0x000 status is = %x!!\n\r", test);//*/
	xil_printf("\r\nInitDSI Done \n\r");

	xil_printf("the IIC write start\n\r");
	EnableDSI();
	test = Xil_In32((XPAR_MIPI_DSI_TX_SUBSYSTEM_0_BASEADDR + 0x000));
	xil_printf("0x000 status is = %x!!\n\r", test);//*/
	xil_printf("ENable DSI\n\r");

	xil_printf("adv7533_ReadID\n\r");
	adv7533_ReadID(0X3D);
//	adv7533_ReadID(0X39);
	delay_ms(1);
	xil_printf("ADV7533_Init\n\r");
    ADV7533_Init();
    delay_ms(1);



	xil_printf("adv7533_init_setup\n\r");
	adv7533_init_setup();

	xil_printf("adv7533_video_on\n\r");
	adv7533_video_on();

	//READ PC EDID
	HDMI_IO_Read(ADV7533_MAIN_I2C_ADDR, 0x43);
	HDMI_IO_Read(0X3F, 0x00);
	HDMI_IO_Read(0X3F, 0x01);
	HDMI_IO_Read(0X3F, 0x02);
	HDMI_IO_Read(0X3F, 0x03);
	HDMI_IO_Read(0X3F, 0x04);
	HDMI_IO_Read(0X3F, 0x05);
	HDMI_IO_Read(0X3F, 0x06);
	HDMI_IO_Read(0X3F, 0x07);


	xil_printf("adv7533_cec_enable\n\r");
	adv7533_cec_enable();

    xil_printf("ADV7533_PatternEnable\n\r");
    ADV7533_PatternEnable();
//    ADV7533_PatternDisable();
    delay_ms(1);

        HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x25);

    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x38);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x39);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x3A);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x3B);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x3C);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x3D);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x3E);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x3F);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x40);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x41);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x42);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x43);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x44);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x45);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x46);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x47);
    HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x48);

    cleanup_platform();
    return 0;
}
