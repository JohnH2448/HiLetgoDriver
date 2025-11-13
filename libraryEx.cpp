digitalWrite(_rst, HIGH);
delay(50);
digitalWrite(_rst, LOW);
delay(10);
digitalWrite(_rst, HIGH);
delay(10);

writecommand(0x01);
writedata(0x00);
delay(50);

writecommand(0x28);
writedata(0x00);

writecommand(0xC0);        // Power Control 1
writedata(0x0d);
writedata(0x0d);

writecommand(0xC1);        // Power Control 2
writedata(0x43);
writedata(0x00);

writecommand(0xC2);        // Power Control 3
writedata(0x00);

writecommand(0xC5);        // VCOM Control
writedata(0x00);
writedata(0x48);

writecommand(0xB6);        // Display Function Control
writedata(0x00);
writedata(0x22);           // 0x42 = Rotate display 180 deg.
writedata(0x3B);

writecommand(0xE0);        // PGAMCTRL (Positive Gamma Control)
writedata(0x0f);
writedata(0x24);
writedata(0x1c);
writedata(0x0a);
writedata(0x0f);
writedata(0x08);
writedata(0x43);
writedata(0x88);
writedata(0x32);
writedata(0x0f);
writedata(0x10);
writedata(0x06);
writedata(0x0f);
writedata(0x07);
writedata(0x00);

writecommand(0xE1);        // NGAMCTRL (Negative Gamma Control)
writedata(0x0F);
writedata(0x38);
writedata(0x30);
writedata(0x09);
writedata(0x0f);
writedata(0x0f);
writedata(0x4e);
writedata(0x77);
writedata(0x3c);
writedata(0x07);
writedata(0x10);
writedata(0x05);
writedata(0x23);
writedata(0x1b);
writedata(0x00); 

writecommand(0x20);        // Display Inversion OFF, 0x21 = ON

writecommand(0x36);        // Memory Access Control
writedata(0x0A);

writecommand(0x3A);        // Interface Pixel Format
writedata(0x55); 

writecommand(0x11);

delay(150);

writecommand(0x29);
delay(25);