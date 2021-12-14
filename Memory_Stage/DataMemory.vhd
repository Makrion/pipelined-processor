--Big endian memory ex:(address=x"0001" ,datain_32=x"aaaa9999" ==> M(0) = aaaa  &  M(1) = 9999 )
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY DataMemory IS
	PORT(
		clk,reset,Mme_read,Mem_write  : IN std_logic;
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
				IF rising_edge(clk) THEN  
					IF (Mem_write = '1' and en_datain_32 = '1') THEN
						ram(to_integer(unsigned(address))) <= datain_32(15 DOWNTO 0);
						ram(to_integer(unsigned(address))-1) <= datain_32(31 DOWNTO 16);
					ELSIF(Mem_write = '1' )  THEN
						ram(to_integer(unsigned(address))) <= datain_16;
					END IF;
				END IF;
		END PROCESS;
		dataout_16 <= ram(to_integer(unsigned(address))) when (Mme_read='1' and en_dataout_32 /= '1' and reset /= '1') 
		else x"0000";

		dataout_32 <= ram(to_integer(unsigned(address))-1) & ram(to_integer(unsigned(address))) when (Mme_read='1' and en_dataout_32 = '1' and reset /= '1' ) 
		else ram(0) & ram(1) when (reset = '1') 
		else x"00000000";

END ARCHDataMemory;

