
library ieee ; 
use ieee.std_logic_1164.all ;

Entity decoding_stage is
    port( 
          in_port           : in std_logic_vector (15 downto  0 );
          pc                : in std_logic_vector(31 downto 0);
          instruction       : in std_logic_vector(31 downto 0);
          clk ,reset     : in std_logic ;  
          wb_data           : in std_logic_vector (15 downto  0 );
          Register_write : in std_logic ; -- flag to write data or not (1 if the intsturction will write back to the registers)
          WB_address     : in std_logic_vector(2 downto 0); --write back address ; 
          data1,data2       : out std_logic_vector(15 downto  0 );
          signals        : out std_logic_vector(25 downto 0);
          out_pc                : out std_logic_vector(31 downto 0);
          out_offset  : out std_logic_vector (15 downto 0); --goes into a mux that decide which is source2 {from [0,15]}
          out_destinationaddress1 : out std_logic_vector (3 downto 0); --bits form [0,3] to decide the destination with a mux
          out_destinationaddress2 : out std_logic_vector (3 downto 0); --bits from [16,19] to decide the destination with a mux goes also to source2  x"000" & arg
          out_in_port           : out std_logic_vector (15 downto  0 )
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
        reset : in std_logic ;
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
        data1_data2 : Register_file port map (reset, wb_data,instruction(24 downto 22),
                                               instruction(20 downto 18),clk,
                                               Register_write,WB_address,data1_output,data2_output);
        controller_signal  : controller    port map (reset,instruction(31 downto 26),signals_output ); 


        data1<=data1_output; 
        data2<=data2_output;
        signals<=signals_output; 


        out_pc <=pc;              
        out_offset <= instruction(15 downto 0);
        out_destinationaddress1 <= instruction(3 downto 0);
        out_destinationaddress2 <= instruction(19 downto 16);
        out_in_port <= in_port;

	
end decoding_stage_imp;





