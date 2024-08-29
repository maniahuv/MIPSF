###################################################################################
# $s0 = loop counter    # biến đếm vòng lặp
# $s1 = M   		# số bị nhân (multiplicand)
# $s2 = Q  		# số nhân (multiplier)
# $s3 = A   		# dùng để lưu kết quả khi thực hiện chương trình
# $s4 = Q-1   		# giá trị thấp nhất của Q
# $s5 = Q0 		# giá trị thấp nhất trước đó của Q
###################################################################################

.data
str_enter_multiplicand:	.asciiz "\nNhap so bi nhan: "  	# Chuỗi yêu cầu nhập số bị nhân
str_enter_multiplier:	.asciiz "\nNhap so nhan: "  	# Chuỗi yêu cầu nhập số nhân
str_print_00_info:	.asciiz "00, nop shift"  	# Chuỗi thông báo cho trường hợp 00
str_print_01_info:	.asciiz "01, add shift"  	# Chuỗi thông báo cho trường hợp 01
str_print_10_info:	.asciiz "10, subtract shift"  	# Chuỗi thông báo cho trường hợp 10
str_print_11_info:	.asciiz "11, nop shift"  	# Chuỗi thông báo cho trường hợp 11
str_print_result:	.asciiz "\n\nResult: "  	# Chuỗi hiển thị kết quả cuối cùng
str_loop_counter:	.asciiz "\nStep="  		# Chuỗi hiển thị bước lặp hiện tại
str_tab:		.asciiz "\t"  			# Chuỗi khoảng trắng
str_A_ex:		.asciiz "A_extended="  		# Chuỗi hiển thị giá trị của A (mở rộng)
str_A:			.asciiz "A="  			# Chuỗi hiển thị giá trị của A (A lưu kết quả thừa sau khi dịch bit)
str_Q0:			.asciiz "Q0="  			# Chuỗi hiển thị giá trị của Q0
str_Q_1:		.asciiz "Q-1="  		# Chuỗi hiển thị giá trị của Q-1

sys_print_int:		.word 1  	# Hệ thống gọi in số nguyên
sys_print_binary:	.word 35  	# Hệ thống gọi in số nhị phân
sys_print_string:	.word 4  	# Hệ thống gọi in chuỗi
sys_read_int:		.word 5  	# Hệ thống gọi đọc số nguyên
sys_exit:		.word 10  	# Hệ thống gọi thoát

.text

main:
	addi $s0, $zero, 0  			# Khởi tạo biến đếm vòng lặp
	addi $s3, $zero, 0  			# Khởi tạo giá trị A
	addi $s4, $zero, 0  			# Khởi tạo giá trị Q-1
	addi $s5, $zero, 0  			# Khởi tạo giá trị Q0
	

	lw   $v0, sys_print_string
	la   $a0, str_enter_multiplier
	syscall  				# Yêu cầu nhập số nhân

	lw   $v0, sys_read_int
	syscall  				# Đọc số nhân từ người dùng
	add  $s1, $zero, $v0  			# Lưu số nhân vào $s1

	lw   $v0, sys_print_string
	la   $a0, str_enter_multiplicand
	syscall  				# Yêu cầu nhập số bị nhân
	
	lw   $v0, sys_read_int
	syscall  				# Đọc số bị nhân từ người dùng
	add  $s2, $zero, $v0  			# Lưu số bị nhân vào $s2
	
	add $s4, $0, $s1
print_step:
	beq  $s0, 33, exit  			# Kiểm tra nếu đã thực hiện 33 bước thì thoát

	lw   $v0, sys_print_string
	la   $a0, str_loop_counter
	syscall  				# Hiển thị bước lặp hiện tại

	lw   $v0, sys_print_int
	add  $a0, $zero, $s0
	syscall  				# In giá trị biến đếm vòng lặp
	
	lw   $v0, sys_print_string
	la   $a0, str_tab
	syscall  				# In ký tự khoảng trắng

	lw   $v0, sys_print_string
	la   $a0, str_A_ex
	syscall  				# Hiển thị giá trị của A (mở rộng)

	lw   $v0, sys_print_binary
	add  $a0, $zero, $s3
	syscall  				# In giá trị của Aextend ở dạng nhị phân

	lw   $v0, sys_print_string
	la   $a0, str_tab
	syscall  				# In ký tự khoảng trắng

	lw   $v0, sys_print_string
	la   $a0, str_A
	syscall  				# Hiển thị giá trị của A

	lw   $v0, sys_print_binary
	add  $a0, $zero, $s4
	syscall  				# In giá trị của A ở dạng nhị phân

	lw   $v0, sys_print_string
	la   $a0, str_tab
	syscall  				# In ký tự khoảng trắng

	lw   $v0, sys_print_string
	la   $a0, str_Q0
	syscall  				# Hiển thị giá trị của Q0

	lw   $v0, sys_print_binary
	add  $a0, $zero, $s1
	syscall  				# In giá trị của Q0 ở dạng nhị phân

	lw   $v0, sys_print_string
	la   $a0, str_tab
	syscall  				# In ký tự khoảng trắng

	lw   $v0, sys_print_string
	la   $a0, str_Q_1
	syscall  				# Hiển thị giá trị của Q-1

	lw   $v0, sys_print_int
	add  $a0, $zero, $s5
	syscall  				# In giá trị của Q-1

	lw   $v0, sys_print_string
	la   $a0, str_tab
	syscall  				# In ký tự khoảng trắng

#-----------------------------
	andi $t0, $s1, 1  			# Kiểm tra bit thấp nhất của Q
	beq  $t0, $zero, x_lsb_0  		# Nếu Q0 là 0, nhảy đến x_lsb_0
	j    x_lsb_1  				# Nếu Q0 là 1, nhảy đến x_lsb_1

x_lsb_0:  
	beq  $s5, $zero, case_00  		# Nếu Q-1 là 0, nhảy đến case_00
	j    case_01  				# Nếu Q-1 là 1, nhảy đến case_01

x_lsb_1:
	beq  $s5, $zero, case_10  		# Nếu Q-1 là 0, nhảy đến case_10
	j    case_11 				# Nếu Q-1 là 1, nhảy đến case_11

case_00:
	lw   $v0, sys_print_string
	la   $a0, str_print_00_info
	syscall  				# In thông báo "00, nop shift"
	andi $t0, $s3, 1  			# Kiểm tra bit thấp nhất của A
	bne  $t0, $zero, V  			# Nếu A0 là 1, nhảy đến V
	srl  $s4, $s4, 1  			# Dịch phải Q
	j    shift  				# Nhảy đến bước dịch

case_01:
	lw   $v0, sys_print_string
	la   $a0, str_print_01_info
	syscall  				# In thông báo "01, add shift"
	add  $s3, $s3, $s2  			# Thực hiện phép cộng A + M
	andi $s5, $s5, 0  			# Đặt Q-1 bằng 0
	andi $t0, $s3, 1  			# Kiểm tra bit thấp nhất của A
	bne  $t0, $zero, V  			# Nếu A0 là 1, nhảy đến V
	srl  $s4, $s4, 1  			# Dịch phải Q
	j    shift  				# Nhảy đến bước dịch

case_10:
	lw   $v0, sys_print_string
	la   $a0, str_print_10_info
	syscall  				# In thông báo "10, subtract shift"
	sub  $s3, $s3, $s2  			# Thực hiện phép trừ A - M
	ori  $s5, $s5, 1  			# Đặt Q-1 bằng 1
	andi $t0, $s3, 1  			# Kiểm tra bit thấp nhất của A
	bne  $t0, $zero, V  			# Nếu A0 là 1, nhảy đến V
	srl  $s4, $s4, 1  			# Dịch phải Q
	j    shift  				# Nhảy đến bước dịch

case_11:
	lw   $v0, sys_print_string
	la   $a0, str_print_11_info
	syscall 				# In thông báo "11, nop shift"
	andi $t0, $s3, 1  			# Kiểm tra bit thấp nhất của A
	bne  $t0, $zero, V 			# Nếu A0 là 1, nhảy đến V
	srl  $s4, $s4, 1  			# Dịch phải Q
	j    shift  				# Nhảy đến bước dịch

V:
	andi $t0, $s4, 0x80000000  		# Kiểm tra bit cao nhất của Q
	bne  $t0, $zero, v_msb_1  		# Nếu bit cao nhất của Q là 1, nhảy đến v_msb_1
	srl  $s4, $s4, 1  			# Dịch phải Q
	ori  $s4, $s4, 0x80000000  		# Thiết lập bit cao nhất của Q
	j    shift  				# Nhảy đến bước dịch

v_msb_1:
	srl  $s4, $s4, 1  			# Dịch phải Q
	ori  $s4, $s4, 0x80000000  		# Thiết lập bit cao nhất của Q
	j    shift  				# Nhảy đến bước dịch

shift:
	sra  $s3, $s3, 1  			# Dịch phải số có dấu A
	ror  $s1, $s1, 1  			# Xoay phải Q
	addi $s0, $s0, 1  			# Tăng biến đếm vòng lặp
	beq  $s0, 32, save  			# Nếu đã thực hiện 32 bước, nhảy đến save
	j    print_step  			# Quay lại bước in thông tin

save:
	add  $t1, $zero, $s3  			# Lưu giá trị cuối cùng của A vào $t1
	add  $t2, $zero, $s4  			# Lưu giá trị cuối cùng của Q vào $t2
	j    print_step  			# Quay lại bước in thông tin

exit:
	lw   $v0, sys_print_string
	la   $a0, str_print_result
	syscall  				# In chuỗi kết quả

	lw   $v0, sys_print_binary
	add  $a0, $zero, $t1
	syscall  				# In giá trị cuối cùng của A ở dạng nhị phân

	lw   $v0, sys_print_binary
	add  $a0, $zero, $t2
	syscall  				# In giá trị cuối cùng của Q ở dạng nhị phân

	lw   $v0, sys_exit
	syscall  				# Thoát chương trình
