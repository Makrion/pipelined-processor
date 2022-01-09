library ieee ; 
use ieee.std_logic_1164.all ; 


entity forwarding_unit is 

port(
    source1,source2  : in std_logic_vector(2 downto 0 );  -- source1 and source2 for the instruciton in the decoding stage .
    register_write_mem , register_write_wb : in std_logic ; 
    wb_address_mem , wb_address_wb : in std_logic_vector(2 downto 0 ); 
    data1_selector , data2_selector : out std_logic_vector( 1 downto 0 )

);---data that is red from the registers 


end forwarding_unit ; 



architecture forwarding_unit_imp of forwarding_unit is 

begin 
    process( source1 , source2 , register_write_mem ,register_write_wb , wb_address_mem , wb_address_wb )
    begin

        -- here there is a problem  consider this situation .

        --- add r1 , r5  , r4 ;
        --- add r5 , r6  , r4 ;
        --- add r4 , r5  , r6 ; 

        --- you must look for the mem firstly then look at wb 
        --- if it is in the memo take it from the mem and don't look at wb 
        if (source1 = wb_address_mem and register_write_mem='1') then 
            data1_selector<="10"; 
        elsif (source1 = wb_address_wb and register_write_wb='1') then 
            data1_selector<="01";
        else
            data1_selector<="00";  
        end if ;



        if (source2 = wb_address_mem and register_write_mem='1') then 
            data2_selector<="10"; 
        elsif (source2 = wb_address_wb and register_write_wb='1') then 
            data2_selector<="01";
        else
            data2_selector<="00";  
        end if ;


    end process; 


end forwarding_unit_imp; 
