library IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

Entity Alu is
    port(
        source1,source2 : in std_logic_vector(15 downto 0); -- alu two sources
        alu_control     : in std_logic_vector(4 downto 0); -- to control what should the alu do
        flag_register_data_read : in std_logic_vector(5 downto 0); -- always read the flag register content (need to know the flags for the jump instructions or in the case i want to restore the flags)
        flag_register_control   : out std_logic ; -- to know in the register which part i will write in (the first three bits or the last three bits)
        flag_register_enable    : out std_logic ; -- enable for the flag register 
        flag_register_data_write: out std_logic_vector(2 downto 0); -- this when i want to change the flags
        result          : out std_logic_vector(15 downto 0); -- the output of the alu
        stack_address   : out std_logic --this bit is high if there is an instruction needs the stackpointer

    );
end entity Alu;
-- F<=  A(14 downto 0) & '0'   when S0='0' and S1='0'
-- else A(14 downto 0) & A(15) when S0='1' and S1='0'
-- else A(14 downto 0) & Cin   when S0='0' and S1='1'
-- else x"0000"                when S0='1' and S1='1'
-- else A;


Architecture arch_Alu of Alu is 
    SIGNAL temp_result   : STD_LOGIC_VECTOR(16 DOWNTO 0); -- to be able to get the carry so i add one bit in all the operations
    SIGNAL Src1BiggerThanSrc2 : STD_LOGIC; -- for subtraction to know if i will add borrow
begin
-------------------------the result of the alu--------------------------------------------------
Src1BiggerThanSrc2 <= '1' when (source1 >= source2) else '0';


temp_result <= (OTHERS => '0')         when alu_control = "00000" -- 0-for (hlt) and (nop)
else      (OTHERS => '0')              when alu_control = "00001" -- 1-for (setc) we will change the carry flag later
else    ('0' & not source1 )           when alu_control = "00010" -- 2-for the (not) inst change the flags later        
else    ('0' & source1 + 1 )           when alu_control = "00011" -- 3- for (inc) changes the flags later
else    ('0' & source1 )               when alu_control = "00100" -- 4- for (mov) and (out) instructions 
else    ('0' & source2 )               when alu_control = "00101" -- 5- for (in) and (LDM) inst
else    ('0' & source1 + source2)    when alu_control = "00110" -- 6- for the (add) and (addi) changes the flags later

else    ('0' & (source1 - source2))    when (alu_control = "00111" and Src1BiggerThanSrc2 ='1')  -- 7- for the (sub) changes the flags later 
else    ('1' & (source2 - source1))    when (alu_control = "00111" and Src1BiggerThanSrc2 ='0')  -- 7- sub with carry

else    ('0' & (source1 and source2))  when alu_control = "01000" -- 8- for (and) operation and changes the flags later 
else      (OTHERS => '0')              when alu_control = "01001" -- 9- for (push) and (pop) and (call) and (RET) and changes the stack address
else    ('0' & source1 + source2)    when alu_control = "01010" -- 10- for (ldd) and (std) doesn't change flags
else      (0=>flag_register_data_read(0), Others => '0')    when alu_control = "01011" -- 11- for (jz)  set the first bit with the zero flag 
else      (0=>flag_register_data_read(1), Others => '0')    when alu_control = "01100" -- 12- for (jn)  set the first bit with the negative flag
else      (0=>flag_register_data_read(2), Others => '0')    when alu_control = "01101" -- 13- for (jc)  set the first bit with the carry flag
else      (0=>'1', Others => '0')                           when alu_control = "01110" -- 14- for (jmp) set the first bit with one 
else    ('0' & source2 + 7 )          when alu_control = "01111"  -- 15- for (int) and changes the stack address and reserve the flags
else      (OTHERS => '0')               when alu_control = "10000"  -- 16- for (rti) restore the flags and change the stack address
else      (OTHERS => '0');
    
--temo_result(16)== the carry bit
result <= temp_result(15 downto 0) ;    


 --------------------------the stack address (for the mux in memory stage)----------------------------------
stack_address <= '1' when alu_control = "01001" -- 9- for (push) and (pop) and (call) and (RET)       
else             '1' when alu_control = "01111" -- 15- for (int) 
else             '1' when alu_control = "10000" -- 16- for (rti)
else             '0';

----------------------------the enable for flag register---------------------------------------------------    
flag_register_enable <= '1' when alu_control = "00001"  -- 1-for (setc) we will change the carry flag 
else                    '1' when alu_control = "00010"  -- 2-for the (not) inst change the flags (zero and negative)
else                    '1' when alu_control = "00011"  -- 3- for (inc) changes the flags (zero and negative)
else                    '1' when alu_control = "00110"  -- 6- for the (add) and (addi) changes the flags (zero and negative and carry) 
else                    '1' when alu_control = "00111"  -- 7-for (sub) changes (zero and negative and carry)
else                    '1' when alu_control = "01000"  -- 8- for (and) operation and changes the flags (zero and negative)
else                    '1' when alu_control = "01111"  -- 15- for (int) and changes the stack address and reserve the flags (writes in the register)
else                    '1' when alu_control = "10000"  -- 16- for (rti) restore the flags and change the stack address (writes in the register )   
else                    '1' when alu_control = "01011"  -- 11- for (jz)  unset the zero flag 
else                    '1' when alu_control = "01100"  -- 12- for (jn)  unset the negative flag
else                    '1' when alu_control = "01101"  -- 13- for (jc)  unset the carry flag              
else                    '0' ;                             -- 15 and 16 will be special cases

-----------------------------to control which half in the register to write in-------------------------------------
-- (1) indicates to the first half normal changes in the flag (0) indicates to the second half to reserve the flags  

flag_register_control <= '1' when alu_control = "00001"  -- 1-for (setc) we will change the carry flag
else                     '1' when alu_control = "00010"  -- 2-for the (not) inst change the flags (zero and negative)   
else                     '1' when alu_control = "00011"  -- 3- for (inc) changes the flags (zero and negative)
else                     '1' when alu_control = "00110"  -- 6- for the (add) and (addi) changes the flags (zero and negative and carry)
else                     '1' when alu_control = "00111"  -- 7-for (sub) changes (zero and negative and carry)
else                     '1' when alu_control = "01000"  -- 8- for (and) operation and changes the flags (zero and negative)
else                     '0' when alu_control = "01111"  -- 15- for (int) and changes the stack address and reserve the flags (writes in the register)
else                     '1' when alu_control = "10000"  -- 16- for (rti) restore the flags and change the stack address (writes in the register )   
else                    '1' when alu_control = "01011"  -- 11- for (jz)  unset the zero flag 
else                    '1' when alu_control = "01100"  -- 12- for (jn)  unset the negative flag
else                    '1' when alu_control = "01101"  -- 13- for (jc)  unset the carry flag 
else                     '0' ; -- it doesn't matter here because the enable will be equal to zero


----------------------------write back the flags changes------------------------------------------------------    
---change carry flag--------------------------------------------last else equal to flag_register_data_read(3) 
flag_register_data_write(2) <= '1'        when alu_control = "00001"  -- 1-for (setc) we will change the carry flag
else               temp_result(16)        when alu_control = "00110"  -- 6- for the (add) and (addi) changes the flags (zero and negative and carry)               
else               temp_result(16)        when alu_control = "00111"  -- 7-for (sub) changes (zero and negative and carry)
else               temp_result(16)        when alu_control = "00011"  -- 3-for (inc) changes (zero and negative and carry)
else    flag_register_data_read(5)        when alu_control = "10000"  -- 16- for (rti) restore the flags and change the stack address (writes in the register )          
else                           '0'        when alu_control = "01101"  -- 13- for (JC) reset(carry flag)         
else    flag_register_data_read(2) ; -- in any other case i return the carry i read 

---change negative flag--------------------------------------------last else equal to flag_register_data_read(1) 
flag_register_data_write(1) <=  temp_result(15)    when alu_control = "00010"  -- 2-for the (not) inst change the flags (zero and negative)
else                            temp_result(15)    when alu_control = "00011"  -- 3- for (inc) changes the flags (zero and negative)
else                            temp_result(15)    when alu_control = "00110"  -- 6- for the (add) and (addi) changes the flags (zero and negative and carry)
else                            temp_result(15)    when alu_control = "00111"  -- 7-for (sub) changes (zero and negative and carry)
else                            '1'                when (alu_control = "00111" and  Src1BiggerThanSrc2 ='0')   -- 7-for (sub) changes (zero and negative and carry)    
else                            temp_result(15)    when alu_control = "01000"  -- 8- for (and) operation and changes the flags (zero and negative)
else                 flag_register_data_read(4)    when alu_control = "10000"  -- 16- for (rti) restore the flags and change the stack address (writes in the register )   
else                            '0'                when alu_control = "01100"  -- 12- for (JN) operation and changes the flags (negative)
else                            flag_register_data_read(1) ;

---change zero flag--------------------------------------------last else equal to flag_register_data_read(0)
flag_register_data_write(0) <= '1'   when ( (alu_control = "00010") and unsigned(temp_result(15 DOWNTO 0)) =0 ) -- 2-for the (not) inst change the flags (zero and negative) 
else                           '1'   when ( (alu_control = "00011") and unsigned(temp_result(15 DOWNTO 0)) =0 ) -- 3- for (inc) changes the flags (zero and negative)
else                           '1'   when ( (alu_control = "00110") and unsigned(temp_result(15 DOWNTO 0)) =0 ) -- 6- for the (add) and (addi) changes the flags (zero and negative and carry)
else                           '1'   when ( (alu_control = "00111") and unsigned(temp_result(15 DOWNTO 0)) =0 ) -- 7-for (sub) changes (zero and negative and carry)
else                           '1'   when ( (alu_control = "01000") and unsigned(temp_result(15 DOWNTO 0)) =0 ) -- 8- for (and) operation and changes the flags (zero and negative)
else                           '0'   when ( (alu_control = "00010") and unsigned(temp_result(15 DOWNTO 0)) /=0 ) -- 2-for the (not) inst change the flags (zero and negative)
else                           '0'   when ( (alu_control = "00011") and unsigned(temp_result(15 DOWNTO 0)) /=0 ) -- 3- for (inc) changes the flags (zero and negative)    
else                           '0'   when ( (alu_control = "00110") and unsigned(temp_result(15 DOWNTO 0)) /=0 ) -- 6- for the (add) and (addi) changes the flags (zero and negative and carry)  
else                           '0'   when ( (alu_control = "00111") and unsigned(temp_result(15 DOWNTO 0)) /=0 ) -- 7-for (sub) changes (zero and negative and carry)
else                           '0'   when ( (alu_control = "01000") and unsigned(temp_result(15 DOWNTO 0)) /=0 ) -- 8- for (and) operation and changes the flags (zero and negative)
else                           '0'   when alu_control = "01011"                                                  -- 11- for (JZ) operation and changes the flags (zero)
else              flag_register_data_read(3)    when alu_control = "10000"  -- 16- for (rti) restore the flags and change the stack address (writes in the register )   
else                           flag_register_data_read(0);     





end arch_Alu ;