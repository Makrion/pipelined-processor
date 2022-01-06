vsim -gui work.register_file
# vsim -gui work.register_file 
# Start time: 16:14:42 on Jan 03,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.register_file(register_file_imp)
# Loading work.decoder(decoder_imp)
# Loading work.dff(dff_imp)
# Loading work.tsb(tsb_imp)
add wave -position end  sim:/register_file/clk
add wave -position end  sim:/register_file/data2_decoder
add wave -position end  sim:/register_file/data2_add
add wave -position end  sim:/register_file/data2
add wave -position end  sim:/register_file/data1_decoder
add wave -position end  sim:/register_file/data1_add
add wave -position end  sim:/register_file/data1
add wave -position end  sim:/register_file/WB_decoder
add wave -position end  sim:/register_file/WB_data
add wave -position end  sim:/register_file/WB_address
add wave -position end  sim:/register_file/Register_write
force -freeze sim:/register_file/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/register_file/Register_write 1 0
force -freeze sim:/register_file/WB_address x\"001\" 0
force -freeze sim:/register_file/WB_data x\"ffff\" 0
run
run
run
add wave -position end  sim:/register_file/DF1
run
force -freeze sim:/register_file/WB_address 000 0
force -freeze sim:/register_file/Register_write 0 0
run
force -freeze sim:/register_file/data1_add 001 0
run
force -freeze sim:/register_file/Register_write 1 0
force -freeze sim:/register_file/WB_address 000 0
force -freeze sim:/register_file/WB_data x\"ff\" 0
run
force -freeze sim:/register_file/Register_write 0 0
force -freeze sim:/register_file/data2_add 000 0
run
run
run
add wave -position end  sim:/register_file/DF1
force -freeze sim:/register_file/Register_write 1 0
force -freeze sim:/register_file/WB_address 001 0
force -freeze sim:/register_file/WB_data x\"ff\" 0
force -freeze sim:/register_file/WB_data x\"df\" 0
run
run


force -freeze sim:/register_file/Register_write 1 0
force -freeze sim:/register_file/WB_address 111 0
force -freeze sim:/register_file/WB_data x\"AAAA\" 0
run
force -freeze sim:/register_file/Register_write 0 0
force -freeze sim:/register_file/data1_add 111 0
force -freeze sim:/register_file/data2_add 111 0
run

