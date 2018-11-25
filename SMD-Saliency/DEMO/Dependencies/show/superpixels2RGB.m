function RGBLabel = superpixels2RGB(labelImg)

    labs = unique(labelImg);
    newLabelImg =labelImg;
    newLabs= randperm(length(labs));
    for i = 1:length(labs)
        newLabelImg( labelImg==labs(i) ) = newLabs(i);
    end
    RGBLabel = label2rgb(newLabelImg, 'jet', 'w', 'shuffle');
    %imshow(RGBLabel,[]);
end