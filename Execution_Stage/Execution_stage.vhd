Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

Entity ExecutionStage is
    port(
--general porpuse signal (2 in) (zero out)---------------------------------------
		clk , reset : in std_logic;

--Signals that just passes to next stage (13 in) (13 out)--------------------------
       return_flag , call_flag , register_write , write_Back_selector , mem_write , mem_read , output_signal : in std_logic;
       return_int_rti_flush , call_flush        : in std_logic;
       push_flag , pop_flag ,int_flag ,rti_flag : in std_logic; --wasn't drawn explicitly in the diagram but the memory needs them

       --- the out of these signals 
       out_return_flag , out_call_flag ,out_register_write , out_write_Back_selector , out_mem_write , out_mem_read , out_output_signal : out std_logic;
       out_return_int_rti_flush , out_call_flush                 : out std_logic;
       out_push_flag , out_pop_flag , out_int_flag ,out_rti_flag : out std_logic;



--Signals important for the exxecution stage  ---------------------------------
       wb_destination_selector , branch_flag , mem_data_write: in std_logic;
       alu_control  : in std_logic_vector(4 downto 0);   
       alu_src      : in std_logic_vector(1 downto 0);
     
---inputs -------------------------------------------       
       pc : in std_logic_vector (31 downto 0);     -- just pass the pc
       data1 : in std_logic_vector (15 downto 0);  --source1
       data2 : in std_logic_vector (15 downto 0);  --goes into a mux that decide which is source2
       in_port : in std_logic_vector (15 downto 0); ---goes into a mux that decide which is source2
       offset  : in std_logic_vector (15 downto 0); --goes into a mux that decide which is source2 {from [0,15]}
       destinationaddress1 : in std_logic_vector (3 downto 0); --bits form [0,3] to decide the destination with a mux
       destinationaddress2 : in std_logic_vector (3 downto 0); --bits from [16,19] to decide the destination with a mux goes also to source2  x"000" & arg

--outputs--------------------------------------------
      out_pc : out std_logic_vector (31 downto 0); -- passing the pc
      branch_call_pc : out  std_logic_vector (31 downto 0); --is taken from data1
      wb_address     : out  std_logic_vector (3 downto 0); --either destinationadd1 or destinationadd2 
      stack_address  : out  std_logic;
      pc_selector_branch_ornot : out  std_logic;--out of an and gate 
      result      : out std_logic_vector (15 downto 0); --output of the alu
      write_data  : out std_logic_vector (15 downto 0) --the data passed to the memory either src1 or src2
    );
    end ExecutionStage;

    -------------------------------------------------------------------------------------------
    architecture arch_ExecutionStage of ExecutionStage is
    ---signals inside the block
    signal source2 : std_logic_vector (15 downto 0);--output of the mux
    signal flag_register_data_read  : std_logic_vector (5 downto 0) ; --connect alu with reg  
    signal flag_register_data_write : std_logic_vector (2 downto 0) ; --connect alu with reg 
    signal flag_register_enable     : std_logic ; --enable of flag reg from alu
    signal flag_register_control    : std_logic ; --control of flag reg from alu
    signal temp_result : std_logic_vector (15 downto 0); --for the logical and


    begin
    --- signals that just passing by------------------------------------------------
    out_return_flag          <= return_flag; 
    out_call_flag            <= call_flag ;
    out_register_write       <= register_write;
    out_write_Back_selector  <= write_Back_selector;
    out_mem_write            <= mem_write;
    out_mem_read             <= mem_read;
    out_output_signal        <= output_signal;
    out_return_int_rti_flush <= return_int_rti_flush;
    out_call_flush           <= call_flush;
    out_push_flag            <= push_flag;
    out_pop_flag             <= pop_flag;
    out_int_flag             <= int_flag;
    out_rti_flag             <= rti_flag;
    out_pc                   <= pc ;
    branch_call_pc           <= x"0000" & data1;

    --mux for source2----------------------------------------------------------------
    source2 <= data2  when alu_src ="00"
    else       offset when alu_src ="01"
    else      in_port when alu_src ="10"
    else      x"000" & destinationaddress2 when alu_src="11"
    else      (OTHERS => '0');

    --mux for write back destination--------------------------------------------------              
    wb_address <= destinationaddress1 when wb_destination_selector ='0'
    else          destinationaddress2 when wb_destination_selector ='1'
    else       (OTHERS => '0');  

    --mux for mem data write----------------------------------------------------------    
    write_data <= data1 when mem_data_write = '0'
    else          data2 when mem_data_write = '1'
    else          (OTHERS => '0'); 
       
    ---the logical and for branching---------------------------------------------------
    result <= temp_result;
    pc_selector_branch_ornot <=  temp_result(0) and branch_flag ; 
    
    ----alu port map---------------------------
    
   map_alu : entity work.Alu port map (
    source1                       => data1,
    source2                       => source2,
    alu_control                   => alu_control,
    flag_register_data_read       => flag_register_data_read,    
    flag_register_control         => flag_register_control,     
    flag_register_enable          => flag_register_enable,       
    flag_register_data_write      => flag_register_data_write,   
    result                        => temp_result,
    stack_address                 => stack_address 
   );

   map_flagReg : entity work.DFF port map (
    clk                 => clk,
    flag_register_reset => reset,
    enable              => flag_register_enable,         
    control             => flag_register_control,                      
    d                   => flag_register_data_write,             
    q                   => flag_register_data_read                
   );

    end arch_ExecutionStage;
