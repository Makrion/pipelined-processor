vsim -gui work.integration
# vsim -gui work.integration 
# Start time: 17:51:58 on Jan 06,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.integration(integration)
# Loading work.memorystage(archmemorystage)
# Loading work.datamemory(archdatamemory)
# Loading work.addstackpointer(archaddstackpointer)
# Loading work.substackpointer(archsubstackpointer)
# Loading work.stackpointer(archstackpointer)
# Loading work.stagebuffer(arch_stagebuffer)
# Loading work.writebackstage(archwritebackstage)
add wave -position end  sim:/integration/clk
add wave -position end  sim:/integration/map_StageBuffer/d
add wave -position end  sim:/integration/map_StageBuffer/q
mem load -filltype value -filldata 1234 -fillradix hexadecimal /integration/map_MemoryStage/map_datamemory/ram(10)
add wave -position end  sim:/integration/map_MemoryStage/mem_read
add wave -position end  sim:/integration/map_MemoryStage/result
add wave -position end  sim:/integration/map_MemoryStage/stack_add
add wave -position end  sim:/integration/map_MemoryStage/write_Back_selector
add wave -position 0  sim:/integration/clk
add wave -position 1  sim:/integration/mem_read
add wave -position end  sim:/integration/out_wb_data
add wave -position 2  sim:/integration/write_Back_selector
add wave -position 3  sim:/integration/result
add wave -position 3  sim:/integration/stack_add
force -freeze sim:/integration/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/integration/mem_read 1 0
force -freeze sim:/integration/write_Back_selector 0 0
force -freeze sim:/integration/stack_add 0 0
force -freeze sim:/integration/result x\"000a\" 0
run
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /integration/map_MemoryStage/map_datamemory
force -freeze sim:/integration/mem_read 0 0
run
run
mem load -filltype value -filldata 1205 -fillradix hexadecimal /integration/map_MemoryStage/map_datamemory/ram(9)
run
force -freeze sim:/integration/mem_read 1 0
force -freeze sim:/integration/result x\"0009\" 0
run
run

