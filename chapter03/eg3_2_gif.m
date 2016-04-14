%% Example 3.2 Basic Linear Regression with Stochastic Gradient Descent Method
%
% * *Result in book* : Figure 3.7
% * *Code in book* : Figure 3.8
% * *Output* : |eg3_2_anime.gif|
% * *Usage* : |eg3_2_gif(), eg3_2_gif(50, 1000)|
%
%% Source Code
function eg3_2_gif(n, N)
    % init
    rng(0);
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 2
        n = 50; N = 1000;
    end

    % constant
    x = linspace(-3, 3, n)';
    X = linspace(-3, 3, N)';
    pix = pi * x;
    y = sin(pix) ./ pix + 0.1 * x + 0.05 * randn(n, 1);

    % plot preparation
    figure('Name', 'example 3-2 gif', 'Visible', 'off'); clf;

    % iteration parameter
    hh = 2 * 0.3 * 0.3;
    K = exp(-(repmat(X .^ 2, 1, n) + repmat((x .^ 2)', N, 1) - 2 * X * x') / hh);
    t0 = randn(n, 1);
    e = 0.1;
    eps = 1e-6;
    id = 0;


    figure('Visible', 'off');
    plot(X, K * t0, 'g-', x, y, 'bo');
    xlim([-2.8, 2.8]); ylim([-0.5, 1.2]);
    text(-2.7, 1.1, strcat('Iteration Count: ', num2str(id)));
    im = frame2im(getframe);
    [Data, map] = rgb2ind(im, 256);
    imwrite(Data, map, 'eg3_2_anime.gif', 'gif', 'Loopcount', 0, 'DelayTime', 0.05);
    id = id + 1;
    % iteration, plot data within iteration
    for o = 1 : n * 1000
        index = ceil(rand * n);
        ki = exp(-(x - x(index)) .^ 2 / hh);
        t = t0 - e * ki * (ki' * t0 - y(index));
        if norm(t - t0) < eps, break, end
        if (rem(id,  57) == 0)
            figure('Visible', 'off');
            plot(X, K * t, 'g-', x, y, 'bo');
            xlim([-2.8, 2.8]); ylim([-0.5, 1.2]);
            text(-2.7, 1.1, strcat('Iteration Count: ', num2str(id)));
            im = frame2im(getframe);
            [Data, map] = rgb2ind(im, 256);
            imwrite(Data, map, 'eg3_2_anime.gif', 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
        end
        id = id + 1;
        t0 = t;
    end

    % plot final iteration result
    figure('Visible', 'off');
    plot(X, K * t, 'g-', x, y, 'bo');
    xlim([-2.8, 2.8]); ylim([-0.5, 1.2]);
    text(-2.7, 1.1, strcat('Iteration Count: ', num2str(id)));
    im = frame2im(getframe);
    [Data, map] = rgb2ind(im, 256);
    imwrite(Data, map, 'eg3_2_anime.gif', 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
end
%%
%% Result
% 
% <<eg3_2_anime.gif>>
% 
