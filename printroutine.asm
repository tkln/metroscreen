; Ottaa parametrinaan 2 8-bittistä lukua l:ssä ja h:ssa sekä yhden
; 16-bittisen DE:ssä
L4000:
        jmp     L59A1	; Hyppää osoitteeseen 59A1

L59A1:
        mov     c,l 	; Kopioi l-rekisteri c:hen
        mvi     b,000H  ; Nollaa b rekisteri
        push    b		; työnnä bc pinoon (00ll)
        mov     c,h 	; kopioi h-rekisteri c:hen
        push    b 		; työnnä bc pinoon (00hh)
        push    d 		; työnnä de pinoon (ddee)
        call    L56E4   ; Kutsu rutiinia L56E4
        pop     b 		; poista pinoon työnnetyt 3 16-bittistä lukua
        pop     b
        pop     b
        ret 			; palaa (L4000) kutsuneeseen rutiiniin