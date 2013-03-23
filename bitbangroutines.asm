; Käyttää 8155:sen PC:n ensimmäistä pinniä lyhyesti ylhäällä.
L4032:
        in      43H     ; Tarkista portin nykyinen tila
        ori     1       ; Laita ensimmäinen bitti päälle
        out     43H     ; Aseta portti
        nop             ; Odottelua
        in      11H     ; Watchdog
        nop
        in      43H
        ani     0FEH    ; Andataan ensimmäinen bitti pois
        out     43H
        ret

; Toimii täsmälleen samoin kuin L4032 paitsi, että portin ensimmäisen pinnin
; sijaan muutetaan sen toista pinniä.
L4043:
        in      43H     ; Tarkista portin nykyinen tila
        ori     2       ; Lata toinen bitti päälle
        out     43H     ; Aseta portti
        nop             ; Odottelua
        in      11H     ; Watchdog
        nop
        in      43H
        ani     0FDH    ; Andataan bitti pois
        out     43H
        ret

; Kutsuu L4032:ta (PC0 strobe) stackissä annetun monta kertaa.
L4054:
        lxi     h,2     ; Lataa lh:hon 2
        dad     sp      ; lh += sp
        mov     c,m     ; m on stackissä paluuosoitteen jälkeen oleva arvo.
        mvi     a,0     ; Nollataan 8155:n PB
        out     42H
        inr     c       ; Kompensoidaan loopin alun dcr c.
        jmp     L4064   ; Loopin ehdon tarkistus
L4061:
        call    L4032
L4064:
        dcr     c       ; Vähennä c:tä ja kutsu uudestaan kunnes c=0
        jnz     L4061
        ret

; Kutsuu L4043:a (PC1 strobe) stackissä annetun monta kertaa.
L4069:
        lxi     h,2     ; Lataa lh:hon 2
        dad     sp      ; lh += sp
        mov     c,m     ; m on stackissä paluuosoitteen jälkeen oleva arvo.
        mvi     a,0     ; Nollataan 8155:n PB
        out     42H
        inr     c       ; Kompensoidaan loopin alun dcr c.
        jmp     L4079   ; Loopin ehdon tarkistus
L4076:
        call    L4043
L4079:
        dcr     c       ; Vähennä c:tä ja kutsu uudestaan kunnes c=0
        jnz     L4076
        ret

; Bitbangaa stackissä paluuosoitteen jälkeen annetun datan (vai alimmat
; 12 bittiä) LSB:stä alkaen PB0 pinnistä ulos.
L407E:
        lxi     h,2
        dad     sp      ; hl osoittaa paluuosoitteen jälkeiseen arvoon.
        mov     e,m     ; Ottaa hl:n osoittaman datan talteen
        inx     h       ; Laittaa osoittamaan hl:n tavun syvemmälle stackiin
        mov     d,m
        mvi     c,8     ; c on looppi countteri.
L4087:
        mov     a,e     ; Suodattaa e:stä muun pois paitsi alimman bittin
        ani     1       ; a = e & 0x01
        out     42H     ; PB = a
        mov     a,e     ; e = e>>1
        rar
        mov     e,a
        call    L4032   ; PC0 strobe
        dcr     c       ; Vähentää looppi countteria
        jnz     L4087   ; Hypppää alkuun kunnes countteri on nollassa
        mvi     c,4     ; Alustaa seuraavan loopin countterin
L4098:
        mov     a,d
        ani     1       ; a = d & 0x01
        out     42H     ; PC = a
        mov     a,d     ; d = d >> 1
        rar
        mov     d,a
        call    L4032   ; PC0 strobe
        dcr     c
        jnz     L4098
        ret

; Bitbangaa stackissä paluuosoitteen jälkeen annetun datan (vai alimmat
; 11 bittiä) LSB:stä alkaen PB0 pinnistä ulos.
L40A8:
        lxi     h,2
        dad     sp      ; hl osoittaa paluuosoitteen jälkeiseen arvoon.
        mov     e,m     ; Ottaa hl:n osoittaman datan talteen
        inx     h       ; Laittaa osoittamaan hl:n tavun syvemmälle stackiin
        mov     d,m
        mvi     c,8     ; c on looppi countteri.
L40B1:
        mov     a,e     ; Suodattaa e:stä muun pois paitsi alimman bittin
        ani     1       ; a = e & 0x01
        out     42H     ; PB = a
        mov     a,e     ; e = e>>1
        rar
        mov     e,a
        call    L4043   ; PC1 strobe
        dcr     c       ; Vähentää looppi countteria
        jnz     L40B1   ; Hypppää alkuun kunnes countteri on nollassa
        mvi     c,3     ; Alustaa seuraavan loopin countterin
L40C2:
        mov     a,d
        ani     1       ; a = d & 0x01
        out     42H     ; PC = a
        mov     a,d     ; d = d >> 1
        rar
        mov     d, a
        call    L4043   ; PC1 strobe
        dcr     c
        jnz     L40C2
        ret

; vim: ts=8 syntax=8085
