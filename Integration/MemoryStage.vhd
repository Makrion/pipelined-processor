--author: Michael Aziz
--Note: Mem-stage for our MIPS processor
Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

Entity MemoryStage is
	port(
--general porpuse signal (2 in) (zero out)
		clk , reset : in std_logic;

--------------------------------------------------------------------
--Signals that just passes to next stage (5 in) (5 out)
		register_write , write_Back_selector , output_signal , return_int_rti_flush : in std_logic;
		wb_address : in std_logic_vector (3 downto 0);

		out_register_write , out_write_Back_selector , out_output_signal , out_return_int_rti_flush : out std_logic;
		out_wb_address : out std_logic_vector (3 downto 0);

--------------------------------------------------------------------
--Signals important for the mem stage (12 in) (6 out)
		call_flag , return_flag , mem_write , mem_read , int_flag , rti_flag , pop_flag , push_flag , stack_add : in std_logic;
		pc : in std_logic_vector (31 downto 0);
		result , write_data  : in std_logic_vector (15 downto 0);  --result is the ALU output from the prev. stage

		out_return_flag , out_int_flag , out_rti_flag: out std_logic;
		out_read_data , out_result  : out std_logic_vector (15 downto 0);	--result is the ALU output from the prev. stage
		out_pc : out std_logic_vector (31 downto 0);
		exception_flag: out std_logic				--Yousef: flag indicate stack or address exception
		);
end MemoryStage;
--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------
Architecture ARCHMemoryStage of MemoryStage is
signal or_to_en_datain_32 , or_to_en_dataout_32 ,en_add_stack_pointer ,en_sub_stack_pointer,en_mem_write,en_mem_read: std_logic;
signal mux_to_mem_address,int_address : std_logic_vector (19 downto 0);
signal add_to_mem_32_input , stackpointer_to_addstackpointer , addstackpointer_to_mux , subbstackpointer_to_stackpointer :std_logic_vector (31 downto 0);
signal exception_program_counter :std_logic_vector (31 downto 0);
signal stack_exception_flag , address_exception_flag :std_logic;
begin
---------------------------------------Signals that just passes to next stage-----------
out_register_write <= '0' when stack_exception_flag ='1' or address_exception_flag ='1'
else register_write;
out_write_Back_selector <= write_Back_selector;
out_output_signal <= output_signal;
out_return_int_rti_flush <= return_int_rti_flush;
out_wb_address <= wb_address;

---------------------------------------inputs to data memory maping---------------------
add_to_mem_32_input <= std_logic_vector(unsigned((pc)) + 1);

mux_to_mem_address <= x"00003" when (stack_exception_flag = '1')		--Yousef: address of PC of stack exception
else x"00005"				   when (address_exception_flag = '1')		--Yousef: address of PC of address exception   
else addstackpointer_to_mux(19 downto 0) when (stack_add = '1') 
else (x"0" & result);

or_to_en_datain_32 <= (call_flag or int_flag);

or_to_en_dataout_32 <= (return_flag or rti_flag or int_flag or stack_exception_flag or address_exception_flag); --Yousef: should be enabled to read exception handler

en_add_stack_pointer<= or_to_en_dataout_32 and (not int_flag);				--Yousef added this: The stack pointer shouldn't be increased when the there is and interrupt
en_sub_stack_pointer<= pop_flag and (not stack_exception_flag);				--Yousef added this: The stack pointer shouldn't be decreased when there is a stack exception
en_mem_write<= mem_write and (not address_exception_flag);					--Yousef added this: Memory shouldn't write when there is an address exception
en_mem_read<= mem_read or stack_exception_flag or address_exception_flag;		--Yousef added this: mem read should be enabled to get the address of the exception handler

int_address <= (x"0" & result);
out_result <= result;
out_return_flag <= return_flag;
out_int_flag <= int_flag;
out_rti_flag <= rti_flag;

---------------------------------------data memory maping-------------------------------
map_datamemory : entity work.DataMemory port map ( 
		clk => clk,
		reset => reset,
		Mem_read => en_mem_read,
		Mem_write => en_mem_write,
		en_datain_32 => or_to_en_datain_32,
		en_dataout_32 => or_to_en_dataout_32,
		address => mux_to_mem_address,
		datain_16 => write_data,
		datain_32  => add_to_mem_32_input,
		dataout_16 => out_read_data,
		dataout_32 => out_pc,
		int_address => int_address
	);

---------------------------------------stack pointer maping-----------------------------
map_addstackpointer : entity work.AddStackPointer port map ( 
		en => stack_add,
		add_1 => pop_flag,
		add_2 => en_add_stack_pointer,
		data_in => stackpointer_to_addstackpointer,
		data_out => addstackpointer_to_mux
	);
map_substackpointer : entity work.SubStackPointer port map ( 
		en => stack_add,
		sub_1 => push_flag,
		sub_2 => or_to_en_datain_32,
		data_in => addstackpointer_to_mux,
		data_out => subbstackpointer_to_stackpointer
	);
map_stackpointer : entity work.StackPointer port map ( 
		clk => clk,
		reset => reset,
		en => stack_add,
		d => subbstackpointer_to_stackpointer,
		q => stackpointer_to_addstackpointer
	);


-- handling stack exception

-- process helps to write on the exception_program_counter
PROCESS(clk) IS
BEGIN
	IF falling_edge(clk) THEN  
		IF(stack_exception_flag ='1' or  address_exception_flag ='1')  THEN
			exception_program_counter<=pc;
		END IF;
	END IF;
END PROCESS;

exception_flag<= '1' when stack_exception_flag = '1' or address_exception_flag = '1'
else '0';
----------------------------------------stack exception
stack_exception_flag<= '1' when pop_flag ='1' and (stackpointer_to_addstackpointer = x"000FFFFF")
else '0';

----------------------------------------address exception
address_exception_flag<='1' when stack_add = '0' and result > x"FF00" and (mem_write ='1' or mem_read ='1')
else '0';



end ARCHMemoryStage;