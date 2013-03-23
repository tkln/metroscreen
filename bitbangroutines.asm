; Käyttää 8155:sen PORTC:n ensimmäistä pinniä lyhyesti ylhäällä.
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
        in      43H
        ori     2
        out     43H
        nop
        in      11H
        nop
        in      43H
        ani     0FDH
        out     43H
        ret

