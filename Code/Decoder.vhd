

library ieee ; 
use ieee.std_logic_1164.all ;


entity Decoder is 
port (
A,B,C ,E    : in std_logic ; 
output    : out std_logic_vector (7 downto 0) 
);
end Decoder;



Architecture Decoder_imp of Decoder is 
begin 

	process (A,B,C,E)
	begin 
		if E='0' then 
			output<=(others=>'0'); 
		elsif A='0' and B='0' and C='0' then 
			output<=(0=>'1' ,others=>'0');
		elsif A='1' and B='0' and C='0' then 
			output<=(1=>'1' ,others=>'0');
		elsif A='0' and B='1'  and C='0' then
			output<=(2=>'1' ,others=>'0');
		elsif A='1' and B='1' and C='0' then
			output<=(3=>'1' ,others=>'0');
        elsif A='0' and B='0' and C='1' then
            output<=(4=>'1' ,others=>'0');
        elsif A='1' and B='0' and C='1' then
            output<=(5=>'1' ,others=>'0');
        elsif A='0' and B='1' and C='1' then
            output<=(6=>'1' ,others=>'0');
        else
            output<=(7=>'1' ,others=>'0');
        
            
		
		end if ;
	
	end process ;



end Decoder_imp ;