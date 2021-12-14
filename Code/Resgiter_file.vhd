
library ieee ; 
use ieee.std_logic_1164.all ; 


use work.all ; 

Entity Register_file is

port(
WB_data : in std_logic_vector (16 downto  0 );--write back data  
data1_add,data2_add   : in    std_logic_vector (2  downto  0 ); --3 bits for 8 registers 
clk      : in std_logic ; 
Register_write : in std_logic ; -- flag to write data or not (1 if the intsturction will write back to the registers)
WB_address     : in std_logic_vector(2 downto 0); --write back address ; 
data1,data2: out std_logic_vector(16 downto  0 ));---data that is red from the registers 
end Register_file ;



architecture memo_imp of memo is 
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
	A,B ,E    : in std_logic ; 
	output    : out std_logic_vector (3 downto 0) 
	);
	end component;
------------------------------------------------------------------------
	component TSB  is 
	port (
	A: in std_logic_vector(31 downto 0) ;
	E: in std_logic ;  
	q  : out std_logic_vector(31 downto 0)   
	); 
	end component ;
-------------------------------------------------------------------------
	signal dec1,dec2 : std_logic_vector(3 downto 0 ) ;-- dec1 decoder one ->source ,,,,, dec2 decoder two => destination 
	signal DF0,DF1,DF2,DF3: std_logic_vector(31 downto 0); 
	 
	
	
begin 
	
	
	
		SD:   Decoder port map (source(0),source(1),SE,dec1); -- SD => Source Decoder
		DD:   Decoder port map (des(0),des(1),DE,dec2); 	  -- DD => Destination Decoder
		
		
		
		
		DDF0: DFF     port map (clk,rst0,dec2(0),databus, DF0); -- D Flip Flop 0 	
		DDF1: DFF     port map (clk,rst1,dec2(1),databus,DF1);-- D Flip Flop 1
		DDF2: DFF     port map (clk,rst2,dec2(2),databus,DF2);-- D Flip Flop 2 
		DDF3: DFF     port map (clk,rst3,dec2(3),databus,DF3); -- D Flip Flop 3 
		
		
		TSB0: TSB     port map (DF0,dec1(0),databus);-- Tri state buffer 0 
		TSB1: TSB     port map (DF1,dec1(1),databus);-- Tri state buffer 0 	
		TSB2: TSB     port map (DF2,dec1(2),databus);-- Tri state buffer 0 
		TSB3: TSB     port map (DF3,dec1(3),databus);-- Tri state buffer 0 

		q0<=DF0;-- Just an output to show the data on the registers
		q1<=DF1;
		q2<=DF2;
		q3<=DF3;
		




end memo_imp ; 
