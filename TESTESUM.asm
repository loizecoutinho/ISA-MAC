.data 
VETOR:  .word 1, 2, 3, 4, 5, 6
SIZE:   .word 6
TESTE: .word 6
UM: .word 1

.text
MAIN:  	
	LOCO 7
	ECALL
	MOD
    SUBD UM
    NEG
	STOD SIZE
	SUM VETOR
    DIV TESTE
	LOCO 1
    


END:	ECALL
	HALT
