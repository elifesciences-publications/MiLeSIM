%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file constructs the model to be used for prediction by using the labelled images generated by LabelObjects_BATCH.m
% The SVM model can then be used by ML_PredictWithModel.m and ML_PredictWithModel_BATCH.m
% 2016-07-07 Romain Laine rfl30@cam.ac.uk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialization
clear all;
close all;
clc

% User defined parameters -------------------------------------------------


Learners_names_selected = {'Area' 'AxisLengthRatio' 'Eccentricity' 'Solidity' 'Perim2Area_ratio' 'MeanIntensity' 'Std_pixel_values'...
    'Hu_IM1' 'Hu_IM4' 'Hu_IM5' 'Hu_IM6' 'Phi_4'...
    'AN1653' 'AN2859' 'AN4011' 'AN832' 'AN3486' 'AN2689'...
    'BoF22' 'BoF58' 'BoF95' 'BoF110' 'BoF177' 'BoF178'};

% Other options
Remove_unknown = 0;
Save_confusion_matrix = 1;
Save_model = 1;

Default_path = 'C:\Users\rfl30\DATA raw\SIM data\';


%% ------------------------------------------------------------------------
% Read in virus data with learners and classifiers


[Filename, Filepath] = uigetfile('*.xlsx','Choose an annotated descriptor file...',Default_path);

tic
disp('------------------------------');
disp('Reading data from spreadsheet...');
disp(fullfile(Filepath, Filename));
[Learners_values, annotation, ~] = xlsread(fullfile(Filepath, Filename),1);
toc

% Rename variables with the data and information
Learners_names = annotation(1,1:end-1);
annotation = annotation(2:end,end);
Learners_values = Learners_values(:,1:end);
n_learners = size(Learners_values,2);
disp(['Number of learners: ', num2str(n_learners)]);
disp(['Learners selected: ', Learners_names_selected]);
n_learners_selected = length(Learners_names_selected);



%%

if Remove_unknown == 1
    % Remove all unknown data points
    inds = ~strcmp(annotation,'Unknown');
    Learners_values = Learners_values(inds,:);
    annotation = annotation(inds);
end

% Get the list of classes
Class_list = unique(annotation);
n_classes = length(Class_list);
disp(['Number of classes: ',num2str(n_classes)]);
disp('Class list:');
disp(Class_list);


n_examples = size(annotation,1);
disp(['Number of examples: ', num2str(n_examples)]);



%%

Class_listPlot{1} = 'Filamentous';
Class_listPlot{2} = 'Small filamentous';
Class_listPlot{3} = 'Large spherical';
Class_listPlot{4} = 'Small spherical';
Class_listPlot{5} = 'Rod';
Class_listPlot{6} = 'Unknown';


ColorList{1} = [0 112 192]/255;
ColorList{2} = [0 176 240]/255;
ColorList{3} = [0 176 80]/255;
ColorList{4} = [169 209 142]/255;
ColorList{5} = [255 0 0]/255;
ColorList{6} = [0 0 0]/255;

FullOrNot{1} = 'filled';
FullOrNot{2} = 'filled';
FullOrNot{3} = 'filled';
FullOrNot{4} = 'filled';
FullOrNot{5} = 'filled';
FullOrNot{6} = 'filled';


x_label = 'Area';
y_label = 'AxisLengthRatio';

x_values = Learners_values(:, strcmp(Learners_names, x_label));
y_values = Learners_values(:, strcmp(Learners_names, y_label));

figure('color','white', 'units', 'centimeters', 'position', [3 3 5.5 4.5]);
for i = 1:n_classes
    scatter(x_values(strcmp(annotation,Class_listPlot{i})),y_values(strcmp(annotation,Class_listPlot{i})),[], ColorList{i}, FullOrNot{i});
    hold on
end

% scatter(x_values,y_values);
grid on
xlabel(x_label);
% ylabel 'Hu''s image moment #1';
ylabel(y_label);
ylabel 'Ratio of axes length';
% xlim([-25 600])
% ylim([0.5 8])




disp('-----------------------------');
disp('All done.');




