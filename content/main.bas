REM A Pomodoro time management application.
REM For what Pomodoro means, see https://en.wikipedia.org/wiki/Pomodoro_Technique
REM Entry program.
REM License: CC-BY.
REM Press Ctrl+R to run.

import "btnbhvr"

drv = driver()
print drv, ", detail type is: ", typeof(drv);

INTRO = 0
TIMER = 1
REDDISH = rgba(255, 217, 217)
RED = rgba(183, 7, 60)
BLACK = rgba(18, 18, 18)
LONG_REST_OF_PERIODS = 4
LONG_REST_TIMES = 6

title_bg = load_resource("title_bg.quantized")
btn_start = load_resource("btn_start.sprite")
btn_pause = load_resource("btn_pause.sprite")
btn_up = load_resource("btn_up.sprite")
btn_down = load_resource("btn_down.sprite")
tomato = load_resource("tomato.quantized")

stage = INTRO
tomatoes = 0
total_tomatoes = 0
work_min = 25
work_sec = 0
rest_min = 5
rest_sec = 0
persist total_tomatoes
persist work_min, work_sec, rest_min, rest_sec
if work_min = 0 and work_sec = 0 then
	work_min = 25
endif
if rest_min = 0 and rest_sec = 0 then
	rest_min = 5
endif
color = REDDISH
working = true
tick_work_min = 0
tick_work_sec = 0
tick_rest_min = 0
tick_rest_sec = 0
t = 0 ' Time counter.
notice = nil
paused = false

def tostr(num)
	s = str(num)
	if len(s) = 1 then
		s = "0" + s
	endif
	return s
enddef

def alert()
	if notice <> nil then
		return
	endif
	notice = coroutine
	(
		lambda ()
		(
			if working then
				play "FECFEC"
			else
				play "CEFCEF"
			endif
			color = RED
			yield wait_for(0.8)
			color = REDDISH
			yield wait_for(0.8)
			color = RED
			yield wait_for(0.8)
			color = REDDISH
			yield wait_for(0.8)
			color = RED
			yield wait_for(0.8)
			color = REDDISH
			yield wait_for(0.8)
			color = RED
			yield wait_for(0.8)
			color = REDDISH
			yield wait_for(0.8)
			color = RED
			yield wait_for(0.8)
			color = REDDISH
			yield wait_for(0.8)
			color = RED
			yield wait_for(0.8)
			color = REDDISH
			yield wait_for(0.8)
			color = RED
			yield wait_for(0.8)
			color = REDDISH
			yield wait_for(0.8)
			color = RED
			yield wait_for(0.8)
			color = REDDISH
			yield wait_for(0.8)
			notice = nil
		)
	)
	start(notice)
enddef

def title(delta)
	rectfill 0, 0, 159, 127, RED
	img title_bg, 24, 0
	text 10, 20, "WORK"
	text 10, 42, tostr(work_min)
	text 26, 42, ":"
	text 34, 42, tostr(work_sec)
	if btnbhvr(btn_up, 10, 29, 16, 12) then
		work_min = work_min + 1
		if work_min > 60 then
			work_min = 0
		endif
	endif
	if btnbhvr(btn_down, 10, 50, 16, 12) then
		work_min = work_min - 1
		if work_min < 0 then
			work_min = 60
		endif
	endif
	if btnbhvr(btn_up, 33, 29, 16, 12) then
		work_sec = work_sec + 1
		if work_sec > 59 then
			work_sec = 0
		endif
	endif
	if btnbhvr(btn_down, 33, 50, 16, 12) then
		work_sec = work_sec - 1
		if work_sec < 0 then
			work_sec = 59
		endif
	endif
	line 10, 63, 48, 63
	text 10, 65, "REST"
	text 10, 87, tostr(rest_min)
	text 26, 87, ":"
	text 34, 87, tostr(rest_sec)
	if btnbhvr(btn_up, 10, 74, 16, 12) then
		rest_min = rest_min + 1
		if rest_min > 60 then
			rest_min = 0
		endif
	endif
	if btnbhvr(btn_down, 10, 95, 16, 12) then
		rest_min = rest_min - 1
		if rest_min < 0 then
			rest_min = 60
		endif
	endif
	if btnbhvr(btn_up, 33, 74, 16, 12) then
		rest_sec = rest_sec + 1
		if rest_sec > 59 then
			rest_sec = 0
		endif
	endif
	if btnbhvr(btn_down, 33, 95, 16, 12) then
		rest_sec = rest_sec - 1
		if rest_sec < 0 then
			rest_sec = 59
		endif
	endif
	if btnbhvr(btn_start, 71, 110, 16, 12) or keyp(0x20) then
		set_fps(drv, 60, 10)
		stage = TIMER
		tick_work_min = work_min
		tick_work_sec = work_sec
		tick_rest_min = rest_min
		tick_rest_sec = rest_sec
	endif
	img tomato, 10, 8
	stomatoes = str(tomatoes)
	text 22, 10, stomatoes
	text 22 + 8 * len(stomatoes), 10, "/"
	text 30 + 8 * len(stomatoes), 10, total_tomatoes
enddef

def tick(delta)
	rectfill 0, 0, 159, 127, color
	img title_bg, 24, 0
	text 10, 44, "WORK", BLACK
	text 10, 53, tostr(tick_work_min), BLACK
	text 26, 53, iif(working, iif(t < 0.5, ":", ""), ":"), BLACK
	text 34, 53, tostr(tick_work_sec), BLACK
	line 10, 63, 48, 63, 1, BLACK
	text 10, 67, "REST", BLACK
	text 10, 76, tostr(tick_rest_min), BLACK
	text 26, 76, iif(working, ":", iif(t < 0.5, ":", "")), BLACK
	text 34, 76, tostr(tick_rest_sec), BLACK
	if not paused then
		t = t + delta
	endif
	if t >= 1 then
		t = t - 1
		if working then
			tick_work_sec = tick_work_sec - 1
			if tick_work_sec < 0 then
				tick_work_sec = 59
				tick_work_min = tick_work_min - 1
				if tick_work_min < 0 then
					tick_work_min = work_min
					tick_work_sec = work_sec
					working = false
					alert()
				endif
			endif
		else
			tick_rest_sec = tick_rest_sec - 1
			if tick_rest_sec < 0 then
				tick_rest_sec = 59
				tick_rest_min = tick_rest_min - 1
				if tick_rest_min < 0 then
					tick_work_min = work_min
					tick_work_sec = work_sec
					tick_rest_min = rest_min
					tick_rest_sec = rest_sec
					tomatoes = tomatoes + 1
					total_tomatoes = total_tomatoes + 1
					if (tomatoes mod LONG_REST_OF_PERIODS) = 0 then
						tick_rest_min = tick_rest_min * LONG_REST_TIMES
						tick_rest_sec = tick_rest_sec * LONG_REST_TIMES
						if tick_rest_sec > 59 then
							tick_rest_min = tick_rest_min + floor(tick_rest_sec / 60)
							tick_rest_sec = tick_rest_sec mod 60
						endif
					endif
					working = true
					alert()
				endif
			endif
		endif
	endif
	if working then
		rect 8, 42, 51, 62, BLACK
	else
		rect 8, 65, 51, 85, BLACK
	endif
	if paused then
		if btnbhvr(btn_start, 71, 110, 16, 12) then
			paused = false
		endif
	else
		if btnbhvr(btn_pause, 71, 110, 16, 12) then
			paused = true
		endif
	endif
	if keyp(0x20) then
		paused = not paused
	endif
	img tomato, 10, 8
	stomatoes = str(tomatoes)
	text 22, 10, stomatoes, BLACK
	text 22 + 8 * len(stomatoes), 10, "/", BLACK
	text 30 + 8 * len(stomatoes), 10, total_tomatoes, BLACK
enddef

update_with
(
	drv,
	lambda (delta)
	(
		if stage = INTRO then
			title(delta)
		elseif stage = TIMER then
			tick(delta)
		endif
		btnrst()
	)
)
