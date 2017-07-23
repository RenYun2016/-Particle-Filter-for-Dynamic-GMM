close all; clear;
tic
VIDEO_DIR = strcat(pwd,'\videos\');
Video_name = '0001.avi';
obj=VideoReader([VIDEO_DIR Video_name]);   
aviobj = VideoWriter(['heatmap_',Video_name]);
aviobj.FrameRate = obj.FrameRate;
open(aviobj);

EYEDATA_DIR=strcat(pwd,'\fixations\');
load(fullfile(EYEDATA_DIR,[Video_name(3:end-4),'.mat']));%eyedata

load(fullfile(pwd,'\framenum.mat'));%framenum
videoNum = str2num(Video_name(3:end-4));
numFrames=framenum(videoNum);
FrameRate=obj.FrameRate;

 color_map=colormap(jet(256));
 vidFrames=read(obj);
 for k=1:numFrames
    if (isnan(eyedata{k})==0) 
        mov(k).cdata = vidFrames(:,:,:,k);
        mov(k).colormap = [];
        x=int32(eyedata{k}(1,:));
        y=int32(eyedata{k}(2,:));
        fixmaptemp= make_gauss_masks2(x,y,[720 1280]); 
        fixmaps(:,:,k)=fixmaptemp;
        [heatposrow,heatposcol]=find(fixmaptemp>0.5);
   
        for i=1:length(heatposrow)
        map_index=round(fixmaptemp(heatposrow(i),heatposcol(i))*255)+1;
        mov(k).cdata(heatposrow(i),heatposcol(i),:)=round(color_map(map_index,:)*255);
        end
    
    mov(k).colormap = [];
    writeVideo(aviobj, mov(k).cdata);  
    end
 end
close(aviobj);
