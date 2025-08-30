%{
	@brief: Generate a function handle for Gaussian modulated toneburst.
	@usage: func = fToneBurst(amp, fc, dur)

	@param[out]:
	- func: a function handle that takes time vector as input and returns the toneburst signal.
	@param[in]:
	- amp: amplitude of the toneburst (sinusoid) to be modulated, scalar.
	- fc: central frequency of the sinusoid wave, scalar.
	- dur: duration of the modulated pulse, scalar.

	@details:
	- The toneburst is created by multiplying a sinusoid with a rectangular window and Gaussian weight.
	- The Gaussian weight provides smooth tapering to reduce spectral leakage.
	- Naming convention is unified with UT_2022_12_25_a.nb of stack 2023-01-08-a.
	- No argument validation is performed.

	@example:
	```
	fc = 2.5e+6; dur = 4/fc; tvec = 1/(31.25e+6) * (0:1:100);
	pulse = feval(fToneBurst(100, fc, dur), tvec);
	plot(pulse);
	```

	@note: tvec can be either row or column vector.

	@author: madpang
	@date: [created: 2019-06-15, updated: 2023-05-29]
%}

function func = fToneBurst(amp, fc, dur)
	
	% Continuous single wave function
	cwFun = fSinusoid(amp, fc, 0);

	% Window function
	winFun = fRecWin(dur);

	% Gaussian weight
	weightFun = fGaussianWeight(dur/2, 0.01);

	func = @(tvec) cwFun(tvec) .* winFun(tvec) .* weightFun(tvec);

end

%% SUB FUNCTIONS

% ---
function func = fSinusoid(amp, fc, phi)

	omega = 2*pi*fc;
	func = @(tvec) amp * sin(omega * tvec + phi);

end

% ---
function func = fRecWin(dur)

	func = @(tvec) (tvec >= 0 & tvec <= dur) * 1;		

end

% ---
%{
	@param[out]:
		- func: function handle
	@param[in]:
		- b: center of Gaussian weight function, in second, usually should be 1/2 of pulse duration (assuming start from time instance 0), scalar.
		- par: part of maximum value at time instance 0 (also at end of pulse duration), default 0.01, i.e., 1/100, scalar.
	@note:
		- The maximum of weight is 1.
		- b can NOT be set to 0.
		- for practical pulse, func(0) must be 0.
		- The general form of Gaussian weight function is:
			- g(x) = a * exp(-(x-b)^2/(2*c^2))
			- a is set to be 1 to keep the "peak" of the weight be unit.
			- b is usually set to align the center of the weight function with the center of the pulse.
			- c is determined when value at a specific point $x_0$ is desired, usually at g(0)
		- Refer to: <https://en.wikipedia.org/wiki/Normal_distribution>
%}
function func = fGaussianWeight(b, par)

	c2 = -b^2 / (2*log(par));
	func = GaussianFcn(1, b, sqrt(c2));

end

% ---
function func = GaussianFcn(a, b, c)
	
	func = @(tvec) a * exp(-(tvec - b).^2 / (2 * c^2));

end
