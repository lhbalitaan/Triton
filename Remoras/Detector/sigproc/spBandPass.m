function y = spBandPass(x, SampleRate, FilterBank)
% BandLimitedSignals = spBandPass(Signal, SampleRate, FilterBank)
% Given a signal x and a set of band pass filters FilterBank, 
% return the resampled band limited signals.
%
% FilterBank is a structure containing a set of filters
% .SampleRate - sampling rate
% .PassBands - N x 2 matrix containing start/stop bands of filters
% .Band{N} - Band pass filter Band{i} corresponding to .PassBand{i} 
%	Each filter should be in the format generated by sptool.  
%	In particular, the field .Band{N}.tf should contain num/den fields 
%	corresponding to the numerator and denominator of the filter.
% If FilterBank is the empty matrix [], the function merely copies the
% input signal into BandLimitedSignals.Band{1} and populates the SampleRate
% and PassBand fields.  This permits unfiltered signals to be treated
% in the same way as others.
%
% BandLimitedSignals contains
%	.SampleRate(n) - SampleRate of the nth bank.
%	.Signal{n} - Band limited Signal from the nth bank.
%	.PassBands(n) - N x 2 matrix containing start/stop of the
%		signal before being passed throught the filter bank.
%
% This code is copyrighted 1997, 1998 by Marie Roch.
% e-mail:  marie-roch@uiowa.edu
%
% Permission is granted to use this code for non-commercial research
% purposes.  Use of this code, or programs derived from this code for
% commercial purposes without the consent of the author is strictly
% prohibited. 

error(nargchk(3,3,nargin));
debug = 0;

Nyquist = SampleRate / 2;

if ~ isempty(FilterBank)
  y.PassBands = FilterBank.PassBands;
  y.SampleRate = zeros(1, size(FilterBank.PassBands, 1));

  if SampleRate ~= FilterBank.SampleRate
    if FilterBank.SampleRate ~= 1
      % if not normalized, filter bank mismatch.  We could
      % certainly convert, but just return error.
      error('FilterBank and Signal sampling rate mismatch');
    else
      % normalized filterbank.  
      NormalizedPB = FilterBank.PassBands;
    end
  else
    % Normalize frequencies between [0, 1]
    NormalizedPB = FilterBank.PassBands / Nyquist;
  end
  
  NormalizedPBRad = NormalizedPB * pi;	% convert pass band to radians
  
  if debug
    newplot
  end
  
  for k=1:length(FilterBank.Band)
    
    % bandpass filter
    if FilterBank.ZeroPhase
      xFiltered = filtfilt(FilterBank.Band{k}.tf.num, ...
	  FilterBank.Band{k}.tf.den, x);
      else
	xFiltered = filter(FilterBank.Band{k}.tf.num, ...
	    FilterBank.Band{k}.tf.den, x);
      end
    
    if debug
      subplot(3,2,(k-1)*2 + 1);
      psd(xFiltered, 512, 8000);
      title(sprintf('%d - %d Hz', FilterBank.PassBands(k,:)));
      ylabel('');
    end
    
    % frequency shift left edge of pass band to 0
    xFiltered = exp(-j*NormalizedPBRad(k,1)*(1:length(xFiltered))') ...
	.* xFiltered;
    
    if debug
      subplot(3,2,(k-1)*2 + 2);
      psd(xFiltered, 512, 8000);
      title(sprintf('%d - %d Hz', FilterBank.PassBands(k,:)));
      ylabel('');
    end
    
    % change sampling rate
    y.SampleRate(k) = round(SampleRate * ...
	(NormalizedPB(k,2) - NormalizedPB(k,1)));
    y.Signal{k} = resample(xFiltered, y.SampleRate(k), SampleRate);
    
  end
else
  % empty filter structure.  Copy signal & populate fields.
  y.SampleRate(1) = SampleRate;
  y.PassBands(1,:) = [0, Nyquist];
  y.Signal{1} = x;
end
  
  
  






