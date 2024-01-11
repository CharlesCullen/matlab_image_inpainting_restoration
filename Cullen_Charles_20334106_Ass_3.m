close all
clear
%clear Please remember to uncomment this when you submit your code as an assignment submission.

% Read in the picture
original = double(imread('greece.tiff'));

% Read in the magic forcing function
load forcing;

% Read in the corrupted picture which contains holes
load badpicture;

% Read in an indicator picture which is 1 where the
% pixels are missing in badicture
badpixels = double(imread('badpixels.tiff'));

% Please initialise your variables here (see the instructions for the specific variable names)
% Initialise your iterations here ....
rest = badpic; % initialise the restored pictures to be the badpicture to start with
rest2 = badpic; % ... You need to initialise the other restored picture, and the error vectors as well

% This displays the original picture in Figure 1
figure(1);
image(original);
title('Original');
colormap(gray(256));
shg;

% Display the corrupted picture in Figure 2

badpic = imread('corrupted.tiff');
figure(2);
image(badpic);
title('Corrupted pic');
colormap(gray(256));
shg;
    
% Here is where you can do your picture iterations.
% To speed things up use "find" to find the locations of the missing pixels
[missing_pixel_row, missing_pixel_col] = find(badpixels == 1); % This stores all the locations in vectors i and j (row and column indices for each missing pixel)
% You might want to also store those locations in a different format
num_missing_pixels = length(missing_pixel_row);

iterations = 2000;

myerror = rand(1,num_missing_pixels);
orig = rand(1,num_missing_pixels);
err = rand(1,iterations);
err2 = rand(1,iterations);
iters_array = 1 : 1 : iterations;


for iters = 1 : iterations % but you have to replace this number with the variable you use for your total iterations
   % stuff goes here
   % you have to iterate over all the missing pixels (don't iterate over the whole image!) only
     % and at each location you update your restored image using the 2D FDM equation in the assignment description
     % Remember to index a pixel value in a picture "pic" at row 3 and column 4 its pic(3, 4) 
   % And when you get to the 20th iteration, you store your restored image in "restored20" 
   % And after each iteration you calculate the std devation between the original and restored images
   % but only in the location of the missing pixels!

    for pel = 1 : num_missing_pixels
        r = missing_pixel_row(pel);
        c = missing_pixel_col(pel);
        current = rest(r,c);
        
        update = ((rest(r - 1,c) + rest(r + 1,c) + rest(r,c - 1) ...
            + rest(r,c + 1) - (4 * (current))) / 4);
        rest(r,c) = current + update;
        
        myerror(pel) = rest(r,c);
        orig(pel) = original(r,c);
    end
    
    err(iters) = std(myerror - orig);
    
    if iters == 20
        restored20 = rest;
    end
end

% Display the restored image in Figure 3 (This does NOT use the forcing function)
figure(3);
image(rest);
title('Restored Picture');
colormap(gray(256));

% Now repeat the restoration, again starting from the badpicture, but now use the forcing function in your update
 
% stuff ...
% Remember to assign restored20_2 and err2

for iters = 1 : iterations
    for pel = 1 : num_missing_pixels
        r = missing_pixel_row(pel);
        c = missing_pixel_col(pel);
        current = rest2(r,c);
       
        update = ((rest2(r - 1,c) + rest2(r + 1,c) + rest2(r,c - 1) ...
            + rest2(r,c + 1) - (4 * (current)) + f(r,c)) / 4);
        rest2(r,c) = current + update;
        
        myerror(pel) = rest2(r,c);
        orig(pel) = original(r,c);
    end
    
    err2(iters) = std(myerror - orig);
    
    if iters == 20
        restored20_2 = rest2;
    end
end

% Display your restored image with forcing function as Figure 4
figure(4);
image(rest2);
title('Restored Picture forced');
colormap(gray(256));
shg;

% And plot your two error vectors versus iteration
figure(5);
% Fix this !!!
plot(iters_array, err, 'r-', iters_array, err2, 'b-', 'linewidth', 3);
legend('No forcing function', 'With forcing function');
xlabel('Iteration', 'fontsize', 20);
ylabel('Std Error', 'fontsize', 20);
shg;

