--author: Michael Aziz
--Note: the stack pointer in the Mem-stage (writing in the falling_edge and reading always)
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
--giving a reset signal to the stack pointer should reset it to the last location in the data-memory which is the start of the stack
	if reset='1' then
		 q <= x"000fffff";
--assuming that our clk starts from high and the data memory writes on the rising edge --> so, 
				--the stack pointer should be updated after being modified in the falling edge of the same clk cycle
	elsif falling_edge(clk) and en='1' then
		 q <=d ;
	end if;  
end process;
end ARCHStackPointer;