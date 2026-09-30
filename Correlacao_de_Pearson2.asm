.data
    	
	VET_X: .word  1,2,9
    VET_Y: .word -2,3,6
    VET_AUX_X: .word 0,0,0
    VET_AUX_Y: .word 0,0,0
	VET_AUX_MULT: .word 0,0,0
	VQUAD_X: .word 0,0,0
	VQUAD_Y: .word 0,0,0
    	
	TAM: .word 3


   	RESULTADO: .space 0

  	MEDIA_X: .word 0
   	MEDIA_Y: .word 0
	SUM_XY: .word 0
	SUM_X_VQUAD: .word 0
	SUM_Y_VQUAD: .word 0 
	PROD_VQUAD: .word 0

	PEARSON_R: .word 0 #AO QUADRADO

	NUMERADOR: .word 0
	DENOMINADOR: .word 0

	CONST_25: .word 25
	CONST_4: .word 4
    CONST_NEG_100: .word -100

    E_NEG: .word 0

    MSG_POS_PERF: .asciz "O coeficiente de pearson e uma correlacao positiva perfeita. Numero com duas casas decimais: \n"
    MSG_NEG_PERF: .asciz "O coeficiente de pearson e uma correlacao negativa perfeita. Numero com duas casas decimais: \n"
	MSG_POS: .asciz "O coeficiente de pearson e uma correlacao positiva. Numero em decimal:\n"
	MSG_NEG: .asciz "O coeficiente de pearson e uma correlacao negativa. Numero em decimal:\n"
    MSG_NAO_CORRELACAO: .asciz "Nao ha correlacao linear\n"
    MSG_DECIMAL: .asciz "Em decimal"
  
    NUM_IMPAR: .word -1
    RES_QUADRADA: .word 0
    CONSTANTE_NEGATIVA: .word -2
    

    

.text
 ######### Calculo das médias##########
    	# MEDIA X
    	LOCO VET_X
    	SWAPA
    	LODD TAM
    	SUM VET_X   
    	DIV TAM
    	STOD MEDIA_X
    	SWAPA 

    	# MEDIA Y
    	LOCO VET_Y
    	SWAPA
    	LODD TAM
    	SUM VET_Y
    	DIV TAM
    	STOD MEDIA_Y
    	SWAPA

##########SUBTRAÇÃO DOS VALORES DO VETOR PELA MÉDIA#############
	#(xi - media_X)
	LOCO VET_X
	SWAPA
	LOCO VET_AUX_X
	SWAPB
	LODD TAM
	VCOPY 
	LODD MEDIA_X
	SWAPD
	LODD TAM
	VSUB VET_AUX_X

	#(xi - media_Y)
	LOCO VET_Y
	SWAPA
	LOCO VET_AUX_Y
	SWAPB
	LODD TAM
	VCOPY 
	LODD MEDIA_Y
	SWAPD
	LODD TAM
	VSUB VET_AUX_Y
##########MULTIPLICAÇÃO DE (xi - media_X)*(yi - media_Y)###########
	#(xi - media_X)*(yi - media_Y)
	LOCO VET_AUX_X
	SWAPA
	LOCO VET_AUX_MULT
	SWAPB
	LODD TAM
	VCOPY
	SWAPA
	LOCO VET_AUX_Y
	SWAPB
	LODD TAM
	VMULT VET_AUX_MULT
###########SOMA DA MULTIPLICAÇÃO DOS VETORES###############
	#SUM (xi - media_X)*(yi - media_Y)
	LODD TAM
	SUM VET_AUX_MULT
	STOD SUM_XY

##########ELEVAR AO QUADRADO OS VALORES###################
	#(xi - media_X)^2
	LOCO VET_AUX_X
	SWAPA
	LOCO VQUAD_X
	SWAPB
	LODD TAM
	VCOPY

	LODD TAM
	VQUAD VQUAD_X

	#(xi - media_Y)^2
	LOCO VET_AUX_Y
	SWAPA
	LOCO VQUAD_Y
	SWAPB
	LODD TAM
	VCOPY

	LODD TAM
	VQUAD VQUAD_Y

########SOMA DOS VALORES AO QUADRADO DO VETOR###############
	#SUM (xi - media_X)^2
	LODD TAM
	SUM VQUAD_X
	STOD SUM_X_VQUAD

	#SUM (xi - media_Y)^2
	LODD TAM
	SUM VQUAD_Y
	STOD SUM_Y_VQUAD

########PROD_VQUAD = SUM_X_VQUAD * SUM_Y_VQUAD########
	LODD SUM_X_VQUAD 
	MULT SUM_Y_VQUAD 
	STOD PROD_VQUAD


########CALCULO RAIZ QUADRADA DENOMINADOR########
# Res_quadrada =  armazena o resultado da raiz quadrada
# num_impar =  armazena numero impar. Inicia com 1 
    
    
RAIZ_QUADRADA_LOOP:
    LODD PROD_VQUAD
    ADDD NUM_IMPAR
    JNEG RAIZ_QUADRADA_FIM

    STOD PROD_VQUAD

    LOCO 1
    ADDD RES_QUADRADA
    STOD RES_QUADRADA

    LODD CONSTANTE_NEGATIVA # -2
    ADDD NUM_IMPAR
    STOD NUM_IMPAR

    JUMP RAIZ_QUADRADA_LOOP

RAIZ_QUADRADA_FIM:
    LODD RES_QUADRADA
    STOD DENOMINADOR



####### DIVISÃO######
    LODD SUM_XY
    STOD NUMERADOR
	MULT CONST_25
	STOD NUMERADOR
	LODD DENOMINADOR
	DIV CONST_4
	STOD DENOMINADOR
	LODD NUMERADOR
	DIV DENOMINADOR
	STOD PEARSON_R

#######VERIFICA VALORES######
	BNEG
    STOD E_NEG
    LODD PEARSON_R
    MOD
    STOD PEARSON_R
    JZER COEF_NAO_LINEAR
    ADDD CONST_NEG_100
    JZER COEF_PERFEITO
    JUMP COEF_CORRELACAO
    



COEF_PERFEITO:
    LODD E_NEG
    JZER COEF_PERFEITO_POSITIVO
    JUMP COEF_PERFEITO_NEGATIVO

COEF_PERFEITO_POSITIVO:
    LOCO MSG_POS_PERF
    SWAPA
    LOCO 3 
    ECALL
    JUMP FIM

COEF_PERFEITO_NEGATIVO:
    LOCO MSG_NEG_PERF
    SWAPA
    LOCO 3 
    ECALL
    JUMP FIM

    
COEF_NAO_LINEAR:
    LOCO MSG_NAO_CORRELACAO
    SWAPA
    LOCO 3 
    ECALL
    JUMP FIM

COEF_CORRELACAO:
    LODD E_NEG
    JZER COEF_CORRELACAO_POSITIVA
    JUMP COEF_CORRELACAO_NEGATIVA

COEF_CORRELACAO_POSITIVA:
    LOCO MSG_POS
    SWAPA
    LOCO 3 
    ECALL
    JUMP FIM

COEF_CORRELACAO_NEGATIVA:
    LOCO MSG_NEG
    SWAPA
    LOCO 3 
    ECALL
    JUMP FIM
   



########IMPRIME PEARSON_R######
FIM:
	LODD PEARSON_R
	SWAPA
	LOCO 1
	ECALL
	HALT #FIM
