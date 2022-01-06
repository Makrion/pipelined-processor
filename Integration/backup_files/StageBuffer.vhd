library ieee ; 
use ieee.std_logic_1164.all ; 
Entity StageBuffer is 
Generic (n : integer :=16); 

port(clk , flush ,en: in std_logic ; 
	 d         : in std_logic_vector (n-1 downto 0); 
	 q         : out std_logic_vector(n-1 downto 0)); 
	 
end StageBuffer ; 

Architecture StageBuffer of StageBuffer is 

begin 
	process(clk ,rst)
	begin
		if flush='1' then 
			q<= (others =>'0'); 
		elsif rising_edge(clk) and en='1' then 
			q<=d ; 
		end if ; 
	end process;
	
end StageBuffer;

