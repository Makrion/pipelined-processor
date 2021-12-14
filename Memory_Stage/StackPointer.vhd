Library ieee;
use ieee.std_logic_1164.all;

Entity StackPointer is
	port(
		clk,reset,en : in std_logic;
		d: in std_logic_vector (31 downto 0);
		q : out std_logic_vector (31 downto 0)
		);
end StackPointer;

Architecture ARCHStackPointer of StackPointer is
begin
process(clk,en,reset)
begin
	if reset='1' then
		 q <= x"000fffff";
	elsif falling_edge(clk) and en='1' then
		 q <=d ;
	end if;  
end process;
end ARCHStackPointer;