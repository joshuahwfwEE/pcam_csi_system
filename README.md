# pcam_csi_system
this project use digient pcam with omni ov5640 as the sensor that is under control over i2c by microblaze, and use xilinx csi rx and tx subsystem to transmit the csi data  
camera seetining is under 1920x1080x30fhz, csi rx receive raw10 data and transfer to axistream, demoasic ise bayer algorithm trnasfer the raw data to rgb, and gamma lut fix and enhance the color mismatch issue, and then vdma drives the video stream to ddr4 and then read by csi tx for output the csi video data  
the purpose: to simulate a camera module through fpga to verify if max96717's csi controller can interpret the mipi data or not.  
