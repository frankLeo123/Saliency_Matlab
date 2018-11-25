function [ slic_img_ ] = selectDecend( img,H_channel,S_channel,I_channel )
[img_weigh, img_height,dim] = size(img);
    split_num = 10.0;
    split_num_w = floor(img_weigh / split_num);
    split_num_h = floor(img_height / split_num);
    
    slic_split = zeros(img_weigh,img_height);
    slic_img_ = zeros(img_weigh,img_height);
    
    for i= 0:split_num-1
        for j = 0:split_num-1
            din_x = i*split_num_w + 1;
            din_y = j*split_num_h + 1;
            if i == split_num-1 && j ~= split_num-1
                h_split = H_channel(din_x : img_weigh-1, din_y : din_y + split_num_h);
                s_split = S_channel(din_x : img_weigh-1, din_y : din_y + split_num_h);
                i_split = I_channel(din_x : img_weigh-1, din_y : din_y + split_num_h);
            elseif j == split_num-1 && i ~= split_num-1
                h_split = H_channel(din_x : din_x + split_num_w, din_y : img_height-1);
                s_split = S_channel(din_x : din_x + split_num_w, din_y : img_height-1);
                i_split = I_channel(din_x : din_x + split_num_w, din_y : img_height-1);
            elseif j == split_num-1 && i == split_num-1
                h_split = H_channel(din_x : img_weigh-1, din_y : img_height-1);
                s_split = S_channel(din_x : img_weigh-1, din_y : img_height-1);
                i_split = I_channel(din_x : img_weigh-1, din_y : img_height-1);
            else
                h_split = H_channel(din_x : din_x + split_num_w, din_y : din_y + split_num_h);
                s_split = S_channel(din_x : din_x + split_num_w, din_y : din_y + split_num_h);
                i_split = I_channel(din_x : din_x + split_num_w, din_y : din_y + split_num_h);
            end;
            [split_w,split_h] = size(h_split);
            decent_h = 0;
            decent_s = 0;
            decent_i = 0;
            flag =2;
            for ii = 2: split_w-1
                for jj = 2:split_h-1
                    decent_h = decent_h + abs(h_split(ii,jj) - h_split(ii-1,jj-1)) + abs(h_split(ii,jj) - h_split(ii,jj-1))+abs(h_split(ii,jj) - h_split(ii+1,jj-1))...
                        + abs(h_split(ii,jj) - h_split(ii-1,jj)) + abs(h_split(ii,jj) - h_split(ii+1,jj)) + abs(h_split(ii,jj) - h_split(ii-1,jj+1))...
                        + abs(h_split(ii,jj) - h_split(ii,jj+1))+ abs(h_split(ii,jj) - h_split(ii+1,jj+1));
                    decent_s = decent_s + abs(s_split(ii,jj) - s_split(ii-1,jj-1)) + abs(s_split(ii,jj) - s_split(ii,jj-1))+abs(s_split(ii,jj) - s_split(ii+1,jj-1))...
                        + abs(s_split(ii,jj) - s_split(ii-1,jj)) + abs(s_split(ii,jj) - s_split(ii+1,jj)) + abs(s_split(ii,jj) - s_split(ii-1,jj+1))...
                        + abs(s_split(ii,jj) - s_split(ii,jj+1))+ abs(s_split(ii,jj) - s_split(ii+1,jj+1));
                    decent_i = decent_i + abs(i_split(ii,jj) - i_split(ii-1,jj-1)) + abs(i_split(ii,jj) - i_split(ii,jj-1))+abs(i_split(ii,jj) - i_split(ii+1,jj-1))...
                        + abs(i_split(ii,jj) - i_split(ii-1,jj)) + abs(i_split(ii,jj) - i_split(ii+1,jj)) + abs(i_split(ii,jj) - i_split(ii-1,jj+1))...
                        + abs(i_split(ii,jj) - i_split(ii,jj+1))+ abs(i_split(ii,jj) - i_split(ii+1,jj+1));
                end;
            end;
            decent_max = max(decent_h,max(decent_s,decent_i));
            num_slic_single = round(250/(split_num*split_num) );
            if decent_max == decent_h
                flag = 0;
                %             [sp_res_slic,N_slic] = superpixels(h_split,num_slic_single,'Method','slic0','Compactness',20);
            elseif decent_max == decent_s
                flag = 1;
                %             [sp_res_slic,N_slic] = superpixels(s_split,num_slic_single,'Method','slic0','Compactness',20);
            else
                flag = 2;
                %             [sp_res_slic,N_slic] = superpixels(i_split,num_slic_single,'Method','slic0','Compactness',20);
            end;
            
            %   ºÏ³Éslic
            for ii = 1:split_w
                for jj = 1:split_h
                    %                 slic_split(din_x+ ii,din_y+jj) = sp_res_slic(ii,jj);
                    if flag == 0
                        slic_img_(din_x+ ii,din_y+jj) = h_split(ii,jj);
                    elseif flag == 1
                        slic_img_(din_x+ ii,din_y+jj) = s_split(ii,jj);
                    else
                        slic_img_(din_x+ ii,din_y+jj) = i_split(ii,jj);
                    end;
                    
                end;
            end;
            % figure;
            % imshow(i_split);
            %         figure;
            % h_split = h_split*255;
            
        end;
    end;