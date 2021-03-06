vsim work.integration

#read mem
mem load -i {D:/programing/faculty of engineering/4_third year in cmp/first term/computer architecture/project/pipelined-processor/Assembler/instruction.mem} /integration/map_FetchStage/map_InstMem/ram
mem load -i {D:/programing/faculty of engineering/4_third year in cmp/first term/computer architecture/project/pipelined-processor/Assembler/data.mem} /integration/map_MemoryStage/map_datamemory/ram

#add

add wave -position insertpoint  \
sim:/integration/clk
add wave -position insertpoint  \
sim:/integration/reset
add wave -position insertpoint  \
sim:/integration/map_FetchStage/pc
add wave -position insertpoint  \
sim:/integration/map_FetchStage/pc
add wave -position insertpoint  \
sim:/integration/map_FetchStage/out_instruction
add wave -position insertpoint  \
sim:/integration/map_Decodingstage/signals_output
add wave -position insertpoint  \
sim:/integration/map_Decodingstage/wb_data
add wave -position insertpoint  \
sim:/integration/map_Decodingstage/WB_address
add wave -position insertpoint  \
sim:/integration/map_Decodingstage/Register_write
add wave -position insertpoint  \
sim:/integration/map_ExecuteStage/result
add wave -position insertpoint  \
sim:/integration/map_ExecuteStage/out_output_signal
add wave -position insertpoint  \
sim:/integration/map_MemoryStage/out_output_signal
add wave -position insertpoint  \
sim:/integration/map_MemoryStage/result
add wave -position insertpoint  \
sim:/integration/map_MemoryStage/out_result
add wave -position insertpoint  \
sim:/integration/map_MemoryStage/out_wb_address
add wave -position insertpoint  \
sim:/integration/map_MemoryStage/write_Back_selector
add wave -position insertpoint  \
sim:/integration/map_WriteBackStage/out_wb_data
add wave -position insertpoint  \
sim:/integration/map_WriteBackStage/out_out_port
add wave -position insertpoint  \
sim:/integration/map_WriteBackStage/out_register_write
add wave -position insertpoint  \
sim:/integration/map_WriteBackStage/out_wb_address
add wave -position insertpoint  \
sim:/integration/in_port
add wave -position end  sim:/integration/map_ExecuteStage/map_flagReg/q
run
add wave -position insertpoint  \
sim:/integration/map_Decodingstage/data1_data2/DF0 \
sim:/integration/map_Decodingstage/data1_data2/DF1 \
sim:/integration/map_Decodingstage/data1_data2/DF2 \
sim:/integration/map_Decodingstage/data1_data2/DF3 \
sim:/integration/map_Decodingstage/data1_data2/DF4 \
sim:/integration/map_Decodingstage/data1_data2/DF5 \
sim:/integration/map_Decodingstage/data1_data2/DF6 \
sim:/integration/map_Decodingstage/data1_data2/DF7

force -freeze sim:/integration/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/integration/reset 1 0

run
force -freeze sim:/integration/reset 0 0

run
run
run
run
run

force -freeze sim:/integration/in_port x\"5\" 0
run
force -freeze sim:/integration/in_port x\"10\" 0
