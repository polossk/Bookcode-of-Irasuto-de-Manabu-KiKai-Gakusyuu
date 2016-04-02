function [] = plotFigure( M, N, id, h, lambda, x1, y1, x2, y2 )
	subplot(M, N, id);
	plot(x1, y1, 'g-', x2, y2, 'b.');
	axis([-2.8 2.8 -0.7 1.7]);
	title = strcat( '(h, \lambda) = (', h, ', ', lambda, ')' );
	setFigure(gca, title);
end