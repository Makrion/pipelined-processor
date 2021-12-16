--author: Michael Aziz
--Note: addition module for the stack pointer in the Mem-stage
Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

Entity AddStackPointer is
	port(
		en,add_1,add_2 : in std_logic;
		data_in: in std_logic_vector (31 downto 0);
		data_out : out std_logic_vector (31 downto 0)
		);
end AddStackPointer;

Architecture ARCHAddStackPointer of AddStackPointer is
begin

data_out <= std_logic_vector(unsigned((data_in)) + 2) when (en = '1' and add_1 /= '1' and add_2 = '1')
else 	    std_logic_vector(unsigned((data_in)) + 1) when (en = '1' and add_1 = '1' and add_2 /= '1')
else 	     data_in;

end ARCHAddStackPointer;
