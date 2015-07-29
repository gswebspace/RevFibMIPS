#################################################################################################################
#Reverse Fibonacci Number Generator
#Description: Calculates and displays as many as N Fibonacci numbers backward
#from a given Fibonacci number X
#################################################################################################################
			.data
comma:		.asciiz			" ,"
one:		.asciiz			" ,1"
prompt1:	.asciiz			"\n\nEnter a valid Fibonacci number:"
prompt2:	.asciiz			"\nEnter the number of Fibonacci numbers to be displayed:"
error1:		.asciiz			"\nNo more Fibonacci Number\n"
error2:		.asciiz			" is not a valid Fibonacci Number\n"
			.globl main		#Declaring the main symbol as global so that it can be referenced from other files
			.text			#Assembly code starts now	
#################################################################################################################
main:		
#INPUT X
			
			li	$v0,4		#System call for Print
			la	$a0,prompt1	#load address of prompt1 into $ao (Required by System Call)
			syscall			#execute the system call
			
			
			
			li $v0, 5 		# Read Integer syscall
			syscall 		# result in $v0
			move $t0,$v0	#get input in $t0
			
			
			
#INPUT N			
			
			li	$v0,4		#System call for Print
			la	$a0,prompt2	#load address of prompt2 into $ao (Required by System Call)
			syscall			#execute the system call
			
			
			
			li $v0, 5 		# Read Integer syscall
			syscall 		# result in $v0
			move $t1,$v0	#get input in $t0
			
			
			
			
			
			move $a0,$t0	#set X as first argument
			move $a1,$t1	#set N as second argument
			
			addiu $sp,$sp,-4	# Allocating Space in the Stack Memory
			sw	$ra,0($sp)		# Storing return address on Stack
			jal rf				# Calling the Reverse Fibonacci Function
			lw	$ra,0($sp)		# Restoring Return Address from Stack
			addiu $sp,$sp,4 	# De-allocate Space on the Stack
			
			li $t0,-1
			beq $v0,$t0,main	#Return Value == -1  , Retry
			
			
			b end				#Otherwise Main Program ends here
#################################################################################################################
#Function Name : rf
#Description : This function is the Entry point into the Reverse Fibonacci Algorithm, and displays 
#N numbers backwards from X
#Inputs : 
#$a0 = The last fibonacci number (X)
#$a1 = How many numbers to display in reverse (N)
#
#Returns :
# $v0 = -1 if X is not a fibonacci number
# $v0 = 0 Otherwise
#
#Example Calling Sequence:
#	addiu $sp,$sp,-4	
#	sw	$ra,0($sp)		
#	jal rf
#	move $t0,$v0				
#	lw	$ra,0($sp)		
#	addiu $sp,$sp,4
#
#Algorithmic Description in Pseudocode:
#	int rf(int X, int N)
#	{
#		int ret_val = rf_rec(1, 1, X, N);
#		if (ret_val > 1)
#		{
#			printline("1");         //there can only be '1' remaining at last , no more than that
#			printline("No more Fibonacci Number");
#			ret_val=0;
#		}
#		else if (ret_val == 1)
#		{
#			printline("1");         //there can only be '1' remaining at last , no more than that
#			ret_val=0;
#		}
#		if(ret_val == -1)
#		{
#			printline("\"" + X + "\" is not a valid Fibonacci Number");
#		}
#		return ret_val;
#	}
#################################################################################################################			
rf:
#Preparing Arguments for 'Reverse Fibonacci Recurse'
			move $a2,$a0		# X is the third argument
			move $a3,$a1		# N is the fourth argument
			li	$a0,1			# First fibonacci number is the first argument
			li	$a1,1			# Second fibonacci number is the Second argument
#First Function Call to rf_rec
			addiu $sp,$sp,-32	# Allocating Space in the Stack Memory for four arguments + Local Variables a,b + 1 Return Value + $ra
			sw	$a0,0($sp)		# Storing First Argument on Stack
			sw	$a1,4($sp)		# Storing Second Argument on Stack
			sw	$a2,8($sp)		# Storing Third Argument on Stack
			sw	$a3,12($sp)		# Storing Fourth Argument on Stack
			sw	$a0,16($sp)		# Storing copy of 'a' on Stack
			sw	$a1,20($sp)		# Storing copy of 'b' on Stack
			sw	$ra,28($sp)		# Storing Return Address on Stack
			jal rf_rec			# calling the recursive function for the first time
			lw	$ra,28($sp)		# Restoring Return Address from Stack
			lw	$t0,24($sp)		# Get Return Value from Function
			lw	$a1,20($sp)		# Restoring 'b' from Stack
			lw	$a3,16($sp)		# Restoring 'a' from Stack
			lw	$a3,12($sp)		# Restoring Fourth Argument from Stack
			lw	$a2,8($sp)		# Restoring Third Argument from Stack
			lw	$a1,4($sp)		# Restoring Second Argument from Stack
			lw	$a0,0($sp)		# Restoring First Argument from Stack
			addiu $sp,$sp,32 	# De-allocate Space on the Stack

			
#checking if return value equals -1
			li $t1,-1
			beq $t0,$t1,neg_one	# error condition
#checking if return value equals 1
			li $t1,1
			beq $t0,$t1,e_one	# '1' remaining , nothing more to display
#checking if return value is greater than 1		
			li $t1,1
			sub $t2,$t0,$t1		# $t2 = $t0 - 1
			bgtz $t2,g_one		# $t2 > 0  OR return value > 1
			b rf_ret			# no condition matched , return
g_one:
			addiu $sp,$sp,-8	# Allocating Space in the Stack Memory for $a0 , $v0
			sw	$a0,0($sp)		# Storing $a0 on Stack
			sw	$v0,4($sp)		# Storing $v0 on Stack
			li	$v0,4		#System call for Print
			la	$a0,one		#load address of one into $ao (Required by System Call)
			syscall			#execute the system call
			lw $v0,4($sp)		#Restoring $v0
			lw $a0,0($sp)		#Restoring $a0
			addiu $sp,$sp,8 	# De-allocate Space on the Stack
			
			addiu $sp,$sp,-8	# Allocating Space in the Stack Memory for $a0 , $v0
			sw	$a0,0($sp)		# Storing $a0 on Stack
			sw	$v0,4($sp)		# Storing $v0 on Stack
			li	$v0,4		#System call for Print
			la	$a0,error1	#load address of error1 into $ao (Required by System Call)
			syscall			#execute the system call
			lw $v0,4($sp)		#Restoring $v0
			lw $a0,0($sp)		#Restoring $a0
			addiu $sp,$sp,8 	# De-allocate Space on the Stack
			
			li $v0,0		#Return OK
			b rf_ret		#return

e_one:		
			addiu $sp,$sp,-8	# Allocating Space in the Stack Memory for $a0 , $v0
			sw	$a0,0($sp)		# Storing $a0 on Stack
			sw	$v0,4($sp)		# Storing $v0 on Stack
			li	$v0,4		#System call for Print
			la	$a0,one		#load address of one into $ao (Required by System Call)
			syscall			#execute the system call
			lw $v0,4($sp)		#Restoring $v0
			lw $a0,0($sp)		#Restoring $a0
			addiu $sp,$sp,8 	# De-allocate Space on the Stack
			
			li $v0,0		#Return OK
			b rf_ret		#return

neg_one:
			addiu $sp,$sp,-8	# Allocating Space in the Stack Memory for $a0 , $v0
			sw	$a0,0($sp)		# Storing $a0 on Stack
			sw	$v0,4($sp)		# Storing $v0 on Stack
			li	$v0,1		#System call for Print
			move	$a0,$a2	#load X into $ao (Required by System Call)
			syscall			#execute the system call
			lw $v0,4($sp)		#Restoring $v0
			lw $a0,0($sp)		#Restoring $a0
			addiu $sp,$sp,8 	# De-allocate Space on the Stack
			
			
			addiu $sp,$sp,-8	# Allocating Space in the Stack Memory for $a0 , $v0
			sw	$a0,0($sp)		# Storing $a0 on Stack
			sw	$v0,4($sp)		# Storing $v0 on Stack
			li	$v0,4		#System call for Print
			la	$a0,error2	#load address of error2 into $ao (Required by System Call)
			syscall			#execute the system call
			lw $v0,4($sp)		#Restoring $v0
			lw $a0,0($sp)		#Restoring $a0
			addiu $sp,$sp,8 	# De-allocate Space on the Stack
			
			li $v0,-1		#Return error
rf_ret:			
			jr $ra			#return to caller

#################################################################################################################
#Function Name : rf_rec
#Description: Recursively Generates and Displays Fibonacci Numbers backwards as a comma seperated list
#Inputs :
#Mem($sp+0) = Smaller fibonacci number(a) (consecutive to b)
#Mem($sp+4) = Larger fibonacci number(b) (consecutive to a)
#Mem($sp+8) = The last fibonacci number(X) 
#Mem($sp+12) = How many numbers to display in reverse(N)
#Returns :
#Mem($sp+24) >=0 representing how many numbers are left to be displayed
#or
#Mem($sp+24)= -1 in case X is not a Fibonacci Number
#
#Example Calling Sequence:
#	addiu $sp,$sp,-32	# Allocating Space in the Stack Memory for four arguments + Local Variables a,b + 1 Return Value + $ra
#	sw	$a0,0($sp)		# Storing First Argument on Stack
#	sw	$a1,4($sp)		# Storing Second Argument on Stack
#	sw	$a2,8($sp)		# Storing Third Argument on Stack
#	sw	$a3,12($sp)		# Storing Fourth Argument on Stack
#	sw	$a0,16($sp)		# Storing copy of 'a' on Stack
#	sw	$a1,20($sp)		# Storing copy of 'b' on Stack
#	sw	$ra,28($sp)		# Storing Return Address on Stack
#	jal rf_rec			# calling the recursive function for the first time
#	lw	$ra,28($sp)		# Restoring Return Address from Stack
#	lw	$t0,24($sp)		# Get Return Value from Function
#	lw	$a1,20($sp)		# Restoring 'b' from Stack
#	lw	$a3,16($sp)		# Restoring 'a' from Stack
#	lw	$a3,12($sp)		# Restoring Fourth Argument from Stack
#	lw	$a2,8($sp)		# Restoring Third Argument from Stack
#	lw	$a1,4($sp)		# Restoring Second Argument from Stack
#	lw	$a0,0($sp)		# Restoring First Argument from Stack
#	addiu $sp,$sp,32 	# De-allocate Space on the Stack
#
#Notes:
#The copy of original arguments 'a' and 'b' is necessary to be stored on the Stack as it needs to be Restored 
#for Later use after the recursive call
#
#Algorithmic Description in Pseudocode:
#	int rf_rec(int a, int b, int X, int N)
#	{
#
#		if (b < X)                              //Count UP until we reach the upper limit X
#		{
#
#			int to_do = rf_rec(b, a + b, X, N);      //If not reached X , advance fibonacci series by one more
#
#			if (to_do >= 1)                      //numbers left to be displayed are more than 1
#			{
#				printline(b);                   //Print the fibonacci number
#				return to_do - 1;               //return number of left to do  ( decremented by 1 now)
#			}
#			else if (to_do == 0)                //Nothing left to be displayed
#			{
#				return 0;                       //return as it is
#			}
#			else                                //Error condition
#			{
#				return -1;                      //propogating error condition back to original caller
#			}
#
#		}
#		else if (b == X)                        //Upper limit X reached , start displaying and go back
#		{
#			printline(b);
#			return N - 1;                         //Returning Remaining numbers yet to be displayed
#		}
#		else                                    //b overshoots X , hence X is not a fibonacci number- Error condition
#		{
#			return -1;                          //return negative number which propogates back to the caller and makes sure nothing is displayed.
#		}
#
#	}
#################################################################################################################
rf_rec:		
			lw $a0,0($sp)	#Loading first argument from Stack
			lw $a1,4($sp)	#Loading second argument from Stack
			lw $a2,8($sp)	#Loading third argument from Stack
			lw $a3,12($sp)	#Loading fourth argument from Stack
			
			beq $a1,$a2,bex	# b == X , fibonacci number reached
			sub $t0,$a1,$a2 # $t0 = b - X
			bltz $t0,blx		# in case b < X then branch to blx
			
			
			li $v0,-1		# in case no other condition is satisfied , its an error
			b rec_ret
blx:
			addu $t1,$a0,$a1	#$t1 = a + b
			addiu $sp,$sp,-32	# Allocating Space in the Stack Memory for four arguments + Local Variables a,b + 1 Return Value + $ra
			sw	$a1,0($sp)		# Storing First Argument on Stack (b)
			sw	$t1,4($sp)		# Storing Second Argument on Stack (a+b)
			sw	$a2,8($sp)		# Storing Third Argument on Stack (X)
			sw	$a3,12($sp)		# Storing Fourth Argument on Stack (N)
			sw	$a0,16($sp)		# Storing copy of 'a' on Stack
			sw	$a1,20($sp)		# Storing copy of 'b' on Stack
			sw	$ra,28($sp)		# Storing Return Address on Stack
			jal rf_rec			# calling the recursive function
			lw	$ra,28($sp)		# Restoring Return Address from Stack
			lw	$t0,24($sp)		# Get Return Value from Function
			lw	$a1,20($sp)		# Restoring 'b' from Stack
			lw	$a0,16($sp)		# Restoring 'a' from Stack
			lw	$a3,12($sp)		# Restoring Fourth Argument from Stack
			lw	$a2,8($sp)		# Restoring Third Argument from Stack
			lw	$t1,4($sp)		# Restoring Second Argument from Stack
			lw	$a1,0($sp)		# Restoring First Argument from Stack
			addiu $sp,$sp,32 	# De-allocate Space on the Stack

			beqz $t0,blx_rez	# Return value == 0  , Nothing left to be displayed
			
			li $t2,1
			sub $t3,$t0,$t2		# $t3 = Return Value - 1
			bgez $t3,blx_rgo	# Return Value >= 1
			
			li $v0,-1
			b rec_ret			# All other conditions are Error
blx_rgo:
			addiu $sp,$sp,-8	# Allocating Space in the Stack Memory for $a0 , $v0
			sw	$a0,0($sp)		# Storing $a0 on Stack
			sw	$v0,4($sp)		# Storing $v0 on Stack
			li	$v0,4			#System call for Print String
			la	$a0,comma		#load address of 'comma' into $ao (Required by System Call)
			syscall				#execute the system call
			lw $v0,4($sp)		#Restoring $v0
			lw $a0,0($sp)		#Restoring $a0
			addiu $sp,$sp,8 	# De-allocate Space on the Stack
			
			addiu $sp,$sp,-8	# Allocating Space in the Stack Memory for $a0 , $v0
			sw	$a0,0($sp)		# Storing $a0 on Stack
			sw	$v0,4($sp)		# Storing $v0 on Stack
			li	$v0,1			#System call for Print Integer
			move	$a0,$a1		#load b into $ao (Required by System Call)
			syscall				#execute the system call
			lw $v0,4($sp)		#Restoring $v0
			lw $a0,0($sp)		#Restoring $a0
			addiu $sp,$sp,8 	# De-allocate Space on the Stack
			
			li $t2,1
			sub $v0,$t0,$t2		#$v0 = Return Value - 1
			b rec_ret
			
blx_rez:
			li $v0,0
			b rec_ret
blx_ree:	
			li $v0,-1
			b rec_ret

bex:		
			addiu $sp,$sp,-8	# Allocating Space in the Stack Memory for $a0 , $v0
			sw	$a0,0($sp)		# Storing $a0 on Stack
			sw	$v0,4($sp)		# Storing $v0 on Stack
			li	$v0,1			#System call for Print Integer
			move	$a0,$a1		#load b into $ao (Required by System Call)
			syscall			#execute the system call
			lw $v0,4($sp)	#Restoring $v0
			lw $a0,0($sp)	#Restoring $a0
			addiu $sp,$sp,8 # De-allocate Space on the Stack
			
			li $t1,1
			sub $v0,$a3,$t1		# Return Value = N -1
			
rec_ret:
			sw $v0,24($sp)  #Saving Return Value on Stack
			jr $ra			#return
			
end:		li	$v0,10		#terminate Program
			syscall
			