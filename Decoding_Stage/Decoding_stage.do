vsim -gui work.decoding_stage
# vsim -gui work.decoding_stage 
# Start time: 17:03:13 on Jan 06,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.decoding_stage(decoding_stage_imp)
# Loading work.register_file(register_file_imp)
# Loading work.decoder(decoder_imp)
# Loading work.dff(dff_imp)
# Loading work.tsb(tsb_imp)
# Loading work.controller(controller_imp)
# WARNING: No extended dataflow license exists
add wave -position end  sim:/decoding_stage/wb_data
add wave -position end  sim:/decoding_stage/signals
add wave -position end  sim:/decoding_stage/instruction
add wave -position end  sim:/decoding_stage/data2
add wave -position end  sim:/decoding_stage/data1
add wave -position end  sim:/decoding_stage/clk
add wave -position end  sim:/decoding_stage/WB_address
add wave -position end  sim:/decoding_stage/Register_write
force -freeze sim:/decoding_stage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/decoding_stage/WB_address 001 0
force -freeze sim:/decoding_stage/Register_write 1 0
force -freeze sim:/decoding_stage/wb_data x\"ffff\" 0
force -freeze sim:/decoding_stage/instruction x\"00000000\" 0
run
run
force -freeze sim:/decoding_stage/WB_address 000 0
run
force -freeze sim:/decoding_stage/instruction 00010000000001000000000000000000 0
run
force -freeze sim:/decoding_stage/wb_data x\"dddd\" 0
run
force -freeze sim:/decoding_stage/WB_address 011 0
force -freeze sim:/decoding_stage/instruction 00010000000011000000000000000000 0
run
run