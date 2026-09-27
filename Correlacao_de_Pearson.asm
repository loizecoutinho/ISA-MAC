.data
    VET_X: .word  1,2,9
    VET_Y: .word -2,3,6
    TAM: .word 3
    E_NEG: .space 0
    VET_AUX: .word 0,0,0
    VET_AUX1: .word 0,0,0
    RESULTADO: .space 0
    MEDIA_X: .word 0
    MEDIA_Y: .word 0

.text
    # Calculo das médias
    # MEDIA X
    LODD TAM
    SUM VET_X
    DIV TAM
    STOD MEDIA_X
  
    # MEDIA Y
    LODD TAM
    SUM VET_Y
    DIV TAM
    STOD MEDIA_Y
    SWAPA
    LOCO 1
    ECALL

