library ieee ; 
use ieee.std_logic_1164.all ; 
Entity Integration is 
Generic (n : integer :=16); 

port(		
        clk , reset : in std_logic;
        
    ); 
	 
end Integration ; 



Architecture Integration of Integration is 
 
begin 

map_FetchStage : entity work.FetchStage port map (
		clk=>clk , 
        reset=>reset,
		return_flag => ,
        rti_flag => , 
        int_flag =>, 
        call_flag =>, 
        branch_flag =>,
		hlt_signal => , 
        intrusction_size => ,
		pc_branch_call => , 
        pc_return_rti_int_reset => ,
		out_pc => , 
        out_instruction =>
	);

map_FetchStage : entity work.Decoder port map 
    (
        A => ,
        B => ,
        C => ,
        E => ,
        output=>
    );
	
end Integration;


