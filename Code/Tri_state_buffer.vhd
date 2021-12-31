
library ieee ; 
use ieee.std_logic_1164.all ; 


Entity TSB  is 
Generic (n : integer :=16); 
port (
A: in std_logic_vector(n-1 downto 0) ;
E: in std_logic ;  
q  : out std_logic_vector(n-1 downto 0)   
); 
end TSB ;


Architecture TSB_imp of TSB is 
begin 

q<= A when E='1'
else "ZZZZZZZZZZZZZZZZ"; 
end TSB_imp  ;
