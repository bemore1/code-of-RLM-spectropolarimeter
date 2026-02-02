tic



%% ====== 图像路径 ======
path_narrow = 'E:\20250110taper\1219 根据散斑判断入射光是宽谱还是窄带 基于0508的数据\0508 4 重新采\cs_490.png';
path_broad  = 'E:\20250110taper\1219 根据散斑判断入射光是宽谱还是窄带 基于0508的数据\0508 4 重新采\等待重建\rec_4.png';

%% ====== 参数 ======
win = 7;            % 局部窗口大小
roi_ratio = 0.6;    % 取中心 50% × 50% 区域

%% ====== 读取并预处理 ======
I1 = imread(path_narrow);
I2 = imread(path_broad);

if ndims(I1) == 3
    I1 = rgb2gray(I1);
end
if ndims(I2) == 3
    I2 = rgb2gray(I2);
end

I1 = double(I1);
I2 = double(I2);

%% ====== 中心 ROI 裁剪 ======
[H1, W1] = size(I1);
[H2, W2] = size(I2);

roiH1 = round(H1 * roi_ratio);
roiW1 = round(W1 * roi_ratio);
roiH2 = round(H2 * roi_ratio);
roiW2 = round(W2 * roi_ratio);

r1s = round((H1 - roiH1)/2) + 1;
r1e = r1s + roiH1 - 1;
c1s = round((W1 - roiW1)/2) + 1;
c1e = c1s + roiW1 - 1;

r2s = round((H2 - roiH2)/2) + 1;
r2e = r2s + roiH2 - 1;
c2s = round((W2 - roiW2)/2) + 1;
c2e = c2s + roiW2 - 1;

I1_roi = I1(r1s:r1e, c1s:c1e);
I2_roi = I2(r2s:r2e, c2s:c2e);

%% ====== 全局散斑对比度（ROI 内） ======
C1_global = std(I1_roi(:)) / mean(I1_roi(:));
C2_global = std(I2_roi(:)) / mean(I2_roi(:));

%% ====== 局部散斑对比度（ROI 内） ======
kernel = ones(win) / (win^2);

% 窄带
m1  = conv2(I1_roi, kernel, 'valid');
m12 = conv2(I1_roi.^2, kernel, 'valid');
std1 = sqrt(m12 - m1.^2);
C1_local = std1 ./ m1;
C1_avg = mean(C1_local(:));

% 宽谱
m2  = conv2(I2_roi, kernel, 'valid');
m22 = conv2(I2_roi.^2, kernel, 'valid');
std2 = sqrt(m22 - m2.^2);
C2_local = std2 ./ m2;
C2_avg = mean(C2_local(:));

%% ====== 结果输出 ======
fprintf('========== Speckle Contrast (Center ROI) ==========\n');
fprintf('Narrowband  : Global C = %.4f, Local C = %.4f\n', ...
        C1_global, C1_avg);
fprintf('Broadband   : Global C = %.4f, Local C = %.4f\n', ...
        C2_global, C2_avg);

%% ====== 可视化 ======
figure('Position',[200 200 1100 600]);

subplot(2,3,1);
imagesc(I1); axis image off;
title('Narrowband speckle');
colormap gray;
hold on;
rectangle('Position',[c1s, r1s, roiW1, roiH1], ...
          'EdgeColor','r','LineWidth',1.5);

subplot(2,3,2);
imagesc(I2); axis image off;
title('Broadband speckle');
colormap gray;
hold on;
rectangle('Position',[c2s, r2s, roiW2, roiH2], ...
          'EdgeColor','r','LineWidth',1.5);

subplot(2,3,4);
imagesc(I1_roi); axis image off;
title('Narrowband ROI');

subplot(2,3,5);
imagesc(I2_roi); axis image off;
title('Broadband ROI');

subplot(2,3,6);
imagesc(C1_local); axis image off;
title('Local contrast (ROI)');
colorbar;










% 设置图像文件夹路径
image_folder = 'E:\20250110taper\1219 根据散斑判断入射光是宽谱还是窄带 基于0508的数据\0508 4 重新采';  % ← 替换成你的实际文件夹路径
image_files = dir(fullfile(image_folder, '*.png'));



% 初始化存储矩阵
num_images = length(image_files);
image_size = [256, 320];
flattened_length = prod(image_size);  % 320*256 = 81920
all_images = zeros(flattened_length,num_images );  % 最终矩阵 480x81920


jidi = imread('E:\20250110taper\1219 根据散斑判断入射光是宽谱还是窄带 基于0508的数据\0508 4 重新采\cs_9.png');


% 遍历读取和处理图像
for i = 1:num_images
    img_path = fullfile(image_folder, image_files(i).name);
    img = imread(img_path);
    
%     % 如果是 RGB 图像，转换为灰度
%     if size(img, 3) == 3
%         img = rgb2gray(img);
%     end

    % 确保尺寸匹配
    if ~isequal(size(img), image_size)
        error('图像尺寸不是256x320: %s', image_files(i).name);
    end


%     img = img - jidi;

    % 列优先拉直并存入矩阵
    all_images(:, i) = img(:)';  % 注意是列向量形式写入
end

% all_images 是你要的 480×81920 矩阵
disp('图像处理完成，输出矩阵大小：');
disp(size(all_images));






figure(1);
imagesc(all_images);
colormap(hsv); 
colorbar;

all_images = all_images / max(max(all_images));

figure(11);
imagesc(all_images);
colormap(lines); 
colorbar;



% 目标光谱
pic1 = imread('E:\20250110taper\1219 根据散斑判断入射光是宽谱还是窄带 基于0508的数据\0508 4 重新采\等待重建\rec_1.png'); 
% pic1 = imread('E:\20250110taper\1219 根据散斑判断入射光是宽谱还是窄带 基于0508的数据\0508 4 重新采\等待重建\cs_250.png'); 



%%%%%%%%判断窄带还是宽谱
path  = 'E:\20250110taper\1219 根据散斑判断入射光是宽谱还是窄带 基于0508的数据\0508 4 重新采\等待重建\rec_1.png';
% path  = 'E:\20250110taper\1219 根据散斑判断入射光是宽谱还是窄带 基于0508的数据\0508 4 重新采\等待重建\cs_250.png';

%% ====== 参数 ======
win = 7;            % 局部窗口大小
roi_ratio = 0.6;    % 取中心 50% × 50% 区域

%% ====== 读取并预处理 ======
I1 = imread(path);

if ndims(I1) == 3
    I1 = rgb2gray(I1);
end

I1 = double(I1);


%% ====== 中心 ROI 裁剪 ======
[H1, W1] = size(I1);


roiH1 = round(H1 * roi_ratio);
roiW1 = round(W1 * roi_ratio);


r1s = round((H1 - roiH1)/2) + 1;
r1e = r1s + roiH1 - 1;
c1s = round((W1 - roiW1)/2) + 1;
c1e = c1s + roiW1 - 1;

I1_roi = I1(r1s:r1e, c1s:c1e);


%% ====== 全局散斑对比度（ROI 内） ======
C1_global = std(I1_roi(:)) / mean(I1_roi(:));


%% ====== 局部散斑对比度（ROI 内） ======
kernel = ones(win) / (win^2);


m1  = conv2(I1_roi, kernel, 'valid');
m12 = conv2(I1_roi.^2, kernel, 'valid');
std1 = sqrt(m12 - m1.^2);
C1_local = std1 ./ m1;
C1_avg = mean(C1_local(:));



%% ====== 结果输出 ======
fprintf('========== Speckle Contrast (Center ROI) ==========\n');
fprintf('Narrowband  : Global C = %.4f, Local C = %.4f\n', ...
        C1_global, C1_avg);



if C1_avg > 0.16    %窄带





% pic1 = pic1 - jidi;

pic1 = pic1(:);   pic1 = double(pic1);


nn = size(all_images,2);


% figure(2);
% plot(pic1/max(pic1));
% % plot(pic1);
% xlabel('通道');
% ylabel('强度');


pic1 = pic1/max(pic1);






 %一阶差分矩阵
d1= ones(1,nn-1);
D1 = diag(d1,1);
DD1=diag(-d1,0);
D1 = D1(1:nn-1,1:nn-1)+DD1;
buchong=zeros(nn-1,1);
buchong(nn-1)=1;
D1=[D1 buchong];

 %二阶差分矩阵
d2= ones(1,nn-4);
dd2=ones(1,nn-3);
ddd2=ones(1,nn-2);
D2 = diag(d2,2);
DD2=diag(-2*dd2,1);
DDD2=diag(ddd2,0);
D2 = D2+DD2+DDD2;
buchong2=zeros(nn-2,2);
buchong2(nn-3:nn-2,:)=[1 0;-2 1];
D2=[D2 buchong2];






cvx_clear 

cvx_begin;
    variable recon(nn) ;
%    minimize(norm(pic1 - all_images * recon,2) + 0.08 * norm(recon,1) + 70 * norm((D2 * recon), 2));%   kuanpu
   minimize(norm(pic1 - all_images * recon,2) + 20 * norm(recon,1) + 0.01 * norm((D2 * recon), 2));%   zhaidai
cvx_end;
recon = abs(recon) / max(abs(recon()));%
 

truespec = readmatrix('E:\20250110taper\1219 根据散斑判断入射光是宽谱还是窄带 基于0508的数据\0508 4 重新采\33333.CSV'); 
truespec1 = truespec(:, 1);  % 横坐标 
truespec1 = truespec1(25:10025);
truespec2 = truespec(:, 2);  % 纵坐标
truespec2 = truespec2(25:10025);


truespec2_linear = 10.^(truespec2 / 10);

truespec2_norm = (truespec2_linear - min(truespec2_linear)) / (max(truespec2_linear) - min(truespec2_linear));




index = find(truespec1 >= 1500 & truespec1 <= 1516);

% 提取对应的段
x_extract = truespec1(index);
y_extract = truespec2_norm(index);
x_shifted = x_extract + 100;
x_new = [truespec1; x_shifted];
y_new = [truespec2_norm; y_extract];


figure(3);
wavlen=length(recon);
plot(linspace(1500,1600,wavlen),recon(:));
hold on
plot(x_new, y_new);      % 绘图
















num_vectors = num_images;
signals = cell(1, num_vectors);  % 用 cell 数组存储每一行

for i = 1:num_vectors
    signals{i} = all_images(:, i);  % 提取第 i 行，大小为 1×81920
end


ref_signal = signals{1};  % 第一个作为参考信号

% figure(4);
% for i = 1:num_vectors
%     c(i) = corr2(signals{i}, ref_signal);  % 归一化互相关
% end
% 
%    plot(c);





truespec = readmatrix('E:\20250110taper\1219 根据散斑判断入射光是宽谱还是窄带 基于0508的数据\0508 4 重新采\33333.CSV'); 
truespec1 = truespec(:, 1);  % 横坐标 
truespec1 = truespec1(25:10025);
truespec2 = truespec(:, 2);  % 纵坐标
truespec2 = truespec2(25:10025);
truespec2_linear = 10.^(truespec2 / 10);
truespec2_norm = (truespec2_linear - min(truespec2_linear)) / (max(truespec2_linear) - min(truespec2_linear));
% figure;
% plot(truespec1,truespec2_norm);












else              %宽谱




pic1 = pic1(:);   pic1 = double(pic1);


nn = size(all_images,2);


% figure(2);
% plot(pic1/max(pic1));
% xlabel('通道');
% ylabel('强度');


pic1 = pic1/max(pic1);






 %一阶差分矩阵
d1= ones(1,nn-1);
D1 = diag(d1,1);
DD1=diag(-d1,0);
D1 = D1(1:nn-1,1:nn-1)+DD1;
buchong=zeros(nn-1,1);
buchong(nn-1)=1;
D1=[D1 buchong];

 %二阶差分矩阵
d2= ones(1,nn-4);
dd2=ones(1,nn-3);
ddd2=ones(1,nn-2);
D2 = diag(d2,2);
DD2=diag(-2*dd2,1);
DDD2=diag(ddd2,0);
D2 = D2+DD2+DDD2;
buchong2=zeros(nn-2,2);
buchong2(nn-3:nn-2,:)=[1 0;-2 1];
D2=[D2 buchong2];






cvx_clear 

cvx_begin;
    variable recon(nn) ;
   minimize(norm(pic1 - all_images * recon,2) + 0.08 * norm(recon,1) + 70 * norm((D2 * recon), 2));%   kuanpu
%    minimize(norm(pic1 - all_images * recon,2) + 20 * norm(recon,1) + 0.01 * norm((D2 * recon), 2));%   zhaidai
cvx_end;
recon = abs(recon) / max(abs(recon()));%

truespec = readmatrix('E:\20250110taper\1219 根据散斑判断入射光是宽谱还是窄带 基于0508的数据\0508 4 重新采\33333.CSV'); 
truespec1 = truespec(:, 1);  % 横坐标 
truespec1 = truespec1(25:10025);
truespec2 = truespec(:, 2);  % 纵坐标
truespec2 = truespec2(25:10025);



truespec2_linear = 10.^(truespec2 / 10);

truespec2_norm = (truespec2_linear - min(truespec2_linear)) / (max(truespec2_linear) - min(truespec2_linear));



index = find(truespec1 >= 1500 & truespec1 <= 1516);


x_extract = truespec1(index);
y_extract = truespec2_norm(index);
x_shifted = x_extract + 100;
x_new = [truespec1; x_shifted];
y_new = [truespec2_norm; y_extract];



figure(3);

wavlen=length(recon);
plot(linspace(1500,1600,wavlen),recon(:));
hold on
plot(x_new, y_new);      
















num_vectors = num_images;
signals = cell(1, num_vectors);  

for i = 1:num_vectors
    signals{i} = all_images(:, i);  
end


ref_signal = signals{1}; 

% figure(4);
% for i = 1:num_vectors
%     c(i) = corr2(signals{i}, ref_signal);  % 归一化互相关
% end
% 
%    plot(c);
















truespec = readmatrix('E:\20250110taper\1219 根据散斑判断入射光是宽谱还是窄带 基于0508的数据\0508 4 重新采\33333.CSV'); 
truespec1 = truespec(:, 1);  % 横坐标 
truespec1 = truespec1(25:10025);
truespec2 = truespec(:, 2);  % 纵坐标
truespec2 = truespec2(25:10025);
truespec2_linear = 10.^(truespec2 / 10);
truespec2_norm = (truespec2_linear - min(truespec2_linear)) / (max(truespec2_linear) - min(truespec2_linear));
% figure;
% plot(truespec1,truespec2_norm);




end























































































toc