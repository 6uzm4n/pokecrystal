GetPokeBallWobble: ; f971 (3:7971)
; Returns whether a Poke Ball will wobble in the catch animation.
; Whether a Pokemon is caught is determined beforehand.

	push de

	ld a, [rSVBK]
	ld d, a
	push de

	ld a, BANK(wBuffer2)
	ld [rSVBK], a

	ld a, [wBuffer2]
	inc a
	ld [wBuffer2], a

; Wobble up to 3 times.
	cp 3 + 1
	jr z, .finished

	ld a, [wWildMon]
	and a
	ld c, 0 ; next
	jr nz, .done

	ld hl, WobbleProbabilities
	ld a, [wBuffer1]
	ld b, a
.loop
	ld a, [hli]
	cp b
	jr nc, .checkwobble
	inc hl
	jr .loop

.checkwobble
	ld b, [hl]
	call Random
	cp b
	ld c, 0 ; next
	jr c, .done
	ld c, 2 ; escaped
	jr .done

.finished
	ld a, [wWildMon]
	and a
	ld c, 1 ; caught
	jr nz, .done
	ld c, 2 ; escaped

.done
	pop de
	ld e, a
	ld a, d
	ld [rSVBK], a
	ld a, e
	pop de
	ret

INCLUDE "data/battle/wobble_probabilities.asm"
