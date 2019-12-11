    section .data
    time_step: dd 0.0001
    two_pi: dd 6.28318530718

    section .text
    global lissajous

lissajous:
    push rbp ; prologue
    mov rbp, rsp

    pxor xmm0, xmm0
    movsd xmm1, qword [time_step]
    movsd xmm2, qword [two_pi]
loop:
    addsd xmm0, xmm1
    comisd xmm2, xmm0
    ja loop

end:
    mov rsp, rbp ; epilogue
    pop rbp
    ret
