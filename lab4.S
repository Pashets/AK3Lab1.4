.global lab4
.syntax unified

#define X1 #12
#define X2 #2
#define X3 #-10
#define X4 #15
#define RB #0b01110101

lab4:
	push {lr}
	bl task1
	bl task2
	pop {pc}

task1:
	push {lr}
	mov r0, X1
	mov r1, #0

	mov r2, X2
	mov r3, #0

	mov r4, X3
	mov r5, #-1 

	mov r6, X4
	mov r7, #0

	// calc
	// F = (-10 + 1 - 15) / 4 | 4 * (12 / 2 + 2) = -6;
	// F = (x3 + 1 - x4) / 4 | 4 * (x1 / 2 + 2);

	// x3 + 1
	add r4, #1
	adc r5, #1

	// x3 + 1 - x4
	sub r4, r6
	sbc r5, r7	

	// (x3 + 1 - x4) / 4
	asr r4, #2
	lsr r5, #2

	// x1 / 2
	asr r0, #1
	lsr r1, #1

	// x1 / 2 + 2
	add r0, #2
	adc r1, #2

	// 4 * (x1 / 2 + 2)
	lsl r0, #2
	lsl r1, #2

	// (x3 + 1 - x4) / 4 | 4 * (x1 / 2 + 2)
	orr r0, r4
	orr r1, r5

	bl result_correction
	pop {pc}


// Correction
result_correction:
	push {lr}
	bvc step2

	lsr r0, #1
	lsr r1, #1

step2:
	tst r0, #0
	beq step4
	mov r0, RB

step4:
	add r1, RB
	and r5, r1, #0xc0000000
	beq step7
	eor r5, #0xc0000000
	beq step7
	lsr r0, #1
	lsr r1, #1

step7:
	bvs  endc
	push {r0}
	push {r1}
	pop  {r1}
	pop  {r0}

endc:
	pop {pc}

task2:
	push {lr}

	mov r1, #12
	mov r2, #23

program_a:
	// 1: r0 = r1 - r2
	sub r0, r1, r2
	
	// 2: r0 = r1 * r2
	mul r0, r1, r2
	
	bl program_b
jump3:
	// 3: r0 = r1 + r2
	add r0, r1, r2
	
	// 4: jump1
	bls jump1
	
	// 6: r0 = r1 + r2
	add r0, r1, r2
	
	b jump2
jump1:
	// 5: r0 = r0 + 10
	add r0, #10
	
	// 7: r1 = r1 - 3
	sub r1, #3
jump2:
	// 8: jump3
	bvs jump3
	
	// 9: r0 = r0 & r1
	and r0, r1
	pop {pc}

program_b:
	push {lr}
jump5:
	// 10: r2 = r2 + 1
	add r2, #10
	cmp r2, #100
	bpl jump4
	
	// 11: r1 = r1 & 2
	and r1, #2
	
	bl program_c
	
	// 12: r1 = r1 ^ r2 
	eor r1, r2
jump4:
	// 13: jump5
	bls jump5
	
	// 14: r0 = r1 + r2
	add r0, r1, r2
	
	// 15: r0 = r1 - r2
	sub r0, r1, r2
	
	pop {pc}

program_c:
	push {lr}
	
	// 17: r0 = r1 + r2
	adds r0, r1, r2
	
	// 18: r0 = r2 / r1
	udiv r0, r2, r1
	
	pop {pc}
