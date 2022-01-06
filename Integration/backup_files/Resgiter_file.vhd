
library ieee ; 
use ieee.std_logic_1164.all ; 


use work.all ; 

Entity Register_file is

port(
WB_data : in std_logic_vector (15 downto  0 );--write back data  
data1_add,data2_add   : in    std_logic_vector (2  downto  0 ); --3 bits for 8 registers 
clk      : in std_logic ; 
Register_write : in std_logic ; -- flag to write data or not (1 if the intsturction will write back to the registers)
WB_address     : in std_logic_vector(2 downto 0); --write back address ; 
data1,data2: out std_logic_vector(15 downto  0 ));---data that is red from the registers 
end Register_file ;



architecture Register_file_imp of Register_file is 
------------------------------------------------------------------------
	component DFF is 
		Generic (n : integer :=16); 

		port(clk , rst ,E: in std_logic ; 
			 d         : in std_logic_vector (n-1 downto 0); 
			 q         : out std_logic_vector(n-1 downto 0)); 
	end component ; 
------------------------------------------------------------------------
	component Decoder is 
	port (
	A,B,C ,E    : in std_logic ; 
	output    : out std_logic_vector (7 downto 0) 
	);
	end component;
------------------------------------------------------------------------
	component TSB  is 
	port (
	A: in std_logic_vector(15 downto 0) ;
	E: in std_logic ;  
	q  : out std_logic_vector(15 downto 0)   
	); 
	end component ;
-------------------------------------------------------------------------
	signal data1_decoder,data2_decoder,WB_decoder : std_logic_vector(7 downto 0 ) ;-- dec1 decoder one ->source ,,,,, dec2 decoder two => destination 
	signal DF0,DF1,DF2,DF3,DF4,DF5,DF6,DF7: std_logic_vector(15 downto 0); 
	 
	
	
begin 
	
	
		data1_decode:   Decoder port map (data1_add(0),data1_add(1),data1_add(2),'1',data1_decoder);                   -- data1_decoder
		data2_decode:   Decoder port map (data2_add(0),data2_add(1),data2_add(2),'1',data2_decoder); 	                 -- data2_decoder
		WB_decode   :   Decoder port map (WB_address(0),WB_address(1),WB_address(2),Register_write,WB_decoder); 	 -- WB write_back decoder
		
		
		
		-- Writing 
		DDF0_output1: DFF     port map (clk,'0',WB_decoder(0),WB_data,DF0);  -- D Flip Flop 0 	
		DDF1_output1: DFF     port map (clk,'0',WB_decoder(1),WB_data,DF1);  -- D Flip Flop 1
		DDF2_output1: DFF     port map (clk,'0',WB_decoder(2),WB_data,DF2);  -- D Flip Flop 2 
		DDF3_output1: DFF     port map (clk,'0',WB_decoder(3),WB_data,DF3);  -- D Flip Flop 3 
		DDF4_output1: DFF     port map (clk,'0',WB_decoder(4),WB_data,DF4);  -- D Flip Flop 4 	
		DDF5_output1: DFF     port map (clk,'0',WB_decoder(5),WB_data,DF5);  -- D Flip Flop 5
		DDF6_output1: DFF     port map (clk,'0',WB_decoder(6),WB_data,DF6);  -- D Flip Flop 6 
		DDF7_output1: DFF     port map (clk,'0',WB_decoder(7),WB_data,DF7);  -- D Flip Flop 7 
		
		
		TSB0:  TSB      port map (DF0,data1_decoder(0),data1); -- Tri state buffer data1
		TSB1:  TSB      port map (DF1,data1_decoder(1),data1); -- Tri state buffer data1 	
		TSB2:  TSB      port map (DF2,data1_decoder(2),data1); -- Tri state buffer data1 
		TSB3:  TSB      port map (DF3,data1_decoder(3),data1); -- Tri state buffer data1
		TSB4:  TSB      port map (DF4,data1_decoder(4),data1); -- Tri state buffer data1 
		TSB5:  TSB      port map (DF5,data1_decoder(5),data1); -- Tri state buffer data1 	
		TSB6:  TSB      port map (DF6,data1_decoder(6),data1); -- Tri state buffer data1 
		TSB7:  TSB      port map (DF7,data1_decoder(7),data1); -- Tri state buffer data1 

		TSB8:  TSB      port map (DF0,data2_decoder(0),data2); -- Tri state buffer data2
		TSB9:  TSB      port map (DF1,data2_decoder(1),data2); -- Tri state buffer data2 	
		TSB10: TSB      port map (DF2,data2_decoder(2),data2); -- Tri state buffer data2 
		TSB11: TSB      port map (DF3,data2_decoder(3),data2); -- Tri state buffer data2
		TSB12: TSB      port map (DF4,data2_decoder(4),data2); -- Tri state buffer data2 
		TSB13: TSB      port map (DF5,data2_decoder(5),data2); -- Tri state buffer data2 	
		TSB14: TSB      port map (DF6,data2_decoder(6),data2); -- Tri state buffer data2 
		TSB15: TSB      port map (DF7,data2_decoder(7),data2); -- Tri state buffer data2 

		-- q0<=DF0;-- Just an output to show the data on the registers
		-- q1<=DF1;
		-- q2<=DF2;
		-- q3<=DF3;
		




end Register_file_imp ; 
