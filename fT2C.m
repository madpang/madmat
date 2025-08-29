%{
	@brief: Convert from temperature (Celsius degree) to sound speed (m/s)
	
	@param[in]: temp -- Temperature in Celsius degrees, must be 0 <= temp <= 100
	@param[out]: c -- Sound speed in m/s

	@details: It is an implementation of the 112-point ver. of the so-called *Bilaniuk and Wong model*.
	@see: National Physical Laboratory, "Technical Guides - Speed of Sound in Pure Water." Underwater Acoustics, 2000

	@author: madpang
	@date: [created: 2025-08-30, updated: 2025-08-30]
%}
function c = fT2C(temp)
	if temp < 0 || temp > 100
		error('Input temperature must be between 0 and 100 degrees Celsius.');
	end
	c = 1.402385 * 10^3 + ...
		5.038813 * temp - ...
		5.799136 * 10^(-2) * temp.^2 + ...
		3.287156 * 10^(-4) * temp.^3 - ...
		1.398845 * 10^(-6) * temp.^4 + ...
		2.787860 * 10^(-9) * temp.^5;
end
