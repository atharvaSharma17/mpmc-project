ORG 0000H
LJMP START

ORG 000BH
LJMP TIMER0_ISR

;-----------------------------------
; START / INIT
;-----------------------------------
START:

    MOV P1,#0FFH

    MOV R0,#05H     ; Stock A
    MOV R1,#05H     ; Stock B
    MOV R2,#05H     ; Stock C

    MOV 30H,#00H    ; Timer A
    MOV 31H,#00H    ; Timer B
    MOV 32H,#00H    ; Timer C

;-----------------------------------
; LCD INIT
;-----------------------------------
    MOV A,#38H
    ACALL COMMAND
    ACALL INIT_DELAY

    MOV A,#0CH
    ACALL COMMAND
    ACALL INIT_DELAY

    MOV A,#01H
    ACALL COMMAND
    ACALL CLEAR_DELAY

    MOV A,#06H
    ACALL COMMAND
    ACALL INIT_DELAY

;-----------------------------------
; TIMER INIT
;-----------------------------------
    ACALL TIMER0_INIT

;-----------------------------------
; MAIN LOOP
;-----------------------------------
MAIN_LOOP:

    ACALL SHOW_WELCOME

CHECK_KEYS:

    JB P1.3,CHK_B
    ACALL DISPENSE_A
    SJMP MAIN_LOOP

CHK_B:
    JB P1.4,CHK_C
    ACALL DISPENSE_B
    SJMP MAIN_LOOP

CHK_C:
    JB P1.5,CHK_STOCK
    ACALL DISPENSE_C
    SJMP MAIN_LOOP

CHK_STOCK:
    JB P1.6,CHK_RESET
    ACALL SHOW_STOCK
    SJMP MAIN_LOOP

CHK_RESET:
    JB P1.7,CHECK_KEYS
    LJMP START

;-----------------------------------
; DISPENSE A
;-----------------------------------
DISPENSE_A:
    MOV A,30H
    JNZ MSG_WAIT_CALL

    MOV A,R0
    JZ MSG_EMPTY_CALL

    DEC R0
    MOV 30H,#60
    ACALL MSG_A_GIVEN
    RET

;-----------------------------------
; DISPENSE B
;-----------------------------------
DISPENSE_B:
    MOV A,31H
    JNZ MSG_WAIT_CALL

    MOV A,R1
    JZ MSG_EMPTY_CALL

    DEC R1
    MOV 31H,#60
    ACALL MSG_B_GIVEN
    RET

;-----------------------------------
; DISPENSE C
;-----------------------------------
DISPENSE_C:
    MOV A,32H
    JNZ MSG_WAIT_CALL

    MOV A,R2
    JZ MSG_EMPTY_CALL

    DEC R2
    MOV 32H,#60
    ACALL MSG_C_GIVEN
    RET

;-----------------------------------
; COMMON MESSAGES
;-----------------------------------
MSG_WAIT_CALL:
    ACALL MSG_WAIT
    RET

MSG_EMPTY_CALL:
    ACALL MSG_EMPTY
    RET

;-----------------------------------
; SHOW STOCK
;-----------------------------------
SHOW_STOCK:
    MOV A,#01H
    ACALL COMMAND
    ACALL CLEAR_DELAY

    MOV A,#80H
    ACALL COMMAND

    MOV A,#'A'
    ACALL SEND_DATA
    MOV A,#':'
    ACALL SEND_DATA
    MOV A,R0
    ADD A,#30H
    ACALL SEND_DATA

    MOV A,#' '
    ACALL SEND_DATA

    MOV A,#'B'
    ACALL SEND_DATA
    MOV A,#':'
    ACALL SEND_DATA
    MOV A,R1
    ADD A,#30H
    ACALL SEND_DATA

    MOV A,#0C0H
    ACALL COMMAND

    MOV A,#'C'
    ACALL SEND_DATA
    MOV A,#':'
    ACALL SEND_DATA
    MOV A,R2
    ADD A,#30H
    ACALL SEND_DATA

    ACALL LONG_DELAY
    RET

;-----------------------------------
; WELCOME DISPLAY
;-----------------------------------
SHOW_WELCOME:
    MOV A,#01H
    ACALL COMMAND
    ACALL CLEAR_DELAY

    MOV A,#80H
    ACALL COMMAND
    MOV A,#'I'
    ACALL SEND_DATA
    MOV A,#'C'
    ACALL SEND_DATA
    MOV A,#'U'
    ACALL SEND_DATA
    MOV A,#' '
    ACALL SEND_DATA
    MOV A,#'M'
    ACALL SEND_DATA
    MOV A,#'E'
    ACALL SEND_DATA
    MOV A,#'D'
    ACALL SEND_DATA

    MOV A,#0C0H
    ACALL COMMAND
    MOV A,#'R'
    ACALL SEND_DATA
    MOV A,#'E'
    ACALL SEND_DATA
    MOV A,#'A'
    ACALL SEND_DATA
    MOV A,#'D'
    ACALL SEND_DATA
    MOV A,#'Y'
    ACALL SEND_DATA
    RET

;-----------------------------------
; MESSAGES
;-----------------------------------
MSG_A_GIVEN:
    MOV A,#01H
    ACALL COMMAND
    ACALL CLEAR_DELAY
    MOV A,#80H
    ACALL COMMAND
    MOV A,#'A'
    ACALL SEND_DATA
    MOV A,#' '
    ACALL SEND_DATA
    MOV A,#'G'
    ACALL SEND_DATA
    MOV A,#'I'
    ACALL SEND_DATA
    MOV A,#'V'
    ACALL SEND_DATA
    MOV A,#'E'
    ACALL SEND_DATA
    MOV A,#'N'
    ACALL SEND_DATA
    RET

MSG_B_GIVEN:
    MOV A,#01H
    ACALL COMMAND
    ACALL CLEAR_DELAY
    MOV A,#80H
    ACALL COMMAND
    MOV A,#'B'
    ACALL SEND_DATA
    MOV A,#' '
    ACALL SEND_DATA
    MOV A,#'G'
    ACALL SEND_DATA
    MOV A,#'I'
    ACALL SEND_DATA
    MOV A,#'V'
    ACALL SEND_DATA
    MOV A,#'E'
    ACALL SEND_DATA
    MOV A,#'N'
    ACALL SEND_DATA
    RET

MSG_C_GIVEN:
    MOV A,#01H
    ACALL COMMAND
    ACALL CLEAR_DELAY
    MOV A,#80H
    ACALL COMMAND
    MOV A,#'C'
    ACALL SEND_DATA
    MOV A,#' '
    ACALL SEND_DATA
    MOV A,#'G'
    ACALL SEND_DATA
    MOV A,#'I'
    ACALL SEND_DATA
    MOV A,#'V'
    ACALL SEND_DATA
    MOV A,#'E'
    ACALL SEND_DATA
    MOV A,#'N'
    ACALL SEND_DATA
    RET

MSG_WAIT:
    MOV A,#01H
    ACALL COMMAND
    ACALL CLEAR_DELAY
    MOV A,#80H
    ACALL COMMAND
    MOV A,#'W'
    ACALL SEND_DATA
    MOV A,#'A'
    ACALL SEND_DATA
    MOV A,#'I'
    ACALL SEND_DATA
    MOV A,#'T'
    ACALL SEND_DATA
    RET

MSG_EMPTY:
    MOV A,#01H
    ACALL COMMAND
    ACALL CLEAR_DELAY
    MOV A,#80H
    ACALL COMMAND
    MOV A,#'E'
    ACALL SEND_DATA
    MOV A,#'M'
    ACALL SEND_DATA
    MOV A,#'P'
    ACALL SEND_DATA
    MOV A,#'T'
    ACALL SEND_DATA
    MOV A,#'Y'
    ACALL SEND_DATA
    RET

;-----------------------------------
; TIMER INIT
;-----------------------------------
TIMER0_INIT:
    MOV TMOD,#01H
    MOV TH0,#0FCH
    MOV TL0,#066H
    SETB ET0
    SETB EA
    SETB TR0
    RET

;-----------------------------------
; TIMER ISR (PARALLEL)
;-----------------------------------
TIMER0_ISR:

    MOV TH0,#0FCH
    MOV TL0,#066H

    MOV A,30H
    JZ SKIP_A
    DEC 30H
SKIP_A:

    MOV A,31H
    JZ SKIP_B
    DEC 31H
SKIP_B:

    MOV A,32H
    JZ SKIP_C
    DEC 32H
SKIP_C:

    RETI

;-----------------------------------
; LCD FUNCTIONS (P1.0 RS, P1.2 EN)
;-----------------------------------
COMMAND:
    MOV P2,A
    CLR P1.0
    SETB P1.2
    NOP
    NOP
    CLR P1.2
    ACALL SHORT_DELAY
    RET

SEND_DATA:
    MOV P2,A
    SETB P1.0
    SETB P1.2
    NOP
    NOP
    CLR P1.2
    ACALL SHORT_DELAY
    RET

;-----------------------------------
; DELAYS
;-----------------------------------
SHORT_DELAY:
    MOV R7,#20
S1: DJNZ R7,S1
    RET

LONG_DELAY:
    MOV R7,#200
L1: MOV R6,#255
L2: DJNZ R6,L2
    DJNZ R7,L1
    RET

CLEAR_DELAY:
    MOV R7,#50
C1: MOV R6,#255
C2: DJNZ R6,C2
    DJNZ R7,C1
    RET

INIT_DELAY:
    MOV R7,#10
I1: MOV R6,#255
I2: DJNZ R6,I2
    DJNZ R7,I1
    RET

END
