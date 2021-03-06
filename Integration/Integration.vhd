library ieee ; 
use ieee.std_logic_1164.all ; 

Entity Integration is 
port(		
        clk , reset : in std_logic;
        out_port : out std_logic_vector (15 downto 0);
		in_port	: in std_logic_vector (15 downto 0);

		out_stack_wb : out std_logic        --------------------------------------------------------(we don't use it) revise it later
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

-----------signals-between-decode-and-excute
signal buffer_to_excute, decode_to_buffer : std_logic_vector (135 downto 0);
-----------LSB
-----------[26] contoller signals	25:0
-----------[32]	pc					57:26
-----------[16] data1				73:58
-----------[16]	data2				89:74
-----------[16]	in_port				105:90
-----------[16]	offset 				121:106
-----------[4]	destinationaddress1 125:122
-----------[4]	destinationaddress2	129:126
-----------[3]  out_source1_forwardingunit   130:132  ----added for the hazard 
-----------[3]  out_source2_forwardingunit   133:135  ----added for the hazard
-----------MSB

-----------signals-between-excute-and-memory
signal buffer_to_memory, excution_to_buffer : std_logic_vector (81 downto 0);
-----------LSB
-----------[1] out_return_flag         			0
-----------[1] out_call_flag            		1
-----------[1] out_register_write       		2
-----------[1] out_write_Back_selector  		3
-----------[1] out_mem_write            		4
-----------[1] out_mem_read             		5
-----------[1] out_output_signal        		6
-----------[1] out_return_int_rti_flush 		7
-----------[1] out_call_flush           		8
-----------[1] out_push_flag            		9
-----------[1] out_pop_flag             		10
-----------[1] out_int_flag             		11
-----------[1] out_rti_flag  					12
-----------[32] pc								44:13
-----------[16] result 							60:45
-----------[1] stack_address					61
-----------[16] write_data						77:62
-----------[4] write_back_address				81:78
-----------MSB

----------------------decode signals
signal decode_buffer_rst :std_logic; 

--------------write back signals
signal out_wb_data :  std_logic_vector (15 downto 0);
signal out_register_write :  std_logic;  
signal out_wb_address :  std_logic_vector (3 downto 0);


-----todo split the instruction after the decoding stage
-----todo don't forget the in port

---------------excute signals
signal out_pc_selector_branch_ornot : std_logic;
signal out_branch_call_pc : std_logic_vector(31 downto 0);

---------------memory signals
signal out_mem_return_int_rti_flush : std_logic;
signal out_mem_return_flag : std_logic;
signal out_mem_int_flag : std_logic;
signal out_mem_rti_flag : std_logic;
signal out_mem_pc_return_rti_int_reset : std_logic_vector(31 downto 0);

---------------fetch signals
signal fetch_buffer_en :std_logic;
signal fetch_buffer_rst :std_logic;

--------------exception
signal signal_exception_flag : std_logic;

----------------forwarding unit the two selectors to ex stage for the two muxes
signal out_data_forwarding_selector1 : std_logic_vector(1 downto 0);
signal out_data_forwarding_selector2 : std_logic_vector(1 downto 0);

---------------------------------------------------------------------------------------------
---------------------------------------------Hazard detection unit ; 
signal out_hazard_control_unit_selector        : std_logic; 
signal out_hazard_control_unit_en    	       : std_logic;
signal out_hazard_control_unit_Pc_write_or_not : std_logic;

-----------------------------------------------------
signal pc_enable :std_logic ; -- this will be used to stop the increment of the pc if hazard decteion unit pc write or not =0 or hlt signal =1 ; 
------------------------------------------------------
begin 


pc_enable <= decode_to_buffer(25) or not(out_hazard_control_unit_Pc_write_or_not);

----------------------------------------------------------------------------------------------------------------integ-fetch-decode
map_FetchStage : entity work.FetchStage port map (
		clk =>clk , 
		reset =>reset , 
		return_flag =>out_mem_return_flag, 
		rti_flag =>out_mem_rti_flag, 
		int_flag =>out_mem_int_flag, 
		call_flag =>excution_to_buffer(1), 
		branch_flag =>out_pc_selector_branch_ornot ,		---pc selector branch ornot
		hlt_signal => pc_enable, 			---decode_to_buffer here = controller signals
		intrusction_size => decode_to_buffer(24), 		---decode_to_buffer here = controller signals
		pc_branch_call =>out_branch_call_pc, 
		pc_return_rti_int_reset =>out_mem_pc_return_rti_int_reset,
		out_pc => fetch_to_buffer(31 downto 0), 		
		out_instruction => fetch_to_buffer(63 downto 32),
		----exception
		exception_flag => signal_exception_flag
		);

fetch_buffer_en <= (not decode_to_buffer(25) and (not out_hazard_control_unit_en)); ---decode_to_buffer here = controller signals
--			flush from controller		
--removed or decode_to_buffer(5) for now causing and error to flush the buffer in the current instruction (fetch flush signal)	
---					exception flag			branch ornot					call flush				return_int_rti flush from ex	return_int_rti flush from mem
fetch_buffer_rst <=signal_exception_flag or out_pc_selector_branch_ornot or buffer_to_excute(23) or buffer_to_excute(22) or buffer_to_memory(7);		

map_Stage_fetch_decode_Buffer : entity work.StageBuffer generic map (64) port map (
		 clk => clk,
		 rst => reset ,
		 flush => fetch_buffer_rst,	  	    
		 en => fetch_buffer_en,			---decode_to_buffer here = controller signals
		 d => fetch_to_buffer,  
		 q => buffer_to_decode
		);


----------------------------------------------------------------------------------------------------------------
hazard_detection_unit: entity work.hazard_detection_unit port map(
	source1=>buffer_to_decode(56 downto 54),
	source2=>buffer_to_decode(52 downto 50),         
	load_address=>buffer_to_excute(128 downto 126),            
	mem_read=>buffer_to_excute(16),                
	control_signals_selector=>out_hazard_control_unit_selector,
	stop_fetch_flag=> out_hazard_control_unit_en,         
	PC_wirte_or_not=>out_hazard_control_unit_Pc_write_or_not        
);
	
-----------------------------------------------------------------------------------------------------integ-Excute-memory


-----------------------------------------------------------------------------------------------------integ-decode-Excute

map_Decodingstage : entity work.decoding_stage port map (
		in_port => in_port, 
		pc =>buffer_to_decode(31 downto 0),
		instruction => buffer_to_decode(63 downto 32),
        clk =>clk ,
		reset =>reset ,  
        wb_data  =>out_wb_data,
        Register_write =>out_register_write ,
        WB_address =>out_wb_address(2 downto 0) , 
        data1 =>decode_to_buffer(73 downto 58),
		data2 =>decode_to_buffer(89 downto 74),
        signals => decode_to_buffer(25 downto 0),
		out_pc => decode_to_buffer(57 downto 26),
        out_offset => decode_to_buffer(121 downto 106),
        out_destinationaddress1 => decode_to_buffer(125 downto 122),
        out_destinationaddress2 => decode_to_buffer(129 downto 126),
		out_in_port => decode_to_buffer(105 downto 90),
		out_source1_forwardingunit => decode_to_buffer(132 downto 130),
		out_source2_forwardingunit => decode_to_buffer(135 downto 133),
		control_signal_selector=>out_hazard_control_unit_selector
    	);

--return_int_rti flush from mem
decode_buffer_rst<= buffer_to_memory(7)		or 	signal_exception_flag;-- or out_pc_selector_branch_ornot removed this as it caused error (deleted its own buffer) ;

map_Stage_decode_ex_Buffer : entity work.StageBuffer generic map (136) port map (
		clk => clk,
		rst => reset,
		flush => decode_buffer_rst,
		en => '1',
		d => decode_to_buffer,  
		q => buffer_to_excute
	);
---------------------------------------------------------------------------
--                   forwarding unit
---------------------------------------------------------------------------
map_forwardingunit : entity work.forwarding_unit port map (
	source1 => buffer_to_excute(132 downto 130), --from the D-BUFFER-EX
	source2 => buffer_to_excute(135 downto 133), --from the D-BUFFER-EX
	register_write_mem => buffer_to_memory(2), --from the EX-BUFFER-mem
    register_write_wb => buffer_to_wb(36), --from the MEM-BUFFER-WB
	wb_address_mem => buffer_to_memory(80 downto 78),--wb address from mem stage
	wb_address_wb => buffer_to_wb(34 downto 32),-- wb address from wb_stage (the green wire)
	data1_selector => out_data_forwarding_selector1,
	data2_selector => out_data_forwarding_selector2
);



----------------------------------------------------------------------------------------------------------------
	
-----------------------------------------------------------------------------------------------------integ-Excute-memory

map_ExecuteStage : entity work.ExecutionStage port map (
			clk =>clk , 
			reset => reset ,

		--Signals that just passes to next stage (13 in) (13 out)--------------------------
			return_flag =>buffer_to_excute(11) , 
			call_flag =>buffer_to_excute(12) , 
			register_write =>buffer_to_excute(13), 
			write_Back_selector =>buffer_to_excute(14) , 
			mem_write =>buffer_to_excute(15), 
			mem_read =>buffer_to_excute(16), 
			output_signal =>buffer_to_excute(18),
			return_int_rti_flush =>buffer_to_excute(22),
			call_flush =>buffer_to_excute(23),
			push_flag =>buffer_to_excute(8) , 
			pop_flag =>buffer_to_excute(7) ,
			int_flag =>buffer_to_excute(10),
			rti_flag =>buffer_to_excute(9),

			--- the out of these signals 
			out_return_flag =>excution_to_buffer(0), 
			out_call_flag =>excution_to_buffer(1),
			out_register_write =>excution_to_buffer(2), 
			out_write_Back_selector =>excution_to_buffer(3), 
			out_mem_write =>excution_to_buffer(4), 
			out_mem_read =>excution_to_buffer(5), 
			out_output_signal =>excution_to_buffer(6),
			out_return_int_rti_flush =>excution_to_buffer(7), 
			out_call_flush =>excution_to_buffer(8),  
			out_push_flag =>excution_to_buffer(9), 
			out_pop_flag =>excution_to_buffer(10), 
			out_int_flag =>excution_to_buffer(11),
			out_rti_flag =>excution_to_buffer(12),

		--Signals important for the exxecution stage  ---------------------------------
			wb_destination_selector =>buffer_to_excute(17) , 
			branch_flag =>buffer_to_excute(19), 
			mem_data_write =>buffer_to_excute(6),
			alu_control =>buffer_to_excute(4 downto 0),   
			alu_src =>buffer_to_excute(21 downto 20),
			
		---inputs -------------------------------------------       
			pc =>buffer_to_excute(57 downto 26),     -- just pass the pc
			data1 =>buffer_to_excute(73 downto 58),   --source1
			data2 =>buffer_to_excute(89 downto 74), --goes into a mux that decide which is source2
			in_port =>buffer_to_excute(105 downto 90), ---goes into a mux that decide which is source2
			offset  =>buffer_to_excute(121 downto 106), --goes into a mux that decide which is source2 {from [0,15]}
			destinationaddress1 =>buffer_to_excute(125 downto 122), --bits form [0,3] to decide the destination with a mux
			destinationaddress2 =>buffer_to_excute(129 downto 126), --bits from [16,19] to decide the destination with a mux goes also to source2  x"000" & arg
         -----for the hazards---------------------------------
		    wb_data => out_wb_data,--we take it from the wb_stage
			data_forwarded => buffer_to_memory(60 downto 45),--we take it from the memory stage
			data_forwarding_selector1=> out_data_forwarding_selector1,--from fw unit
			data_forwarding_selector2=> out_data_forwarding_selector2, --from fw unit
		--outputs--------------------------------------------
			out_pc =>excution_to_buffer(44 downto 13), 		-- passing the pc
			branch_call_pc =>out_branch_call_pc, 			--is taken from data1
			wb_address =>excution_to_buffer(81 downto 78),    			--either destinationadd1 or destinationadd2 
			stack_address =>excution_to_buffer(61),
			pc_selector_branch_ornot =>out_pc_selector_branch_ornot,	--out of an and gate 
			result =>excution_to_buffer(60 downto 45),     				--output of the alu
			write_data =>excution_to_buffer(77 downto 62)				--the data passed to the memory either src1 or src2
	    );


	map_Stage_excute_memoy_Buffer : entity work.StageBuffer generic map (82) port map (
		 clk => clk,
		 rst => reset,
		 flush =>'0',
		 en => '1',
		 d => excution_to_buffer,  
		 q => buffer_to_memory
		);
----------------------------------------------------------------------------------------------------------------integ-memory-wb
map_MemoryStage : entity work.MemoryStage port map (
		clk => clk,
		reset => reset,  
		--------------------------------temporary signals to be deleted when we finish integerating all stages
		register_write => buffer_to_memory(2) , 
		write_Back_selector => buffer_to_memory(3) , 
		output_signal => buffer_to_memory(6), 
		return_int_rti_flush => buffer_to_memory(7) ,
		wb_address => buffer_to_memory(81 downto 78) ,
		call_flag => buffer_to_memory(1) , 
		return_flag => buffer_to_memory(0),
		mem_write => buffer_to_memory(4) , 
		mem_read => buffer_to_memory(5) ,
		int_flag => buffer_to_memory(11)  ,
		rti_flag => buffer_to_memory(12)  ,
		pop_flag => buffer_to_memory(10) ,
		push_flag => buffer_to_memory(9) , 
		stack_add => buffer_to_memory(61) ,
		pc => buffer_to_memory(44 downto 13), 
		result => buffer_to_memory(60 downto 45), 
		write_data => buffer_to_memory(77 downto 62),
		--------------------------------buffer signals
		out_register_write => memory_to_buffer(36),
		out_write_Back_selector => memory_to_buffer(37),
		out_output_signal => memory_to_buffer(38),
		out_wb_address => memory_to_buffer(35 downto 32),
		out_read_data => memory_to_buffer(15 downto 0),
		out_result => memory_to_buffer(31 downto 16),
		--------------------------------back signals
		--------------------------------temporary signals to be deleted when we finish integerating all stages
		out_return_int_rti_flush => out_mem_return_int_rti_flush,
		out_return_flag => out_mem_return_flag,
		out_int_flag => out_mem_int_flag, 
		out_rti_flag => out_mem_rti_flag,
		out_pc => out_mem_pc_return_rti_int_reset,
		-- exception
		exception_flag => signal_exception_flag
		);

map_Stage_mem_wb_Buffer : entity work.StageBuffer generic map (40) port map (
		 clk => clk,
		 rst => reset,
		 flush => '0',
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

		out_wb_data => out_wb_data,
		out_register_write => out_register_write,
		out_stack_wb => out_stack_wb,        --------------------------------------------------------(we don't use it) revise it later
		out_wb_address => out_wb_address
		);


	

end Integration;


