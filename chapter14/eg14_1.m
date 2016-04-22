%% Example 14.1 K-means
%
% * *Result in book* : Figure 14.2
% * *Code in book* : Figure 14.3
% * *Output* : |eg14_1_A.png, eg14_1_B.png|
% * *Usage* : |eg14_1(), eg14_1(300)|
%
%% Source Code
function eg14_1(n)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 300;
    end
    c = 3; t = randperm(n);
    x = [randn(1 , n / 3) - 2, randn(1 , n / 3), randn(1 , n / 3) + 2;
        randn(1 , n / 3), randn(1 , n / 3) + 4, randn(1 , n / 3)]';
    m = x(t(1 : c) , :);
    x2 = sum(x .^ 2 , 2);
    s0(1 : c , 1) = inf;
    id = 1;
    figure('Name', 'K-means'); clf; hold on;
    title('K-means');
    for o = 1 : 1000
        m2 = sum(m .^ 2 , 2);
        [d, y] = min(repmat(m2 , 1 , n) + repmat(x2' , c , 1)-2 * m * x');
        for t = 1 : c
            m(t , :) = mean(x(y == t , :)); s(t , 1) = mean(d(y == t));
        end
        if norm(s - s0) < 0.001, break, end
        if (o <= 2) || (o == 4) 
            plotFigure(2, 2, id, num2str(o), x, y );
            id = id + 1;
        end
        s0 = s;
    end
    plotFigure( 2, 2, id, num2str(o), x, y );
    saveas(gcf, 'eg14_1_A', 'png');

    figure('Name', 'K-means'); clf; hold on;
    setFigure('K-means Result');
    plot(x(y == 1 , 1) , x(y == 1 , 2) , 'bo');
    plot(x(y == 2 , 1) , x(y == 2 , 2 ) , 'rx');
    plot(x(y == 3 , 1) , x(y == 3 , 2 ) , 'mv');
    saveas(gcf, 'eg14_1_B', 'png');

    % sub-function, plot sub-figure
    function [] = plotFigure( M, N, id, titlesuffix, x, y )
        subplot(M, N, id); hold on;
        plot(x(y == 1 , 1) , x(y == 1 , 2) , 'bo');
        plot(x(y == 2 , 1) , x(y == 2 , 2 ) , 'rx');
        plot(x(y == 3 , 1) , x(y == 3 , 2 ) , 'mv');
        setFigure(strcat('Iteration: ', titlesuffix));
    end

    % sub-function, figure setting
    function [] = setFigure( tag )
        title(tag);
        xlabel('\itx^{(1)}');
        ylabel('\itx^{(2)}');
    end
end