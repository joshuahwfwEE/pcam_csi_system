/**
  ******************************************************************************
  * @file    adv7533.c
  * @author  MCD Application Team
  * @brief   This file provides the ADV7533 DSI to HDMI bridge driver 
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; COPYRIGHT(c) 2016 STMicroelectronics</center></h2>
  *
  * Redistribution and use in source and binary forms, with or without modification,
  * are permitted provided that the following conditions are met:
  *   1. Redistributions of source code must retain the above copyright notice,
  *      this list of conditions and the following disclaimer.
  *   2. Redistributions in binary form must reproduce the above copyright notice,
  *      this list of conditions and the following disclaimer in the documentation
  *      and/or other materials provided with the distribution.
  *   3. Neither the name of STMicroelectronics nor the names of its contributors
  *      may be used to endorse or promote products derived from this software
  *      without specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  ******************************************************************************
  */

/* Includes ------------------------------------------------------------------*/
#include "adv7533.h"
#include "xparameters.h"
#include "xil_io.h"
/** @addtogroup BSP
  * @{
  */
  
/** @addtogroup Components
  * @{
  */ 

/** @defgroup ADV7533 ADV7533
  * @brief     This file provides a set of functions needed to drive the 
  *            adv7533 DSI-HDMI bridge.
  * @{
  */
    
/* Private types -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private constants ---------------------------------------------------------*/
/** @defgroup ADV7533_Private_Constants ADV7533 Private Constants
  * @{
  */

/**
  * @}
  */

/* Private macros ------------------------------------------------------------*/
/* Private functions ---------------------------------------------------------*/
/** @defgroup ADV7533_Exported_Variables
  * @{
  */
/*
AUDIO_DrvTypeDef adv7533_drv = 
{
  adv7533_AudioInit,
  adv7533_DeInit,
  adv7533_ReadID,
  adv7533_Play,
  adv7533_Pause,
  adv7533_Resume,
  adv7533_Stop,  
  adv7533_SetFrequency,
  adv7533_SetVolume,
  adv7533_SetMute,  
  adv7533_SetOutputMode,
  adv7533_Reset
};
*/
/**
  * @}
  */
   
/* Exported functions --------------------------------------------------------*/
/** @defgroup ADV7533_Exported_Functions ADV7533 Exported Functions
  * @{
  */

/**
  * @brief  Initializes the ADV7533 bridge.
  * @param  None
  * @retval Status
  */
#define  display 1


unsigned char HDMI_IO_Read(unsigned char daddr,  unsigned char raddr){
//u32 iic_read(u32 daddr,  u32 raddr ,u32 display) {
	  u32 rdata;
	  Xil_Out32((XPAR_IIC_0_BASEADDR + 0x100), 0x002); // reset tx fifo
	  Xil_Out32((XPAR_IIC_0_BASEADDR + 0x100), 0x001); // enable iic
	  Xil_Out32((XPAR_IIC_0_BASEADDR + 0x108), (0x100 | (daddr<<1))); // select
	  Xil_Out32((XPAR_IIC_0_BASEADDR + 0x108), raddr); // address
	  Xil_Out32((XPAR_IIC_0_BASEADDR + 0x108), (0x101 | (daddr<<1))); // select
	  Xil_Out32((XPAR_IIC_0_BASEADDR + 0x108), 0x201); // data
	  while ((Xil_In32(XPAR_IIC_0_BASEADDR + 0x104) & 0x40) == 0x40) {delay_ms(1);}
	  delay_ms(10);
	  rdata = Xil_In32(XPAR_IIC_0_BASEADDR + 0x10c) & 0xff;
	  if (display == 1) {
	    xil_printf("iic_read: addr(%02x) data(%02x)\n\r", raddr, rdata);
	  }
	  delay_ms(10);
	  return(rdata);
}

 void HDMI_IO_Write(unsigned char daddr, unsigned char waddr,unsigned char wdata) {
  //void iic_write(u32 daddr, u32 waddr,u32 wdata) {
  	  Xil_Out32((XPAR_IIC_0_BASEADDR + 0x100), 0x002); // reset tx fifo
  	  Xil_Out32((XPAR_IIC_0_BASEADDR + 0x100), 0x001); // enable iic
  	  Xil_Out32((XPAR_IIC_0_BASEADDR + 0x108), (0x100 | (daddr<<1))); // select
  	  Xil_Out32((XPAR_IIC_0_BASEADDR + 0x108), waddr); // address
  	  Xil_Out32((XPAR_IIC_0_BASEADDR + 0x108), (0x200 | wdata)); // data
  	  while ((Xil_In32(XPAR_IIC_0_BASEADDR + 0x104) & 0x80) == 0x00)
  	  {delay_ms(1);}
  	  //delay_ms(1);
  }


unsigned char ADV7533_Init(void)
{
  //HDMI_IO_Init();

  /* Configure the IC2 address for CEC_DSI interface */
  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xE1, 0x78);
  HDMI_IO_Read(ADV7533_MAIN_I2C_ADDR, 0xE1);
  return 0;
}

/**
  * @brief  Power on the ADV7533 bridge.
  * @param  None
  * @retval None
  */
void ADV7533_PowerOn(void)
{
  unsigned char tmp;
  
  /* Power on */
  tmp = HDMI_IO_Read(ADV7533_MAIN_I2C_ADDR, 0x41);
  tmp &= ~0x40;
  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x41, tmp);
}

/**
  * @brief  Power off the ADV7533 bridge.
  * @param  None
  * @retval None
  */
void ADV7533_PowerDown(void)
{
   unsigned char tmp;
   
   /* Power down */
   tmp = HDMI_IO_Read(ADV7533_MAIN_I2C_ADDR, 0x41);
   tmp |= 0x40;
   HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x41, tmp);
}

/**
  * @brief  Configure the DSI-HDMI ADV7533 bridge for video.
  * @param config : pointer to adv7533ConfigTypeDef that contains the
  *                 video configuration parameters
  * @retval None
  */
void ADV7533_Configure()//adv7533ConfigTypeDef * config)
{
  unsigned char tmp;
  
  /* Sequence from Section 3 - Quick Start Guide */
  
  /* ADV7533 Power Settings */
  /* Power down */
  tmp = HDMI_IO_Read(ADV7533_MAIN_I2C_ADDR, 0x41);
  tmp &= ~0x40;
  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x41, tmp);
  /* HPD Override */
  tmp = HDMI_IO_Read(ADV7533_MAIN_I2C_ADDR, 0xD6);
  tmp |= 0x40;
  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xD6, tmp);
  /* Gate DSI LP Oscillator and DSI Bias Clock Powerdown */
  tmp = HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x03);
  tmp &= ~0x02;
  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x03, tmp);
  
  /* Fixed registers that must be set on power-up */
  tmp = HDMI_IO_Read(ADV7533_MAIN_I2C_ADDR, 0x16);
  tmp &= ~0x3E;
  tmp |= 0x20; 
  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x16, tmp);
  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x9A, 0xE0);
  tmp = HDMI_IO_Read(ADV7533_MAIN_I2C_ADDR, 0xBA);
  tmp &= ~0xF8;
  tmp |= 0x70; 
  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xBA, tmp);
  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xDE, 0x82);
  
  tmp = HDMI_IO_Read(ADV7533_MAIN_I2C_ADDR, 0xE4); 
  tmp |= 0x40;
  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xE4, tmp);
  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xE5, 0x80);
  
  tmp = HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x15);
  tmp &= ~0x30;
  tmp |= 0x10;
  tmp = HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x17);
  tmp &= ~0xF0;
  tmp |= 0xD0;
  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x17, tmp);
  tmp = HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x24);
  tmp &= ~0x10;
  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x24, tmp);
  tmp = HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x57);
  tmp |= 0x01;
  tmp |= 0x10;
  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x57, tmp);
  
  /* Configure the number of DSI lanes */
  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x1C, (4 << 4));
  
  /* Setup video output mode */
  /* Select HDMI mode */
  tmp = HDMI_IO_Read(ADV7533_MAIN_I2C_ADDR, 0xAF);
  tmp |= 0x02;
  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xAF, tmp); 
  /* HDMI Output Enable */
  tmp = HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x03);
  tmp |= 0x80;
  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x03, tmp);

  /* GC packet enable */
  tmp = HDMI_IO_Read(ADV7533_MAIN_I2C_ADDR, 0x40);
  tmp |= 0x80;
  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x40, tmp);
  /* Input color depth 24-bit per pixel */
  tmp = HDMI_IO_Read(ADV7533_MAIN_I2C_ADDR, 0x4C);
  tmp &= ~0x0F;
  tmp |= 0x03;
  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x4C, tmp);
  /* Down dither output color depth */
  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x49, 0xfc);
  
  /* Internal timing disabled */
  tmp = HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x27);
  tmp &= ~0x80;
  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x27, tmp);
}

/**
  * @brief  Enable video pattern generation.
  * @param  None
  * @retval None
  */
void ADV7533_PatternEnable(void)
{
  /* Timing generator enable */
  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x55, 0x0); /* Test Pattern Disable */
//  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x55, 0x80); /* Test Pattern Enable */
  
  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x03, 0x89);
  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xAF, 0x16);
}

/**
  * @brief  Disable video pattern generation.
  * @param  none
  * @retval none
  */
void ADV7533_PatternDisable(void)
{
  /* Timing generator enable */
  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x55, 0x00);
}



void adv7533_init_setup(void){
	/* power down */
		HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x41, 0x50);
	/* HPD override */
		HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xD6, 0x48);
	/* color space */
		HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x16, 0x20);
	/* Fixed */
		HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x9A, 0xE0);
	/* HDCP */
		HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xBA, 0x70);
	/* Fixed */
		HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xDE, 0x82);
	/* V1P2 */
		HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xE4, 0x40);
	/* Fixed */
		HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xE5, 0x80);
	/* Fixed */
		HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x15, 0xD0);
	/* Fixed */
		HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x17, 0xD0);
	/* Fixed */
		HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x24, 0x20);
	/* Fixed */
		HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x57, 0x11);

		HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x25, 0x08);
};

void adv7533_video_on(void){
	  unsigned char tmp;
	  /* Configure the number of DSI lanes */
	  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x1C, (2 << 4));

	  adv7533_video_setup();
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x28);
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x29);
		/* hsync_width */
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x2A);
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x2B);
		/* hfp */
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x2C);
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x2D);
		/* hbp */
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x2E);
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x2F);
		/* v_total */
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x30);
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x31);
		/* vsync_width */
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x32);
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x33);
		/* vfp */
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x34);
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x35);
		/* vbp */
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x36);
	  HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x37);

	  /* Select HDMI mode */
	  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xAF, 0x06);

	  //16:9
	  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x17, 0x02);
	  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x56, 0x28);

		 /* Timing Generator Enable */
//	  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x27, 0xCB); /* Test Pattern */
//	  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x27, 0x8B);
//	  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x27, 0xCB);
	  tmp = HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x27);
	  tmp &= ~0x80;
	  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x27, tmp);

		/* power up */
	  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x41, 0x10);
		/* hdmi enable */
	  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x03, 0x89);
		/* color depth */
	  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x4C, 0x04);
		/* down dither */
	  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x49, 0x02);
		/* Audio and CEC clock gate */
	  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x05, 0xC8);
		/* GC packet enable */
	  HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0x40, 0x80);

};

void adv7533_video_setup(void){

	u32 h_total,hpw,hfp,hbp,v_total,vpw,vfp,vbp;

	h_total = 0x540;
	hpw = 0x88;
	hfp = 0x18;
	hbp = 0xA0;
	v_total = 0x326;
	vpw = 0x6;
	vfp = 0x3;
	vbp = 0x1D;

	/* h_width */
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x28, ((h_total & 0xFF0) >> 4));
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x29, ((h_total & 0xF) << 4));
	/* hsync_width */
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x2A, ((hpw & 0xFF0) >> 4));
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x2B, ((hpw & 0xF) << 4));
	/* hfp */
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x2C, ((hfp & 0xFF0) >> 4));
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x2D, ((hfp & 0xF) << 4));
	/* hbp */
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x2E, ((hbp & 0xFF0) >> 4));
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x2F, ((hbp & 0xF) << 4));
	/* v_total */
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x30, ((v_total & 0xFF0) >> 4));
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x31, ((v_total & 0xF) << 4));
	/* vsync_width */
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x32, ((vpw & 0xFF0) >> 4));
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x33, ((vpw & 0xF) << 4));
	/* vfp */
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x34, ((vfp & 0xFF0) >> 4));
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x35, ((vfp & 0xF) << 4));
	/* vbp */
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x36, ((vbp & 0xFF0) >> 4));
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x37, ((vbp & 0xF) << 4));

};


void adv7533_cec_enable(void){

	/* Fixed, clock gate disable */
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x05, 0xC8);
	/* read divider(7:2) from calc */
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xBE, 0x01);


	/* TG programming for 19.2MHz, divider 25 */
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xBE, 0x61);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xC1, 0x0D);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xC2, 0x80);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xC3, 0x0C);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xC4, 0x9A);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xC5, 0x0E);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xC6, 0x66);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xC7, 0x0B);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xC8, 0x1A);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xC9, 0x0A);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xCA, 0x33);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xCB, 0x0C);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xCC, 0x00);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xCD, 0x07);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xCE, 0x33);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xCF, 0x05);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xD0, 0xDA);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xD1, 0x08);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xD2, 0x8D);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xD3, 0x01);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xD4, 0xCD);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xD5, 0x04);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xD6, 0x80);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xD7, 0x05);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xD8, 0x66);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xD9, 0x03);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xDA, 0x26);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xDB, 0x0A);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xDC, 0xCD);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xDE, 0x00);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xDF, 0xC0);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xE1, 0x00);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xE2, 0xE6);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xE3, 0x02);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xE4, 0xB3);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xE5, 0x03);
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xE6, 0x9A);

	/* cec power up */
	HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xE2, 0x00);
	/* hpd override */
	HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xD6, 0x48);
	/* edid reread */
	HDMI_IO_Write(ADV7533_MAIN_I2C_ADDR, 0xC9, 0x13);
	/* read all CEC Rx Buffers */
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xBA, 0x08);
	/* logical address0 0x04 */
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xBC, 0x04);
	/* select logical address0 */
	HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0xBB, 0x10);

};


/**
  * @brief Initializes the ADV7533 audio  interface.
  * @param DeviceAddr: Device address on communication Bus.   
  * @param OutputDevice: Not used (for compatiblity only).   
  * @param Volume: Not used (for compatiblity only).   
  * @param AudioFreq: Audio Frequency 
  * @retval 0 if correct communication, else wrong communication
  */
unsigned int adv7533_AudioInit(short int DeviceAddr, short int OutputDevice, unsigned char Volume,unsigned int AudioFreq)
{
  unsigned int val = 4096;
  unsigned char  tmp = 0;

  /* Audio data enable*/
  tmp = HDMI_IO_Read(ADV7533_CEC_DSI_I2C_ADDR, 0x05);
  tmp &= ~0x20;
  HDMI_IO_Write(ADV7533_CEC_DSI_I2C_ADDR, 0x05, tmp);

  /* HDMI statup */
  tmp= (unsigned char)((val & 0xF0000)>>16);
  HDMI_IO_Write(DeviceAddr, 0x01, tmp);

  tmp= (unsigned char)((val & 0xFF00)>>8);
  HDMI_IO_Write(DeviceAddr, 0x02, tmp);

  tmp= (unsigned char)((val & 0xFF));
  HDMI_IO_Write(DeviceAddr, 0x03, tmp);

  /* Enable spdif */
  tmp = HDMI_IO_Read(DeviceAddr, 0x0B);
  tmp |= 0x80;
  HDMI_IO_Write(DeviceAddr, 0x0B, tmp);

  /* Enable I2S */
  tmp = HDMI_IO_Read(DeviceAddr, 0x0C);
  tmp |=0x04;
  HDMI_IO_Write(DeviceAddr, 0x0C, tmp);

  /* Set audio sampling frequency */
  adv7533_SetFrequency(DeviceAddr, AudioFreq);

  /* Select SPDIF is 0x10 , I2S=0x00  */
  tmp = HDMI_IO_Read(ADV7533_MAIN_I2C_ADDR, 0x0A);
  tmp &=~ 0x10;
  HDMI_IO_Write(DeviceAddr, 0x0A, tmp);

  /* Set v1P2 enable */
  tmp = HDMI_IO_Read(DeviceAddr, 0xE4);
  tmp |= 0x80;
  HDMI_IO_Write(DeviceAddr, 0xE4, tmp);
 
  return 0;
}

/**
  * @brief  Deinitializes the adv7533
  * @param  None
  * @retval  None
  */

void adv7533_DeInit(void)
{
  /* Deinitialize Audio adv7533 interface */
  //AUDIO_IO_DeInit();
}

/**
  * @brief  Get the adv7533 ID.
  * @param DeviceAddr: Device address on communication Bus.
  * @retval The adv7533 ID 
  */
unsigned int adv7533_ReadID(short int DeviceAddr)
{
  unsigned int  tmp = 0;
  
  tmp = HDMI_IO_Read(DeviceAddr, ADV7533_CHIPID_ADDR0);
  tmp = (tmp<<8);
  tmp |= HDMI_IO_Read(DeviceAddr, ADV7533_CHIPID_ADDR1);
  
  return(tmp);
}

/**
  * @brief Pauses playing on the audio hdmi
  * @param DeviceAddr: Device address on communication Bus. 
  * @retval 0 if correct communication, else wrong communication
  */
unsigned int adv7533_Pause(short int DeviceAddr)
{ 
  return(adv7533_SetMute(DeviceAddr,AUDIO_MUTE_ON));
}       
            
/**
  * @brief Resumes playing on the audio hdmi.
  * @param DeviceAddr: Device address on communication Bus. 
  * @retval 0 if correct communication, else wrong communication
  */   
unsigned int adv7533_Resume(short int DeviceAddr)
{ 
  return(adv7533_SetMute(DeviceAddr,AUDIO_MUTE_OFF));
} 

/**
  * @brief Start the audio hdmi play feature.
  * @note  For this codec no Play options are required.
  * @param DeviceAddr: Device address on communication Bus.   
  * @retval 0 if correct communication, else wrong communication
  */
unsigned int adv7533_Play(short int DeviceAddr ,short int* pBuffer  ,short int Size)
{
  return(adv7533_SetMute(DeviceAddr,AUDIO_MUTE_OFF));
}
            
/**
  * @brief Stop playing on the audio hdmi
  * @param DeviceAddr: Device address on communication Bus. 
  * @retval 0 if correct communication, else wrong communication
  */
unsigned int adv7533_Stop(short int DeviceAddr,unsigned int cmd)
{ 
  return(adv7533_SetMute(DeviceAddr,AUDIO_MUTE_ON));
}               
            
/**
  * @brief Enables or disables the mute feature on the audio hdmi.
  * @param DeviceAddr: Device address on communication Bus.   
  * @param Cmd: AUDIO_MUTE_ON to enable the mute or AUDIO_MUTE_OFF to disable the
  *             mute mode.
  * @retval 0 if correct communication, else wrong communication
  */
unsigned int adv7533_SetMute(short int DeviceAddr, unsigned int Cmd)
{
  unsigned char tmp = 0;
  
  tmp = HDMI_IO_Read(DeviceAddr, 0x0D);
  if (Cmd == AUDIO_MUTE_ON)  
  {
    /* enable audio mute*/ 
    tmp |= 0x40;
    HDMI_IO_Write(DeviceAddr, 0x0D, tmp);
  }
  else
  {
    /*audio mute off disable the mute */
    tmp &= ~0x40;
    HDMI_IO_Write(DeviceAddr, 0x0D, tmp);
  }
  return 0;
}

/**
  * @brief Sets output mode.
  * @param DeviceAddr: Device address on communication Bus.
  * @param Output : hdmi output.
  * @retval 0 if correct communication, else wrong communication
  */
unsigned int adv7533_SetOutputMode(short int DeviceAddr, unsigned char Output)
{
  return 0;
}    
            
/**
  * @brief Sets volumee.
  * @param DeviceAddr: Device address on communication Bus.
  * @param Volume : volume value.
  * @retval 0 if correct communication, else wrong communication
  */           
unsigned int adv7533_SetVolume(short int DeviceAddr, unsigned char Volume)
{
 return 0;
}
            
/**
  * @brief Resets adv7533 registers.
  * @param DeviceAddr: Device address on communication Bus. 
  * @retval 0 if correct communication, else wrong communication
  */
unsigned int adv7533_Reset(short int DeviceAddr)
{
  return 0;
}

/**
  * @brief Sets new frequency.
  * @param DeviceAddr: Device address on communication Bus.
  * @param AudioFreq: Audio frequency used to play the audio stream.
  * @retval 0 if correct communication, else wrong communication
  */
unsigned int adv7533_SetFrequency(short int DeviceAddr, unsigned int AudioFreq)
{
  unsigned char tmp = 0;

  tmp = HDMI_IO_Read(DeviceAddr, 0x15);
  tmp &= (~0xF0);
  /*  Clock Configurations */
  switch (AudioFreq)
  {
  case  AUDIO_FREQUENCY_32K:
    /* Sampling Frequency =32 KHZ*/
    tmp |= 0x30;
    HDMI_IO_Write(DeviceAddr, 0x15, tmp);
    break;
  case  AUDIO_FREQUENCY_44K: 
    /* Sampling Frequency =44,1 KHZ*/
    tmp |= 0x00;
    HDMI_IO_Write(DeviceAddr, 0x15, tmp);
    break;
    
  case  AUDIO_FREQUENCY_48K: 
    /* Sampling Frequency =48KHZ*/
    tmp |= 0x20;
    HDMI_IO_Write(DeviceAddr, 0x15, tmp);
    break;
    
  case  AUDIO_FREQUENCY_96K: 
    /* Sampling Frequency =96 KHZ*/
    tmp |= 0xA0;
    HDMI_IO_Write(DeviceAddr, 0x15, tmp);
    break;
    
  case  AUDIO_FREQUENCY_88K: 
    /* Sampling Frequency =88,2 KHZ*/
    tmp |= 0x80;
    HDMI_IO_Write(DeviceAddr, 0x15, tmp);
    break;
    
  case  AUDIO_FREQUENCY_176K: 
    /* Sampling Frequency =176,4 KHZ*/
    tmp |= 0xC0;
    HDMI_IO_Write(DeviceAddr, 0x15, tmp);
    break;
    
  case  AUDIO_FREQUENCY_192K: 
    /* Sampling Frequency =192KHZ*/
    tmp |= 0xE0;
    HDMI_IO_Write(DeviceAddr, 0x15, tmp);
    break;
  }
  return 0;
}

/**
  * @}
  */

/**
  * @}
  */

/**
  * @}
  */

/**
  * @}
  */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
