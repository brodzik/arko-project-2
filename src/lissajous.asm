    section .data
    one: dq 1.0
    half: dq 0.5
    time_step: dq 0.0001
    two_pi: dq 6.283185307179586
    
    section .text
    global lissajous

lissajous:
    ;push rbp
    ;mov rbp, rsp
    
    push rsi
    push rbx
    sub rsp, 200

    mov rsi, rcx
    mov ebx, edx

    pxor xmm9, xmm9
    pxor xmm10, xmm10
    cvtsi2sd xmm10, r8d
    pxor xmm11, xmm11
    cvtsi2sd xmm11, edx
    movsd xmm12, qword [rsp+108H]
    movsd xmm13, qword [rsp+100H]
    movapd xmm14, xmm3

loop:
    movapd xmm0, xmm14
    mulsd xmm0, xmm9
    addsd xmm0, xmm12

    ;call sin
    movsd [rsp - 64], xmm0
	fld qword [rsp - 64]
	fsin
	fstp qword [rsp - 64]
	movsd xmm0, [rsp - 64]

    movapd xmm15, xmm0
    addsd xmm15, [one]
    mulsd xmm15, xmm11
    mulsd xmm15, [half]

    movapd xmm0, xmm13
    mulsd xmm0, xmm9
    
    ;call sin
    movsd [rsp - 64], xmm0
	fld qword [rsp - 64]
	fsin
	fstp qword [rsp - 64]
	movsd xmm0, [rsp - 64]

    addsd xmm0, [one]
    mulsd xmm0, xmm10
    mulsd xmm0, [half]

    cvttsd2si edx, xmm15
    cvttsd2si eax, xmm0

    imul eax, ebx
    add eax, edx
    mov byte [rsi + rax], 1

    addsd xmm9, [time_step]
    comisd xmm9, [two_pi]
    jb loop
end:

    add rsp, 200
    pop rbx
    pop rsi

    ;mov rsp, rbp
    ;pop rbp
    ret
