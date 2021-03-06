library ieee ; 
use ieee.std_logic_1164.all ; 

-- enable is the Flag_reg_enable from alu 
-- control is the flag_reg_control from alu
-- d is the flag reg data write  (three bits)
-- q is the flag reg data read  (six bits)
Entity DFF is 
port( clk , flag_register_reset ,  enable , control: in std_logic ; 
	 d         : in std_logic_vector (2 downto 0); 
	 q         : out std_logic_vector(5 downto 0)); 
	 
end DFF ; 



Architecture DFF_imp of DFF is 
 
begin 
	process(clk ,flag_register_reset) 
	begin
		if flag_register_reset='1' then 
			q<= (others =>'0'); 
		elsif ( rising_edge(clk) and enable='1' and control='1' ) then -- here if i want to store the flags normally
			q(2 downto 0)<= d(2 downto 0) ; 
         elsif ( rising_edge(clk) and enable='1' and control='0' ) then -- here if i want to reserve the flags
            q(5 downto 3)<= d(2 downto 0) ;    
		end if ; 
	end process;
	
end DFF_imp;

