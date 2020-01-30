# CHTimeLibrary
A function related to time.

## 함수
### string _unixTimeToString(unixTime, @unixBoolean)
초를 시간 단위로 반환 합니다.
### int _stringToUnixTime(targetString, unixBoolean)
시간 단위를 초로 반환 합니다.
### mixed _startTimer(targetPlayer, code, [second], [endcode])
targetPlayer의 타이머를 시작합니다.
[second]와 [endcode] 인자를 작성할 시 카운트다운이 시작 됩니다.
### mixed _stopTimer(targetPlayer, code)
targetPlayer의 타이머를 종료 합니다.

## example.ms
	_startTimer('dueilee', closure(@target, @startTime){
		@time = (time() - @startTime) / 1000
		action_msg(@target, @time)
		if(@time > 5){
			_stopTimer(@target, closure(@target){
				action_msg(@target, '§c종료!')
			})
		}
	})
## example.ms Execute
![exampleExecute](/example.gif)
## exampleCountDown.ms
	register_command('testtimer', array(
	'executor': closure(@cmd, @sender, @cArgs){
		@code = closure(@target, @time){
			action_msg(@target, '§b'.round((@time - time()) / 1000, 1).'초')
		}
		@endCode = closure(@target){
			action_msg(@target, '§c종료')
		}
		msg(_startTimer(@sender, @code, 5, @endCode))
	}
	))
## exampleCountDown.ms Execute
![exampleCountDownExecute](/exampleCountDown.gif)