# pcam_csi_system
this project use digient pcam with omni ov5640 as the sensor that is under control over i2c by microblaze, and use xilinx csi rx and tx subsystem to transmit the csi data  
camera seetining is under 1920x1080x30fhz, csi rx receive raw10 data and transfer to axistream, demoasic ise bayer algorithm trnasfer the raw data to rgb, and gamma lut fix and enhance the color mismatch issue, and then vdma drives the video stream to ddr4 and then read by csi tx for output the csi video data  


the purpose: to simulate a camera module through fpga to verify if max96717's csi controller can interpret the mipi data or not.  
xilinx reference csitx_hs mode PPI interface waveform:   
![alt text](https://github.com/joshuahwfwEE/pcam_csi_system/blob/main/xilinxcsitxhsmode.png?raw=true)  

csitx_hs mode PPI interface waveform:  
![alt text](https://github.com/joshuahwfwEE/pcam_csi_system/blob/main/csitx_hs_ila.png?raw=true)  

the period between txrequesths and txreadyhs is called " start-up time " which means that   
start-up time = 2*LPX_TIME + HS_PREPARE_TIME + HS_ZERO_TIME + CDC_DELAY  
Where HS_PREPARE and HS_ZERO are D-PHY protocol timing parameters and maximum values
used in the IP. You cannot control theHS_PREPARE and HS_ZERO values as they are
automatically calculated based on the line rate.  
CDC_DELAY will be 30 ns + 2 txbyteclkhs.  
LPX can edit in the ip setting  


High-Speed Clock Transmission:  
Switching the Clock Lane between Clock Transmission and LP Mode A Clock Lane is a unidirectional Lane from Master to Slave In HS mode,   
the clock Lane provides a low-swing, differential DDR clock signal. the Clock Burst always starts and ends with an HS-0 state.  
the Clock Burst always contains an even number of transitions  


High-Speed Data Transmission:
The action of sending high-speed serial data is called HS transmission or burst.   
Start-of-Transmission LP-11→LP-01→LP-00→SoT(0001_1101)   
HS Data Transmission Burst All Lanes will start synchronously But may end at different times The clock Lane shall be in High-Speed mode,   
providing a DDR Clock to the Slave side End-of-Transmission H Toggles differential state immediately after last payload data bit and keeps that state for a time THS-TRAIL
