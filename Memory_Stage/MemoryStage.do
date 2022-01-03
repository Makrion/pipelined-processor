vsim -gui work.memorystage
# vsim -gui work.memorystage 
# Start time: 10:44:03 on Dec 16,2021
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.memorystage(archmemorystage)
# Loading work.datamemory(archdatamemory)
# Loading work.addstackpointer(archaddstackpointer)
# Loading work.substackpointer(archsubstackpointer)
# Loading work.stackpointer(archstackpointer)
#---------------------------------------------------------general porpuse signal (2 in) (zero out)
add wave -position end  sim:/memorystage/clk
add wave -position end  sim:/memorystage/reset
add wave -position end  sim:/memorystage/map_stackpointer/q
#---------------------------------------------------------Signals that just passes to next stage (5 in) (5 out)
add wave -position end  sim:/memorystage/register_write
add wave -position end  sim:/memorystage/write_Back_selector
add wave -position end  sim:/memorystage/output_signal
add wave -position end  sim:/memorystage/return_int_rti_flush
add wave -position end  sim:/memorystage/wb_address
add wave -position end  sim:/memorystage/out_register_write
add wave -position end  sim:/memorystage/out_write_Back_selector
add wave -position end  sim:/memorystage/out_output_signal
add wave -position end  sim:/memorystage/out_return_int_rti_flush
add wave -position end  sim:/memorystage/out_wb_address
#---------------------------------------------------------Signals important for the mem stage (12 in) (6 out)
add wave -position end  sim:/memorystage/call_flag
add wave -position end  sim:/memorystage/return_flag
add wave -position end  sim:/memorystage/mem_write
add wave -position end  sim:/memorystage/mem_read
add wave -position end  sim:/memorystage/int_flag
add wave -position end  sim:/memorystage/rti_flag
add wave -position end  sim:/memorystage/pop_flag
add wave -position end  sim:/memorystage/push_flag
add wave -position end  sim:/memorystage/stack_add
add wave -position end  sim:/memorystage/pc
add wave -position end  sim:/memorystage/result
add wave -position end  sim:/memorystage/write_data
add wave -position end  sim:/memorystage/out_return_flag
add wave -position end  sim:/memorystage/out_int_flag
add wave -position end  sim:/memorystage/out_rti_flag
add wave -position end  sim:/memorystage/out_read_data
add wave -position end  sim:/memorystage/out_result
add wave -position end  sim:/memorystage/out_pc
#------------------------------------uncomment those for testing porpuses
#add wave -position end  sim:/memorystage/mux_to_mem_address
#add wave -position end  sim:/memorystage/or_to_en_datain_32
#add wave -position end  sim:/memorystage/or_to_en_dataout_32
#------------------------------------------------------------------------------------reseting
force -freeze sim:/memorystage/reset 1 0
run
force -freeze sim:/memorystage/reset 0 0
run
force -freeze sim:/memorystage/clk 1 0, 0 {50 ps} -r 100
#------------------------------------------------------------------------------------test instruction that's not using memory stage
force -freeze sim:/memorystage/register_write 1 0
force -freeze sim:/memorystage/write_Back_selector 0 0
force -freeze sim:/memorystage/output_signal 0 0
force -freeze sim:/memorystage/return_int_rti_flush 1 0
force -freeze sim:/memorystage/wb_address 0001 0
run
#------------------------------------------------------------------------------------test writing data to an address (ignoring the signals that doesn't affect the calculations)
force -freeze sim:/memorystage/call_flag 0 0
force -freeze sim:/memorystage/return_flag 0 0
force -freeze sim:/memorystage/mem_write 1 0
force -freeze sim:/memorystage/mem_read 0 0
force -freeze sim:/memorystage/int_flag 0 0
force -freeze sim:/memorystage/rti_flag 0 0
force -freeze sim:/memorystage/pop_flag 0 0
force -freeze sim:/memorystage/push_flag 0 0
force -freeze sim:/memorystage/stack_add 0 0
force -freeze sim:/memorystage/pc UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU 0
force -freeze sim:/memorystage/result x\"00fa\" 0
force -freeze sim:/memorystage/write_data x\"fafa\" 0
run
#------------------------------------------------------------------------------------test reading data from an address (ignoring the signals that doesn't affect the calculations)
force -freeze sim:/memorystage/call_flag 0 0
force -freeze sim:/memorystage/return_flag 0 0
force -freeze sim:/memorystage/mem_write 0 0
force -freeze sim:/memorystage/mem_read 1 0
force -freeze sim:/memorystage/int_flag 0 0
force -freeze sim:/memorystage/rti_flag 0 0
force -freeze sim:/memorystage/pop_flag 0 0
force -freeze sim:/memorystage/push_flag 0 0
force -freeze sim:/memorystage/stack_add 0 0
force -freeze sim:/memorystage/pc UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU 0
force -freeze sim:/memorystage/result x\"00fa\" 0
force -freeze sim:/memorystage/write_data  UUUUUUUUUUUUUUUU 0
run
#------------------------------------------------------------------------------------test push (ignoring the signals that doesn't affect the calculations)
force -freeze sim:/memorystage/call_flag 0 0
force -freeze sim:/memorystage/return_flag 0 0
force -freeze sim:/memorystage/mem_write 1 0
force -freeze sim:/memorystage/mem_read 0 0
force -freeze sim:/memorystage/int_flag 0 0
force -freeze sim:/memorystage/rti_flag 0 0
force -freeze sim:/memorystage/pop_flag 0 0
force -freeze sim:/memorystage/push_flag 1 0
force -freeze sim:/memorystage/stack_add 1 0
force -freeze sim:/memorystage/write_data x\"1234\" 0
run
#------------------------------------------------------------------------------------test call (ignoring the signals that doesn't affect the calculations)
force -freeze sim:/memorystage/call_flag 1 0
force -freeze sim:/memorystage/return_flag 0 0
force -freeze sim:/memorystage/mem_write 1 0
force -freeze sim:/memorystage/mem_read 0 0
force -freeze sim:/memorystage/int_flag 0 0
force -freeze sim:/memorystage/rti_flag 0 0
force -freeze sim:/memorystage/pop_flag 0 0
force -freeze sim:/memorystage/push_flag 0 0
force -freeze sim:/memorystage/stack_add 1 0
force -freeze sim:/memorystage/pc x\"0000F0FF\" 0
force -freeze sim:/memorystage/result  UUUUUUUUUUUUUUUU 0
force -freeze sim:/memorystage/write_data  UUUUUUUUUUUUUUUU 0
run
#------------------------------------------------------------------------------------test return (ignoring the signals that doesn't affect the calculations)
force -freeze sim:/memorystage/call_flag 0 0
force -freeze sim:/memorystage/return_flag 1 0
force -freeze sim:/memorystage/mem_write 0 0
force -freeze sim:/memorystage/mem_read 1 0
force -freeze sim:/memorystage/int_flag 0 0
force -freeze sim:/memorystage/rti_flag 0 0
force -freeze sim:/memorystage/pop_flag 0 0
force -freeze sim:/memorystage/push_flag 0 0
force -freeze sim:/memorystage/stack_add 1 0
force -freeze sim:/memorystage/pc UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU 0
force -freeze sim:/memorystage/result UUUUUUUUUUUUUUUU 0
force -freeze sim:/memorystage/write_data UUUUUUUUUUUUUUUU 0
run
#------------------------------------------------------------------------------------test pop (ignoring the signals that doesn't affect the calculations)
force -freeze sim:/memorystage/call_flag 0 0
force -freeze sim:/memorystage/return_flag 0 0
force -freeze sim:/memorystage/mem_write 0 0
force -freeze sim:/memorystage/mem_read 1 0
force -freeze sim:/memorystage/int_flag 0 0
force -freeze sim:/memorystage/rti_flag 0 0
force -freeze sim:/memorystage/pop_flag 1 0
force -freeze sim:/memorystage/push_flag 0 0
force -freeze sim:/memorystage/stack_add 1 0
force -freeze sim:/memorystage/pc UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU 0
force -freeze sim:/memorystage/result UUUUUUUUUUUUUUUU 0
force -freeze sim:/memorystage/write_data UUUUUUUUUUUUUUUU 0
run
#----------------------------------INT can only push the PC but, can't read the PC address for the INT [due to bad design decision :(]
#------------------------------------------------------------------------------------test INT (ignoring the signals that doesn't affect the calculations)
force -freeze sim:/memorystage/call_flag 0 0
force -freeze sim:/memorystage/return_flag 0 0
force -freeze sim:/memorystage/mem_write 1 0
force -freeze sim:/memorystage/mem_read 0 0
force -freeze sim:/memorystage/int_flag 1 0
force -freeze sim:/memorystage/rti_flag 0 0
force -freeze sim:/memorystage/pop_flag 0 0
force -freeze sim:/memorystage/push_flag 0 0
force -freeze sim:/memorystage/stack_add 1 0
force -freeze sim:/memorystage/pc x\"00005555\" 0
force -freeze sim:/memorystage/result x\"0007\" 0
force -freeze sim:/memorystage/write_data UUUUUUUUUUUUUUUU 0
run
#------------------------------------------------------------------------------------test RTI (ignoring the signals that doesn't affect the calculations)
force -freeze sim:/memorystage/call_flag 0 0
force -freeze sim:/memorystage/return_flag 0 0
force -freeze sim:/memorystage/mem_write 0 0
force -freeze sim:/memorystage/mem_read 1 0
force -freeze sim:/memorystage/int_flag 0 0
force -freeze sim:/memorystage/rti_flag 1 0
force -freeze sim:/memorystage/pop_flag 0 0
force -freeze sim:/memorystage/push_flag 0 0
force -freeze sim:/memorystage/stack_add 1 0
force -freeze sim:/memorystage/pc UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU 0
force -freeze sim:/memorystage/result UUUUUUUUUUUUUUUU 0
force -freeze sim:/memorystage/write_data UUUUUUUUUUUUUUUU 0
run
