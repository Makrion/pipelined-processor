library ieee ; 
use ieee.std_logic_1164.all ; 

Entity Integration is 
port(		
        clk , reset : in std_logic;
        out_port : out std_logic_vector (15 downto 0);


-------------------------------------------------------------------temporary ports to be deleted when we finish integerating all stages
	register_write  , write_Back_selector , output_signal , return_int_rti_flush : in std_logic;
	wb_address : in std_logic_vector (3 downto 0);
	call_flag , return_flag , mem_write , mem_read , int_flag , rti_flag , pop_flag , push_flag , stack_add : in std_logic;
	pc : in std_logic_vector (31 downto 0);
	result , write_data  : in std_logic_vector (15 downto 0);

	out_return_int_rti_flush : out std_logic;
	out_return_flag , out_int_flag , out_rti_flag: out std_logic;
	out_pc : out std_logic_vector (31 downto 0);

	out_stack_wb : out std_logic;        --------------------------------------------------------(we don't use it) revise it later
-------------------------------------------------------------------temporary ports to be deleted when we finish integerating all stages
    ); 
	 
end Integration ; 



Architecture Integration of Integration is 
 



-----------signals-between-memory-and-write-back
signal buffer_to_wb, memory_to_buffer : std_logic_vector (39 downto 0);
-----------LSB
-----------[16] read_data
-----------[16]	Result
-----------[4] wb_address
-----------[1] register_write
-----------[1] write_Back_selector
-----------[1] output_signal
-----------MSB

-----------signals-between-fetch-and-decoding
signal buffer_to_decode, fetch_to_buffer : std_logic_vector (63 downto 0);
-----------LSB
-----------[32] pc
-----------[32]	instruction
-----------MSB

----------------------decode signals
signal controller_signals : std_logic_vector(25:0); 

--------------write back signals
signal out_wb_data :  std_logic_vector (15 downto 0);
signal out_register_write :  std_logic;  
signal out_wb_address :  std_logic_vector (3 downto 0)


-----todo split the instruction after the decoding stage
-----todo don't forget the in port 

begin 

----------------------------------------------------------------------------------------------------------------integ-fetch-decode
map_FetchStage : entity work.FetchStage port map (
		clk =>clk , 
		reset =>reset , 
		return_flag , 
		rti_flag , 
		int_flag , 
		call_flag , 
		branch_flag in ,
		hlt_signal => controller_signals(25), 
		intrusction_size => controller_signals(24), 
		pc_branch_call , 
		pc_return_rti_int_reset : in std_logic_vector (31 downto 0);
		out_pc => fetch_to_buffer(31 downto 0), 
		out_instruction => fetch_to_buffer(63 downto 32)
		);

map_Stage_fetch_decode_Buffer : entity work.StageBuffer generic map (64) port map (
		 clk => clk,
		 rst => reset or controller_signals(5) or '0', ----todo add pc selector (branch or not)
		 en => (not controller_signals(25)),
		 d => fetch_to_buffer,  
		 q => buffer_to_decode
		);

map_Decodingstage : entity work.Decodingstage port map ( 
		instruction => buffer_to_decode(63 downto 32),
          	clk =>clk ,
		reset =>reset ,  
          	wb_data  =>out_wb_data,
          	Register_write =>out_register_write ,
          	WB_address =>out_wb_address , 
          	data1,
		data2,
          	signals => controller_signals
    		);


----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------integ-memory-wb
map_MemoryStage : entity work.MemoryStage port map (
		clk => clk,
		reset => reset,  
		--------------------------------temporary signals to be deleted when we finish integerating all stages
		register_write => register_write, 
		write_Back_selector => write_Back_selector, 
		output_signal => output_signal, 
		return_int_rti_flush => return_int_rti_flush,
		wb_address => wb_address,
		call_flag => call_flag, 
		return_flag => return_flag,
		mem_write => mem_write, 
		mem_read => mem_read,
		int_flag => int_flag, 
		rti_flag => rti_flag, 
		pop_flag => pop_flag,
		push_flag => push_flag, 
		stack_add => stack_add,
		pc => pc, 
		result => result, 
		write_data => write_data,
		--------------------------------buffer signals
		out_register_write => memory_to_buffer(36),
		out_write_Back_selector => memory_to_buffer(37),
		out_output_signal => memory_to_buffer(38),
		out_wb_address => memory_to_buffer(35 downto 32),
		out_read_data => memory_to_buffer(15 downto 0),
		out_result => memory_to_buffer(31 downto 16),
		--------------------------------back signals
		--------------------------------temporary signals to be deleted when we finish integerating all stages
		out_return_int_rti_flush => out_return_int_rti_flush,
		out_return_flag => out_return_flag,
		out_int_flag => out_int_flag, 
		out_rti_flag => out_rti_flag,
		out_pc => out_pc
		);

map_Stage_mem_wb_Buffer : entity work.StageBuffer generic map (40) port map (
		 clk => clk,
		 rst => reset,
		 en => '1',
		 d => memory_to_buffer,  
		 q => buffer_to_wb
		);

map_WriteBackStage : entity work.WriteBackStage port map (

		clk => clk,
		reset => reset,  
		register_write => buffer_to_wb(36),
		wb_address => buffer_to_wb(35 downto 32),
		write_back_selector => buffer_to_wb(37),
		output_signal => buffer_to_wb(38),
		result => buffer_to_wb(31 downto 16),
	        read_data => buffer_to_wb(15 downto 0),
		stack_wb => '0',         --------------------------------------------------------(we don't use it) revise it later
		out_out_port => out_port,
		--------------------------------temporary signals to be deleted when we finish integerating all stages
		out_wb_data => out_wb_data,
		out_register_write => out_register_write,
		out_stack_wb => out_stack_wb,        --------------------------------------------------------(we don't use it) revise it later
		out_wb_address => out_wb_address
		);

	
----------------------------------------------------------------------------------------------------------------
end Integration;


