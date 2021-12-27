Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

Entity WriteBackStage is
	port(
--general porpuse signal (2 in) (zero out)
		clk , reset : in std_logic;

--------------------------------------------------------------------
--Signals that just passes to next stage (3 in) (3 out)
		register_write , stack_wb : in std_logic;
		wb_address : in std_logic_vector (3 downto 0);

		out_register_write , out_stack_wb : out std_logic;
		out_wb_address : out std_logic_vector (3 downto 0);

--------------------------------------------------------------------
--Signals important for the wb stage (4 in) (2 out)

		write_back_selector , output_signal : in std_logic;
		result , read_data : in std_logic_vector (15 downto 0);

		out_wb_data , out_out_port : out std_logic_vector (15 downto 0)

		);
end WriteBackStage;

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------

Architecture ARCHWriteBackStage of WriteBackStage is



begin
---------------------------------------Signals that just passes to next stage-----------
out_register_write <= register_write;
out_stack_wb <= stack_wb;
out_wb_address <= wb_address;

---------------------------------------logic-----------------------------

out_wb_data <= read_data when(write_back_selector = '0')
else result;

out_out_port <= result when(output_signal = '1');

end ARCHWriteBackStage;