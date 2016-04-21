%% Example 10.1 Logistic Regression
%
% * *Result in book* : Figure 10.2
% * *Code in book* : Figure 10.3
% * *Output* : |eg10_1_C_anime.gif|
% * *Usage* : |eg10_1_gif(), eg10_1_gif(90, 3, 100)|
%
%% Source Code
function eg10_1_gif(n, c, N)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 3
        n = 90; c = 3; N = 100;
    end
    y = ones(n / c, 1) * (1 : c);
    y = y(:);
    x = randn(n / c, c) + repmat(linspace(-3, 3, c), n / c, 1);
    x = x(:);
    hh = 2 * 1 ^ 2;
    t0 = randn(n, c); t = t0;

    X = linspace(-5, 5, N )';
    x2 = x .^ 2;
    X2 = X .^ 2;
    K = exp(-(repmat(X2, 1, n) + repmat(x2', N, 1) - 2 * X * x') / hh);
    C = exp(K * t);
    C = C ./ repmat(sum(C, 2), 1, c);

    % frame id
    id = 1;
    getRand = @(a, b, m)(unique(randi([a, b], 1, m)));
    frame = [1, getRand(2, 10, 8), getRand(11, 21, 2), ...
        getRand(22, 42, 3), getRand(43, 85, 3), getRand(86, 171, 4), ...
        getRand(182, 343, 5), getRand(344, 687, 7), getRand(688, 1375, 8), ...
        getRand(1376, 2750, 11), getRand(2751, 5500, 13), ...
        getRand(5501, 11000, 16), getRand(11001, 22000, 20) ...
    ];
    framelength = length(frame);

    % plot preparation
    figure('Name', 'example 10-2 Anime', 'Visible', 'off'); clf;
    plot(X, C(:, 1), 'm-', X, C(:, 2 ), 'r-', X, C(:, 3), 'b-.', ...
        x(y == 1), -0.1 * ones(n / c, 1), 'mo', ...
        x(y == 2), -0.2 * ones(n / c, 1), 'rx', ...
        x(y == 3), -0.1 * ones(n / c, 1), 'bv');
    legend('q(y = 1|x)', 'q(y = 2|x)', 'q(y = 3|x)');
    xlim([-5, 5]); ylim([-0.3, 1.8]);
    text(-4.9, 1.7, strcat('Iteration Count: ', num2str(id)));
    im = frame2im(getframe);
    [Data, map] = rgb2ind(im, 256);
    imwrite(Data, map, 'eg10_1_C_anime.gif', 'gif', ...
        'Loopcount', 0, 'DelayTime', 0.05);
    id = id + 1;

    for o = 1 : n * 1000
        ii = ceil(rand * n);
        yi = y(ii);
        ki = exp(-(x - x(ii)) .^ 2 / hh);
        ci = exp(ki' * t0);
        t = t0 - 0.1 * (ki * ci) / (1 + sum(ci));
        t(:, yi) = t(:, yi) + 0.1 * ki;
        if norm(t - t0) < 0.000001, break, end
        t0 = t;
        if (id > framelength), continue, end
        if (frame(id) == o)
            C = exp(K * t);
            C = C ./ repmat(sum(C, 2), 1, c);
            figure('Visible', 'off');
            plot(X, C(:, 1), 'm-', X, C(:, 2 ), 'r-', X, C(:, 3), 'b-.', ...
                x(y == 1), -0.1 * ones(n / c, 1), 'mo', ...
                x(y == 2), -0.2 * ones(n / c, 1), 'rx', ...
                x(y == 3), -0.1 * ones(n / c, 1), 'bv');
            legend('q(y = 1|x)', 'q(y = 2|x)', 'q(y = 3|x)');
            xlim([-5, 5]); ylim([-0.3, 1.8]);
            text(-4.9, 1.7, strcat('Iteration Count: ', num2str(frame(id))));
            im = frame2im(getframe);
            [Data, map] = rgb2ind(im, 256);
            imwrite(Data, map, 'eg10_1_C_anime.gif', 'gif', ...
                'WriteMode', 'append', 'DelayTime', 0.05);
            id = id + 1;
        end
    end

    % plot final iteration result
    C = exp(K * t);
    C = C ./ repmat(sum(C, 2), 1, c);
    figure('Visible', 'off');
    plot(X, C(:, 1), 'm-', X, C(:, 2 ), 'r-', X, C(:, 3), 'b-.', ...
        x(y == 1), -0.1 * ones(n / c, 1), 'mo', ...
        x(y == 2), -0.2 * ones(n / c, 1), 'rx', ...
        x(y == 3), -0.1 * ones(n / c, 1), 'bv');
    legend('q(y = 1|x)', 'q(y = 2|x)', 'q(y = 3|x)');
    xlim([-5, 5]); ylim([-0.3, 1.8]);
    text(-4.9, 1.7, strcat('Iteration Count: ', num2str(o)));
    im = frame2im(getframe);
    [Data, map] = rgb2ind(im, 256);
    imwrite(Data, map, 'eg10_1_C_anime.gif', 'gif', ...
        'WriteMode', 'append', 'DelayTime', 0.05);
end
%%
%% Result
% 
% <<eg10_1_C_anime.gif>>
% 