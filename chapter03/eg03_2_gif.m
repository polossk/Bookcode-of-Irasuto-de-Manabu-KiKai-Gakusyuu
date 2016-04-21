%% Example 3.2 Basic Linear Regression with Stochastic Gradient Descent Method
%
% * *Result in book* : Figure 3.7
% * *Code in book* : Figure 3.8
% * *Output* : |eg03_2_C_anime.gif|
% * *Usage* : |eg03_2_gif(), eg03_2_gif(50, 1000)|
%
%% Source Code
function eg03_2_gif(n, N)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
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

    % iteration parameter
    hh = 2 * 0.3 * 0.3;
    K = exp(-(repmat(X .^ 2, 1, n) + repmat((x .^ 2)', N, 1) - 2 * X * x') / hh);
    t0 = randn(n, 1);
    e = 0.1;
    eps = 1e-6;
    id = 0;
    
    % frame id
    getRand = @(a, b, m)(unique(randi([a, b], 1, m)));
    frame = [1, getRand(2, 10, 8), getRand(11, 21, 2), ...
        getRand(22, 42, 3), getRand(43, 85, 3), getRand(86, 171, 4), ...
        getRand(182, 343, 5), getRand(344, 687, 7), getRand(688, 1375, 8), ...
        getRand(1376, 2750, 11), getRand(2751, 5500, 13), ...
        getRand(5501, 11000, 16), getRand(11001, 22000, 20) ...
    ];
    framelength = length(frame);

    % plot preparation
    figure('Name', 'example 3-2 Anime', 'Visible', 'off'); clf;
    title('Least Square Regression Example');
    plot(X, K * t0, 'g-', x, y, 'bo');
    xlim([-2.8, 2.8]); ylim([-0.5, 1.2]);
    text(-2.7, 1.1, strcat('Iteration Count: ', num2str(id)));
    im = frame2im(getframe);
    [Data, map] = rgb2ind(im, 256);
    imwrite(Data, map, 'eg03_2_C_anime.gif', 'gif', ...
        'Loopcount', 0, 'DelayTime', 0.05);
    id = id + 1;

    % iteration, plot data within iteration
    for o = 1 : n * 1000
        index = ceil(rand * n);
        ki = exp(-(x - x(index)) .^ 2 / hh);
        t = t0 - e * ki * (ki' * t0 - y(index));
        if norm(t - t0) < eps, break, end
        t0 = t;
        if (id > framelength), continue, end
        if (frame(id) == o)
            figure('Visible', 'off');
            plot(X, K * t, 'g-', x, y, 'bo');
            xlim([-2.8, 2.8]); ylim([-0.5, 1.2]);
            text(-2.7, 1.1, strcat('Iteration Count: ', num2str(frame(id))));
            im = frame2im(getframe);
            [Data, map] = rgb2ind(im, 256);
            imwrite(Data, map, 'eg03_2_C_anime.gif', 'gif', ...
                'WriteMode', 'append', 'DelayTime', 0.05);
            id = id + 1;
        end
    end

    % plot final iteration result
    figure('Visible', 'off');
    plot(X, K * t, 'g-', x, y, 'bo');
    xlim([-2.8, 2.8]); ylim([-0.5, 1.2]);
    text(-2.7, 1.1, strcat('Iteration Count: ', num2str(o)));
    im = frame2im(getframe);
    [Data, map] = rgb2ind(im, 256);
    imwrite(Data, map, 'eg03_2_C_anime.gif', 'gif', ...
        'WriteMode', 'append', 'DelayTime', 0.05);
end
%%
%% Result
% 
% <<eg03_2_C_anime.gif>>
% 
