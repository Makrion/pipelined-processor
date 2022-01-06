library ieee ; 
use ieee.std_logic_1164.all ;

Entity decoding_stage is
    port( instruction       : in std_logic_vector(31 downto 0);
          clk ,reset     : in std_logic ;  
          wb_data           : in std_logic_vector (15 downto  0 );
          Register_write : in std_logic ; -- flag to write data or not (1 if the intsturction will write back to the registers)
          WB_address     : in std_logic_vector(2 downto 0); --write back address ; 
          data1,data2       : out std_logic_vector(15 downto  0 );
          signals        : out std_logic_vector(25 downto 0)
    );
    end decoding_stage ; 



Architecture decoding_stage_imp of decoding_stage is 
------------------------------------------------------------------------

    component controller is
        port(reset: in std_logic ; 
            opcode         : in std_logic_vector (5 downto 0); 
            signals        : out std_logic_vector(25 downto 0));
    end component ; 


------------------------------------------------------------------------


    component Register_file is
        port(
        WB_data : in std_logic_vector (15 downto  0 );--write back data  
        data1_add,data2_add   : in    std_logic_vector (2  downto  0 ); --3 bits for 8 registers 
        clk      : in std_logic ; 
        Register_write : in std_logic ; -- flag to write data or not (1 if the intsturction will write back to the registers)
        WB_address     : in std_logic_vector(2 downto 0); --write back address ; 
        data1,data2: out std_logic_vector(15 downto  0 ));---data that is red from the registers 
    end component ;
 
------------------------------------------------------------------------

    signal data1_output, data2_output : std_logic_vector(15 downto  0 ); 
    signal signals_output             : std_logic_vector(25 downto 0 ); 
    begin 
       
        -- from 25 down to 22 the 25th bit will be zero 
        -- from 21 down to 18 the 21th bit will be zero 
        data1_data2 : Register_file port map ( wb_data,instruction(24 downto 22),
                                               instruction(20 downto 18),clk,
                                               Register_write,WB_address,data1_output,data2_output);
        controller_signal  : controller    port map (reset,instruction(31 downto 26),signals_output ); 


        data1<=data1_output; 
        data2<=data2_output;
        signals<=signals_output; 


	

	
end decoding_stage_imp;





