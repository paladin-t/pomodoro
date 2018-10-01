REM Button Behaviour
REM Reusable module to create clickable button.
REM License: CC-BY.
REM
REM Call `BTNBHVR` to render an interactable button.

' Tells whether a AABB intersect with a point.
def aabb_point_hit(l0, t0, r0, b0, x1, y1)
	if x1 < l0 or x1 > r0 then
		return false
	elseif y1 < t0 or y1 > b0 then
		return false
	endif
	return true
enddef

' A global variable stores mouse state.
mousedown = false

' Resets button state.
def btnrst()
	touch 0, _, _, b0
	if not b0 then mousedown = false
enddef

' Renders an interactable button.
' @param s - Sprite used as button background.
' @param x - X position of the button.
' @param y - Y position of the button.
' @param w - Width of the button.
' @param h - Height of the button.
' @return - Returns true if it's just clicked, otherwise false.
def btnbhvr(s, x, y, w, h)
	touch 0, cx, cy, b0
	ht = aabb_point_hit(x, y, x + w, y + h, cx, cy) ' Checks whether cursor is inside the area of the button.
	if ht then
		if b0 then
			s.play("d", "d") ' To down frame.
		else
			s.play("h", "h") ' To hovering frame.
		endif
	else
		s.play("n", "n") ' To normal frame.
	endif
	sspr s, 0,0,w,h, x,y,w,h
	if mousedown and not b0 and ht then
		mousedown = false
		return true
	elseif not mousedown and b0 then
		mousedown = true
	endif
	return false
enddef
