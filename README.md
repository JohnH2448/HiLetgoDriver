# HiLetgoDriver
## ILI9486 FPGA Display Controller + Parallel Rasterizer
### Features:
- ILI9486 LCD display controller in Verilog by reverse-engineering protocols from microcontroller C in absence of FPGA-based reference design
- 72 stage init, command/data handling, and full pixel stream
- 6.8 MB/s throughput, 4x higher than optimized microcontroller drivers
- Row framebuffer strategies and parallel, memory-mapped rasterization cut expected BRAM usage by 32x from typical framebuffer systems

### Hardware Used:
- Tang Nano 20k FPGA:
https://www.amazon.com/GW2AR-18-Development-64Mbits-Computer-Console/dp/B0C5XJV83K/ref=sr_1_1?crid=AHP63B9IWMNU&dib=eyJ2IjoiMSJ9.AEwgm-YPxdP261anDq1-Bu_gP_aCEKkdHBaT17zR9VouqlQf8XNcDZCT26HfUOJkWSEf6At6CPa7CbWMSPopx5ayZn6qmjHKfcBzI8nmzH7r2Q0edKgauJqIfopupv9iyIww0p9VGvcQgR2YRTAdlnNuiwOYyp3mxSQHP-uBYUKPbDuqAm-wn_OyDgteA-pyig-Zf20dVU8iCB0eERc-SeDiPXlVwmkHSAH4ogI9-Z0.Oh2U7puf5rDsjRX78m-FAxjgfM-5ykXYMeayaWGWSSY&dib_tag=se&keywords=tang+nano+20k&qid=1767722438&sprefix=tang+nano+20%2Caps%2C450&sr=8-1
- HiLetgo 3.5" TFT LCD Display:
https://www.amazon.com/HiLetgo-Display-ILI9481-480X320-Mega2560/dp/B073R7Q8FF/ref=sxin_17_pa_sp_search_thematic-asin_sspa?content-id=amzn1.sym.23585725-bbe8-413b-a9ac-390ccb0949b4%3Aamzn1.sym.23585725-bbe8-413b-a9ac-390ccb0949b4&crid=1GWX4AKZVN6YA&cv_ct_cx=tft+arduino+display&keywords=tft+arduino+display&pd_rd_i=B073R7Q8FF&pd_rd_r=ef193649-ddd3-42f3-8446-16fb796ce95e&pd_rd_w=BWLrx&pd_rd_wg=IZ765&pf_rd_p=23585725-bbe8-413b-a9ac-390ccb0949b4&pf_rd_r=0A5HKBV8D6B0GQYR4T3Q&qid=1767722492&sbo=RZvfv%2F%2FHxDF%2BO5021pAnSA%3D%3D&sprefix=tft+arduino+displ%2Caps%2C391&sr=1-2-81b96d55-037b-4f7e-b551-051825564156-spons&aref=LK3yigSTH2&sp_csd=d2lkZ2V0TmFtZT1zcF9zZWFyY2hfdGhlbWF0aWM&psc=1
