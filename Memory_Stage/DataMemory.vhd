--author: Michael Aziz
--Note: data_memory (writes in the rising_edge and reads always) with 2-different (16 and 32) sizes in paths and out paths
--Note: Big endian memory ex:(address=x"0001" ,datain_32=x"aaaa9999" ==> M(10) = aaaa  &  M(11) = 9999 )
--Note: according to the project document those are the default values in the data_memory:
-- (M[0] & M[1] -> PC)
-- (M[2] & M[3] -> Empty Stack Exception Handler)
-- (M[4] & M[5] -> Invalid Memory Address Exception Handler aka. Address Exceeds 0xFF00)
-- (M[6] & M[7] -> INT 0
-- (M[8] & M[9] -> INT 2
-- Alert!!: Don't forget to handle the exceptions in the bext phase
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY DataMemory IS
	PORT(
		clk,reset,Mem_read,Mem_write  : IN std_logic;
		en_datain_32,en_dataout_32  : IN std_logic;
		address : IN  std_logic_vector(19 DOWNTO 0);
		datain_16  : IN  std_logic_vector(15 DOWNTO 0);
		datain_32  : IN  std_logic_vector(31 DOWNTO 0);
		dataout_16 : OUT std_logic_vector(15 DOWNTO 0);
		dataout_32 : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY DataMemory;

ARCHITECTURE ARCHDataMemory OF DataMemory IS

	TYPE ram_type IS ARRAY(0 TO 1048575) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type ;
	BEGIN
		PROCESS(clk) IS
			BEGIN
--writing in the rising edge
				IF rising_edge(clk) THEN  
--writing from the 32-bit path
					IF (Mem_write = '1' and en_datain_32 = '1') THEN
						ram(to_integer(unsigned(address))) <= datain_32(15 DOWNTO 0);
						ram(to_integer(unsigned(address))-1) <= datain_32(31 DOWNTO 16);
--writing from the 16-bit path
					ELSIF(Mem_write = '1' )  THEN
						ram(to_integer(unsigned(address))) <= datain_16;
					END IF;
				END IF;
		END PROCESS;
--reading on the 16-bit path
		dataout_16 <= ram(to_integer(unsigned(address))) when (Mem_read='1' and en_dataout_32 /= '1' and reset /= '1') 
		else (others => 'X');
--reading on the 32-bit path
		dataout_32 <= ram(to_integer(unsigned((address)) - 1)) & ram(to_integer(unsigned(address)))  when (Mem_read='1' and en_dataout_32 = '1' and reset /= '1' ) 
		else ram(0) & ram(1) when (reset = '1') 
		else (others => 'X');

END ARCHDataMemory;

