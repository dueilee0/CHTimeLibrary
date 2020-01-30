
	// 시간과 관련된 라이브러리 입니다. v1.1
	// 제작: dueilee
	// dueilee0@naver.com
	
	if(!import('timerDatas')){ export('timerDatas', array('task_id': null, 'timers': array())); }

	proc _startTimer(@target, @code, @second, @endCode){ // @code == closure(@target, @startTime)
		@vData = import('timerDatas')
		if(_exists(@vData[timers], @target)){ return('alreadyStartTimer'); }
		
		@vData[timers][@target] = array('startTime': time(), 'code': @code)
		
		if(is_numeric(@second) && is_closure(@endCode)){ @vData[timers][@target][countDown] = time() + @second * 1000; @vData[timers][@target][endCode] = @endCode; }
		
		if(!@vData[task_id]){
			@vData[task_id] = set_interval(50, closure(){
				@vData = import('timerDatas')
				if(_size(@vData[timers]) <= 0){ clear_task(); @vData[task_id] = null; export('timerDatas', @vData); }
				else{
					foreach(@target : @dataArr in @vData[timers]){
						if(_exists(@dataArr, countDown)){
							if(@dataArr[countDown] <= time()){
								_stopTimer(@target, @dataArr[endCode])
							}else{
								execute(@target, @dataArr[countDown], @dataArr[code])
							}
						}else{
							execute(@target, @dataArr[startTime], @dataArr[code])
						}
					}
				}
			})
			export('timerDatas', @vData); exit();
		}
		export('timerDatas', @vData)
	}
	proc _stopTimer(@target, @code){
		@vData = import('timerDatas')
		if(!_exists(@vData[timers], @target)){ return('nonStartTimer'); }
		
		execute(@target, @code)
		
		array_remove(@vData[timers], @target)
		export('timerDatas', @vData)
	}
	
	proc _returnTimeUnit(@language){ // 시간 단위 표기
		switch(@language){
			case 'eng': return(array(0: array('str': 'y', 'int': 31556926), 1: array('str': 'M', 'int': 2592000), 2: array('str': 'd', 'int': 86400), 3: array('str': 'h', 'int': 3600), 4: array('str': 'm', 'int': 60), 5: array('str': 's', 'int': 1)));
			case 'kor': return(array(0: array('str': '년', 'int': 31556926), 1: array('str': '달', 'int': 2592000), 2: array('str': '일', 'int': 86400), 3: array('str': '시', 'int': 3600), 4: array('str': '분', 'int': 60), 5: array('str': '초', 'int': 1)));
		}
	}
	proc _unixTimeToString(@unixTime, @unixBool){ // 초 -> 시간 단위
		if(@unixBool){ @unixTime /= 1000; }
		
		@unitTimes = _returnTimeUnit('kor')
		@return = ''
		foreach(@key : @unitArr in @unitTimes){
			if(@unitArr['int'] <= @unixTime){
				@sumInt = integer(@unixTime / @unitArr['int'])
				@unixTime = @unixTime - @unitArr['int'] * @sumInt
				
				@return = concat(@return, @sumInt.@unitArr['str'])
			}
		}
		return(@return)
	}
	proc _stringToUnixTime(@str, @unixBool){ // 시간 단위 -> 초
		@splitStr = split('', @str)
		@int = ''
		
		@returnTime = 0
		@unitTimes = _returnTimeUnit('kor')
		array_push_all(@unitTimes, _returnTimeUnit('eng'))
		foreach(@indexStr in @splitStr){
			foreach(@key : @unitArr in @unitTimes){
				if(@int != '' && @indexStr == @unitArr['str']){ @returnTime += @unitArr['int'] * @int; @int = ''; break(); }
				else if(is_numeric(@indexStr)){ @int = concat(@int, @indexStr); break(); }
			}
		}
		
		if(@unixBool){ return(@returnTime * 1000); }
		return(@returnTime)
	}
	
	