function [] = setFigure( handle, tag )
% Modify the figure properties.
% Usage:    setFigure(handle, tag)
% handle:   handle of modifying sub-figure
% tag:      name of sub-figure
	title(tag);
	xlabel('\itx')
	xlim([-2.8, 2.8]);
	ylim([-0.5, 1.2]);
end
