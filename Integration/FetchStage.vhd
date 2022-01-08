Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

Entity FetchStage is
	port(
--general porpuse signal (2 in) (zero out)
		clk , reset : in std_logic;

--------------------------------------------------------------------
--Signals important for the PCLogic (4 in) (2 out)

		return_flag , rti_flag , int_flag , call_flag , branch_flag : in std_logic;
		exception_flag : in std_logic;
		hlt_signal , intrusction_size : in std_logic;
		pc_branch_call , pc_return_rti_int_reset : in std_logic_vector (31 downto 0);

		out_pc , out_instruction : out std_logic_vector (31 downto 0)
		);
end FetchStage;

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------

Architecture ARCHFetchStage of FetchStage is
signal pc , pc_next_instruction , pc_next :std_logic_vector (31 downto 0);
begin
---------------------------------------logic-----------------------------

	pc_next_instruction <= std_logic_vector(unsigned((pc)) + 1) when(intrusction_size = '0')
	else std_logic_vector(unsigned((pc)) + 2);

	out_pc <= pc;

	PROCESS(clk) IS
		BEGIN
			IF falling_edge(clk) THEN  
				IF (hlt_signal = '0') THEN
					pc <= pc_next;
				END IF;
			END IF;
	END PROCESS;

---------------------------------------PCLogic maping-------------------------------
map_PCLogic : entity work.PCLogic port map ( 
		selector_reset =>reset,
		selector_branch =>branch_flag,
		selector_exception => exception_flag,
	 	selector_call => call_flag,
		selector_return => return_flag,
 		selector_rti => rti_flag,
	 	selector_int => int_flag,
		pc_next_instruction => pc_next_instruction,
	 	pc_branch_call => pc_branch_call,
	 	pc_return_rti_int_reset => pc_return_rti_int_reset,	
		out_pc => pc_next
	);

map_InstMem : entity work.InstructionMemory port map ( 
		address => pc,
		dataout => out_instruction
	);


end ARCHFetchStage;