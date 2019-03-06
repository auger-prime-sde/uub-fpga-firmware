#include "Energia.h"
#include "ishan.h"
#include "ds18x20.h"

void DS1820_HI()
{
	DS1820_DIR|=DS1820_DATA_IN_PIN; //set port as output
	DS1820_OUT|=DS1820_DATA_IN_PIN;	//set port high
}
void DS1820_LO()
{
	DS1820_DIR|=DS1820_DATA_IN_PIN; //set port as output
	DS1820_OUT&=~DS1820_DATA_IN_PIN;//set port low
}
void InitDS18B20(void)
{
}
uint8_t ResetDS1820 ( void )   
{
  	/* Steps to reset one wire bus
  	 * Pull bus low 
  	 * hold condition for 480us
  	 * release bus
  	 * wait for 60us
  	 * read bus
  	 * if bus low then device present set / return var accordingly
  	 * wait for balance period (480-60)
  	 */
  	int device_present=1;
    DS1820_LO();       				// Drive bus low
    delayMicroseconds( 480 );                   // hold for 480us
    DS1820_RELEASE;				//release bus. set port in input mode
    delayMicroseconds( 60 );                   // hold for 480us
    if(DS1820_IN & DS1820_DATA_IN_PIN)
	{
		device_present=0;
	}
    delay_us (480);								//wait for 480us
  	return device_present;
}
void WriteZero(void)		
{
	/*Steps for master to transmit logical zero to slave device on bus
	 * pull bus low
	 * hold for 60us
	 * release bus
	 * wait for 1us for recovery 
	 */ 
	
	DS1820_LO();         						// Drive bus low
	delay_us (60);								//sample time slot for the slave
	DS1820_DIR &= ~DS1820_DATA_IN_PIN;			//release bus. set port in input mode
    delay_us (1);								//recovery time slot
	
	
}
void WriteOne(void)			
{
	/*Steps for master to transmit logical one to slave device on bus
	 * pull bus low
	 * hold for 5us
	 * release bus
	 * wait for 1us for recovery 
	 */ 
	DS1820_LO();         						// Drive bus low
	delay_us (5);  
	DS1820_DIR &= ~DS1820_DATA_IN_PIN;			//release bus. set port in input mode
    delay_us (55);								//sample time slot for the slave
    delay_us (1);								//recovery time slot
    
}


void WriteDS1820 (unsigned char data,int power )         
{
   	unsigned char i;
	for(i=8;i>0;i--)
    {
    	
        if(data & 0x01)
        {
            WriteOne();
        }
        else
        {
        	WriteZero();
        }
          	
		data >>=1;
	
    }/*
    if(power == 1) 
    { 
    	DS1820_HI(); 
    	delay_ms(10);
    } 
    */
}

uint8_t ReadBit (void)
{
	
	/*Steps for master to issue a read request to slave device on bus aka milk slave device
	 * pull bus low
	 * hold for 5us
	 * release bus
	 * wait for 45us for recovery 
	 */ 
	int bit=0;
	DS1820_LO();         						// Drive bus low
	delay_us (5);  								//hold for 5us
	DS1820_DIR &= ~DS1820_DATA_IN_PIN;			//release bus. set port in input mode
    delay_us (10);								//wait for slave to drive port either high or low
    if(DS1820_IN & DS1820_DATA_IN_PIN)			//read bus
	{
		bit=1;									//if read high set bit high
	}
    delay_us (46);								//recovery time slot
	return bit;
	
	
}
uint8_t CntRem;		// Count Remain
uint16_t ReadDS1820 ( void )           
{
		  
 	unsigned char i;
 	unsigned int data=0;
	DS1820_DIR &= ~DS1820_DATA_IN_PIN;			//release bus. set port in input mode
 	
 	 for(i=16;i>0;i--)
 	{
		data>>=1;
		if(ReadBit())
		{
			data |=0x8000;
//			data |=0x1;
		}
//		data<<=1;
		
		
	}
	for (i=32; i>0; i-- ) ReadBit(); // Skip byte 2-5
	for ( i=8; i>0; i-- ) 
	{
		CntRem >>=1;
		if(ReadBit())
                {
                        CntRem |= 0x80;
                }
	}
	
	
	return(data);
}

// float GetData(void)
unsigned int  GetData(void)
{
    unsigned int temp;
//    LED0_ON;
  	ResetDS1820();
    WriteDS1820(DS1820_SKIP_ROM,0);
	WriteDS1820(DS1820_CONVERT_T,0);
	DS1820_HI();         						// Drive bus high
    delay_ms(750);
	DS1820_LO();         						// Drive bus low

    ResetDS1820();
	    WriteDS1820(DS1820_SKIP_ROM,0);
	    WriteDS1820(DS1820_READ_SCRATCHPAD,0);
    temp = ReadDS1820();
//	LED0_OFF;
    if(temp>0x8000)     
        temp=(~temp)+1;
    float x = (temp >> 4)-0.25 + (16-CntRem)/16.;    
    temp = x*10; 	// 0.1 Celsius resolution
    return temp+2731;
		
}

