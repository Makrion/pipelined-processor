import os 

def decimalToBinary(n):
    return bin(n).replace("0b", "")

cwd = os.getcwd()
print(cwd)
assembly = open(cwd+"\\Assembler\\code.asm", "r")
bin_code= open(cwd+"\\Assembler\\instruction.mem","w")
data_mem= open(cwd+"\\Assembler\\data.mem","w")

bin_code.write("// memory data file (do not edit the following line - required for mem load use)\n// instance=/mips/insrcMem/ram\n// format=mti addressradix=d dataradix=b version=1.0 wordsperline=1\n"
)
data_mem_count=0
data_mem_num=0
write_in_data_mem=False
num=0
for line in assembly:
  
  line=line.lower()
  table = line.maketrans(",()", "   ")
  line=line.translate(table)
  line=line.split()
  instrc=str(num)+": "

  if (len(line) == 0) or (str(line[0])[0] == '#'):
    continue
  
  elif line[0]=="nop":
    instrc+="000000"+"0000000000"

  elif line[0]=="hlt":
    instrc+="000001"+"0000000000"

  elif line[0]=="setc":
    instrc+="000010"+"0000000000"

  elif line[0]=="not":
    instrc+="000011"
    reg_num = decimalToBinary(int(line[1][1:]))
    if(len(reg_num) < 3):
      reg_num = ("0")*(3-len(reg_num))+reg_num
    dst = "0"+reg_num+"000"+reg_num
    instrc+=dst

  elif line[0]=="inc":
    instrc+="000100"
    reg_num = decimalToBinary(int(line[1][1:]))
    if(len(reg_num) < 3):
      reg_num = ("0")*(3-len(reg_num))+reg_num
    dst = "0"+reg_num+"000"+reg_num
    instrc+=dst

  elif line[0]=="out":
    instrc+="000101"
    reg_num = decimalToBinary(int(line[1][1:]))
    if(len(reg_num) < 3):
      reg_num = ("0")*(3-len(reg_num))+reg_num
    dst = "0"+reg_num+"000"+reg_num
    instrc+=dst

  elif line[0]=="in":
    instrc+="000110"
    reg_num = decimalToBinary(int(line[1][1:]))
    if(len(reg_num) < 3):
      reg_num = ("0")*(3-len(reg_num))+reg_num
    dst = "0"+reg_num+"000"+reg_num
    instrc+=dst

  elif line[0]=="mov":
    instrc+="100111"
   
    dst = decimalToBinary(int(line[1][1:]))
    if(len(dst) < 4):
      dst = "0"+("0")*(3-len(dst))+dst

    src_2 = "0000"

    src_1 = decimalToBinary(int(line[2][1:]))
    if(len(src_1) < 4):
      src_1 = "0"+("0")*(3-len(dst))+src_1

    instrc+=src_1+src_2+"00"
    bin_code.write(instrc+"\n")
    num+=1
    instrc=str(num)+": "+"000000000000"+dst

  elif line[0]=="add":
    instrc+="101000"
    
    dst = decimalToBinary(int(line[1][1:]))
    if(len(dst) < 4):
      dst = "0"+("0")*(3-len(dst))+dst

    src_1 = decimalToBinary(int(line[2][1:]))
    if(len(src_1) < 4):
      src_1 = "0"+("0")*(3-len(src_1))+src_1

    src_2 = decimalToBinary(int(line[3][1:]))
    if(len(src_2) < 4):
      src_2 = "0"+("0")*(3-len(src_2))+src_2

    instrc+=src_1+src_2+"00"
    bin_code.write(instrc+"\n")
    num+=1
    instrc=str(num)+": "+"000000000000"+dst
  
  elif line[0]=="sub":
    instrc+="101001"
    
    dst = decimalToBinary(int(line[1][1:]))
    if(len(dst) < 4):
      dst = "0"+("0")*(3-len(dst))+dst

    src_1 = decimalToBinary(int(line[2][1:]))
    if(len(src_1) < 4):
      src_1 = "0"+("0")*(3-len(src_1))+src_1

    src_2 = decimalToBinary(int(line[3][1:]))
    if(len(src_2) < 4):
      src_2 = "0"+("0")*(3-len(src_2))+src_2

    instrc+=src_1+src_2+"00"
    bin_code.write(instrc+"\n")
    num+=1
    instrc=str(num)+": "+"000000000000"+dst

  elif line[0]=="and":
    instrc+="101010"
    
    dst = decimalToBinary(int(line[1][1:]))
    if(len(dst) < 4):
      dst = "0"+("0")*(3-len(dst))+dst

    src_1 = decimalToBinary(int(line[2][1:]))
    if(len(src_1) < 4):
      src_1 = "0"+("0")*(3-len(src_1))+src_1

    src_2 = decimalToBinary(int(line[3][1:]))
    if(len(src_2) < 4):
      src_2 = "0"+("0")*(3-len(src_2))+src_2

    instrc+=src_1+src_2+"00"
    bin_code.write(instrc+"\n")
    num+=1
    instrc=str(num)+": "+"000000000000"+dst

  elif line[0]=="iadd":
    instrc+="101011"
    
    dst = decimalToBinary(int(line[1][1:]))
    if(len(dst) < 4):
      dst = "0"+("0")*(3-len(dst))+dst

    src_1 = decimalToBinary(int(line[2][1:]))
    if(len(src_1) < 4):
      src_1 = "0"+("0")*(3-len(src_1))+src_1

    immmediate = decimalToBinary(int(line[3],16))
    if(len(immmediate) < 16):
      immmediate = ("0")*(16-len(immmediate))+immmediate

    instrc+=src_1+"00"+dst
    bin_code.write(instrc+"\n")
    num+=1
    instrc=str(num)+": "+immmediate

  elif line[0]=="push":
    instrc+="000100"
    reg_num = decimalToBinary(int(line[1][1:]))
    if(len(reg_num) < 3):
      reg_num = ("0")*(3-len(reg_num))+reg_num
    dst = "0"+reg_num+"000"+reg_num
    instrc+=dst

  elif line[0]=="pop":
    instrc+="000100"
    reg_num = decimalToBinary(int(line[1][1:]))
    if(len(reg_num) < 3):
      reg_num = ("0")*(3-len(reg_num))+reg_num
    dst = "0"+reg_num+"000"+reg_num
    instrc+=dst

  elif line[0]=="ldm":
    instrc+="101110"
    
    dst = decimalToBinary(int(line[1][1:]))
    if(len(dst) < 4):
      dst = "0"+("0")*(3-len(dst))+dst

    src_1 ="0000"

    immmediate = decimalToBinary(int(line[2],16))
    if(len(immmediate) < 16):
      immmediate = ("0")*(16-len(immmediate))+immmediate

    instrc+=src_1+"00"+dst
    bin_code.write(instrc+"\n")
    num+=1
    instrc=str(num)+": "+immmediate

  elif line[0]=="ldd":
    instrc+="101111"

    dst = decimalToBinary(int(line[1][1:]))
    if(len(dst) < 4):
      dst = "0"+("0")*(3-len(dst))+dst

    src_1 = decimalToBinary(int(line[3][1:]))
    if(len(src_1) < 4):
      src_1 = "0"+("0")*(3-len(src_1))+src_1

    immmediate = decimalToBinary(int(line[2],16))
    if(len(immmediate) < 16):
      immmediate = ("0")*(16-len(immmediate))+immmediate

    instrc+=src_1+"00"+dst
    bin_code.write(instrc+"\n")
    num+=1
    instrc=str(num)+": "+immmediate

  
  elif line[0]=="std":
    instrc+="110000"

    src_2 = decimalToBinary(int(line[3][1:]))
    if(len(src_2) < 4):
      src_2 = "0"+("0")*(3-len(src_2))+src_2

    src_1 = decimalToBinary(int(line[1][1:]))
    if(len(src_1) < 4):
      src_1 = "0"+("0")*(3-len(src_1))+src_1

    immmediate = decimalToBinary(int(line[2],16))
    if(len(immmediate) < 16):
      immmediate = ("0")*(16-len(immmediate))+immmediate

    instrc+=src_1+src_2+"00"
    bin_code.write(instrc+"\n")
    num+=1
    instrc=str(num)+": "+immmediate

  elif line[0]=="jz":
    instrc+="010001"
    reg_num = decimalToBinary(int(line[1][1:]))
    if(len(reg_num) < 3):
      reg_num = ("0")*(3-len(reg_num))+reg_num
    dst = "0"+reg_num+"000"+reg_num
    instrc+=dst

  elif line[0]=="jn":
    instrc+="010010"
    reg_num = decimalToBinary(int(line[1][1:]))
    if(len(reg_num) < 3):
      reg_num = ("0")*(3-len(reg_num))+reg_num
    dst = "0"+reg_num+"000"+reg_num
    instrc+=dst

  elif line[0]=="jc":
    instrc+="010011"
    reg_num = decimalToBinary(int(line[1][1:]))
    if(len(reg_num) < 3):
      reg_num = ("0")*(3-len(reg_num))+reg_num
    dst = "0"+reg_num+"000"+reg_num
    instrc+=dst

  elif line[0]=="jmp":
    instrc+="010100"
    reg_num = decimalToBinary(int(line[1][1:]))
    if(len(reg_num) < 3):
      reg_num = ("0")*(3-len(reg_num))+reg_num
    dst = "0"+reg_num+"000"+reg_num
    instrc+=dst

  elif line[0]=="call":
    instrc+="010101"
    reg_num = decimalToBinary(int(line[1][1:]))
    if(len(reg_num) < 3):
      reg_num = ("0")*(3-len(reg_num))+reg_num
    dst = "0"+reg_num+"000"+reg_num
    instrc+=dst

  elif line[0]=="ret":
    instrc+="010110"+"0000000000"

  elif line[0]=="int":
    instrc+="010111"
    reg_num = decimalToBinary(int(line[1][1:]))
    if(len(reg_num) < 3):
      reg_num = ("0")*(3-len(reg_num))+reg_num
    dst = "0"+reg_num+"000"+reg_num
    instrc+=dst

  elif line[0]=="rti":
    instrc+="011000"+"0000000000"

  elif (line[0]==".org") or (write_in_data_mem):
    if(data_mem_count == 5):
      num=int(line[1],16)
      continue
    else:
      if(write_in_data_mem):
        addr=decimalToBinary(int(line[0],16))
        if(len(addr) < 32):
          addr=("0")*(32-len(addr))+addr
        instrc=str(data_mem_num)+": "+addr[0:16]
        data_mem.write(instrc+"\n")
        instrc=str(data_mem_num+1)+": "+addr[16:32]
        data_mem.write(instrc+"\n")
        write_in_data_mem=False
        data_mem_count+=1
        continue
      else:
        data_mem_num=int(line[1],16)
        write_in_data_mem=True
        continue

  else:
    instrc+="EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE"
  
  print(line)
  print(instrc)
  bin_code.write(instrc+"\n")
  print("num= "+str(num))
  num+=1


assembly.close
bin_code.close
data_mem.close
  

