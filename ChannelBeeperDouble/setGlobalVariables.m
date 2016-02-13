function setGlobalVariables()

	global screens
	global initial_time
	global SoundHandle

	%screens = 0 if running of one screen, 1 if running off of two
	screens = 1;

	initial_time = GetSecs();
	%save('initial_time')




end