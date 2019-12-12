    section .data
    one: dq 1.0
    half: dq 0.5
    time_step: dq 0.0001
    two_pi: dq 6.283185307179586
    
    section .text
    global lissajous

lissajous:

    ; prologue
    push rbp
    mov rbp, rsp

    ; allocate local variables
    sub rsp, 8
    
    ; width to double
    cvtsi2sd xmm0, edx

    ; height to double
    cvtsi2sd xmm1, r8d

    ; time = 0
    pxor xmm2, xmm2

loop:

    ; a * t + delta
    movsd xmm3, qword [rbp + 104]
    mulsd xmm3, xmm2
    addsd xmm3, qword [rbp + 56]

    ; sin(a * t + delta)
    movsd [rbp - 8], xmm3
	fld qword [rbp - 8]
	fsin
	fstp qword [rbp - 8]
	movsd xmm3, [rbp - 8]

    ; x = (sin(a * t + delta) + 1) * width * 0.5
    addsd xmm3, [one]
    mulsd xmm3, xmm0
    mulsd xmm3, [half]

    ; x to int
    cvttsd2si ebx, xmm3

    ; b * t
    movsd xmm3, qword [rbp + 48]
    mulsd xmm3, xmm2
    
    ; sin(b * t)
    movsd [rbp - 8], xmm3
	fld qword [rbp - 8]
	fsin
	fstp qword [rbp - 8]
	movsd xmm3, [rbp - 8]

    ; y = (sin(b * t) + 1) * height * 0.5
    addsd xmm3, [one]
    mulsd xmm3, xmm1
    mulsd xmm3, [half]

    ; y to int
    cvttsd2si eax, xmm3

    ; y * width + x
    imul eax, edx
    add eax, ebx

    ; set pixel
    mov byte [rcx + rax], 1

    ; increment time, check end condition, loop
    addsd xmm2, [time_step]
    comisd xmm2, [two_pi]
    jb loop

end:

    ; deallocate local variables
    add rsp, 8

    ; epilogue
    mov rsp, rbp
    pop rbp
    ret
