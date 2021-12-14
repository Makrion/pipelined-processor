library ieee ; 
use ieee.std_logic_1164.all ; 
Entity DFF is 
Generic (n : integer :=16); 

port(clk , rst ,E: in std_logic ; 
	 d         : in std_logic_vector (n-1 downto 0); 
	 q         : out std_logic_vector(n-1 downto 0)); 
	 
end DFF ; 



Architecture DFF_imp of DFF is 
 
begin 
	process(clk ,rst)
	begin
		if rst='1' then 
			q<= (others =>'0'); 
		elsif rising_edge(clk) and E='1' then 
			q<=d ; 
		end if ; 
	end process;
	
end DFF_imp;

