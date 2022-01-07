library ieee ; 
use ieee.std_logic_1164.all ; 


entity hazard_detection_unit is 
port(
    source1,source2  : in std_logic_vector(2 downto 0 );  -- source1 and source2 for the instruciton in the decoding stage .
    load_address     : in std_logic_vector(2 downto 0 );
    mem_read         : in std_logic ; 
    control_signals_selector : out std_logic;
    stop_fetch_flag          : out std_logic 

);


end hazard_detection_unit ; 



architecture hazard_detection_unit_imp of hazard_detection_unit is 
begin 

    process (source1,source2,load_address,mem_read)   
    begin 
        if(mem_read='1') then 
            if(source1= load_address or source2= load_address) then
                control_signals_selector<='1'; 
                stop_fetch_flag<='1'; 
            else 
                control_signals_selector<='0'; 
                stop_fetch_flag<='0'; 
            end if ; 
        else 
            control_signals_selector<='0'; 
            stop_fetch_flag<='0'; 


        end if;   
    end process ; 



end hazard_detection_unit_imp; 