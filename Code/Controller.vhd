
library ieee ; 
use ieee.std_logic_1164.all ; 
Entity controller is
port(clk , reset,prev_hlt_signal: in std_logic ; 
	 opcode         : in std_logic_vector (5 downto 0); 
	 signals        : out std_logic_vector(25 downto 0));
     -- number of bits of the signal vector will be updated 
	 -- after knowing the ALU control Signals 
	 -- hlt signal will come again to the controller to see if the 
	 -- previous state was a hlt or not 
	 --hlt signal : in std_logic
end controller ; 



Architecture controller_imp of controller is 
 
begin 
	process(clk ,reset,opcode,prev_hlt_signal)
	begin
		--if rst='1' then 
		--	q<= (others =>'0'); 
		--elsif rising_edge(clk) and E='1' then 
		--	q<=d ; 
		--end if ; 
		if reset='1' then 
			signals<="00000000000000000000000000";
		elsif prev_hlt_signal='1' then 
			signals<="10000000000000000000000000";
		elsif rising_edge(clk) then 
			if opcode="000000" then --NOP operation
				signals<="00000000000000000000000000";
			elsif opcode="000001" then --hlt Operation
				signals<="10000000000000000000000000";
			elsif opcode="000010" then -- Setc operation 
				signals<="00000000000000000000000001"; -- it is equal to the NOP but the difference in the ALU src
			elsif opcode="000011" then --Not operation 
				signals<="00000000100110000000000010";
            elsif opcode="000100" then --INC operation
				signals<="00000000100110000000000011";
			elsif opcode="000101" then --OUT operation
				signals<="00000001000000000000000100";
			elsif opcode="000110" then -- IN operation
				signals<="00001000100110000000000101";
			elsif opcode="000111" then --mov opeartion
				signals<="01000000000110000000000100";
			elsif opcode="001000" then --ADD opeartion
				signals<="01000000000110000000000110";
			elsif opcode="001001" then --SUB Operation	
				signals<="01000000000110000000000111";
			elsif opcode="001010" then --AND operation
				signals<="01000000000110000000001000";
			elsif opcode="001011" then --IADD operation 
				signals<="01000100100110000000000110";
			elsif opcode="001100" then --Push Operation
				signals<="00000000001000000100001001";
			elsif opcode="001101" then --pop operation
				signals<="00000000110010000010001001";
			elsif opcode="001110" then --LDM opeartion
				signals<="01000100100110000000000101";
			elsif opcode="001111" then --LDD opeartion
				signals<="01000100110010000000001010";
			elsif opcode="010000" then --STD opeartion
				signals<="01000100001000000001001010";
			elsif opcode="010001" then --JZ 
				signals<="00000010000000000000001011"; 
			elsif opcode="010010" then --JN
				signals<="00000010000000000000001100";
			elsif opcode="010011" then --JC 
				signals<="00000010000000000000001101";
			elsif opcode="010100" then --JMP 
				signals<="00000010000000000000001110";
			elsif opcode="010101" then --CALL 
				signals<="00100000001001000000101001";
			elsif opcode="010110" then --RET 
				signals<="00010000010000100000101001";
			elsif opcode="010111" then --INT 
				signals<="00011100011000010000101111";
			elsif opcode="011000" then --RTI 
				signals<="00010000010000001000110000";
			else 
				signals<="00000000000000000000000000";
			end if; 
			
		end if ;
	end process;
	
end controller_imp;
