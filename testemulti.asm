.data
    multiplicador: .word 7
.text
MAIN:
     
    LOCO 7
	ECALL
    STOD multiplicador
    MULT multiplicador
    LOCO 1
    ECALL

END:
    HALT
