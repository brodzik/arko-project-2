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
    cvtsi2sd xmm10, edx

    ; height to double
    cvtsi2sd xmm11, r8d

    ; time = 0
    pxor xmm9, xmm9

loop:

    ; a * t + delta
    movsd xmm0, qword [rbp + 104]
    mulsd xmm0, xmm9
    addsd xmm0, qword [rbp + 56]

    ; sin(a * t + delta)
    movsd [rbp - 8], xmm0
	fld qword [rbp - 8]
	fsin
	fstp qword [rbp - 8]
	movsd xmm0, [rbp - 8]

    ; x = (sin(a * t + delta) + 1) * width * 0.5
    movapd xmm15, xmm0
    addsd xmm15, [one]
    mulsd xmm15, xmm10
    mulsd xmm15, [half]

    ; x to int
    cvttsd2si ebx, xmm15

    ; b * t
    movsd xmm0, qword [rbp + 48]
    mulsd xmm0, xmm9
    
    ; sin(b * t)
    movsd [rbp - 8], xmm0
	fld qword [rbp - 8]
	fsin
	fstp qword [rbp - 8]
	movsd xmm0, [rbp - 8]

    ; y = (sin(b * t) + 1) * height * 0.5
    addsd xmm0, [one]
    mulsd xmm0, xmm11
    mulsd xmm0, [half]

    ; y to int
    cvttsd2si eax, xmm0

    ; y * width + x
    imul eax, edx
    add eax, ebx

    ; set pixel
    mov byte [rcx + rax], 1

    ; increment time, check end condition, loop
    addsd xmm9, [time_step]
    comisd xmm9, [two_pi]
    jb loop

end:

    ; deallocate local variables
    add rsp, 8

    ; epilogue
    mov rsp, rbp
    pop rbp
    ret
