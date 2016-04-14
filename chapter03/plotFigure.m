function [] = plotFigure( M, N, id, titlesuffix, x1, y1, x2, y2 )
    subplot(M, N, id);
    plot(x1, y1, 'g-', x2, y2, 'b.');
    setFigure(gca, strcat('Iteration: ', titlesuffix));
end