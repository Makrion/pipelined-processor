Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

Entity PCLogic is
	port(
--------------------------------------------------------------------
--Signals important for the PCLogic (4 in) (2 out)

		selector_reset , selector_branch , selector_call : in std_logic; 
		selector_return , selector_rti , selector_int ,selector_exception: in std_logic;

		pc_next_instruction , pc_branch_call , pc_return_rti_int_reset : in std_logic_vector (31 downto 0);
		
		out_pc : out std_logic_vector (31 downto 0)
		);
end PCLogic;

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------

Architecture ARCHPCLogic of PCLogic is

begin
---------------------------------------logic-----------------------------

out_pc <= pc_branch_call when(selector_branch = '1' or selector_call = '1')
else pc_return_rti_int_reset when(selector_return = '1' or selector_rti = '1' or selector_int= '1' or selector_reset = '1' or selector_exception = '1')
else pc_next_instruction;


end ARCHPCLogic;