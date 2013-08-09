function varargout = wtg_gui(varargin)
% WTG_GUI MATLAB code for wtg_gui.fig
%      WTG_GUI, by itself, creates a new WTG_GUI or raises the existing
%      singleton*.
%
%      H = WTG_GUI returns the handle to a new WTG_GUI or the handle to
%      the existing singleton*.
%
%      WTG_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WTG_GUI.M with the given input arguments.
%
%      WTG_GUI('Property','Value',...) creates a new WTG_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wtg_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wtg_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wtg_gui

% Last Modified by GUIDE v2.5 09-Aug-2013 12:32:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wtg_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @wtg_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before wtg_gui is made visible.
function wtg_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wtg_gui (see VARARGIN)

% Choose default command line output for wtg_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wtg_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%Add library paths
addpath ./src/lib/cqt_toolbox
addpath ./src/lib/k-svd
addpath ./src/lib/fast-additive-svms
addpath ./src/lib/fast-additive-svms/libsvm-mat-3.0-1
% K-SVD implementation from Ron Rubinstein
addpath ./src/lib/ompbox10
addpath ./src/lib/ksvdbox13


% --- Outputs from this function are returned to the command line.
function varargout = wtg_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in get_genre_btn.
function get_genre_btn_Callback(hObject, eventdata, handles)
% hObject    handle to get_genre_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    classify(handles)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_audio_file_tb_btn_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to open_audio_file_tb_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    openFile(handles)


function file_path_edit_text_Callback(hObject, eventdata, handles)
% hObject    handle to file_path_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_path_edit_text as text
%        str2double(get(hObject,'String')) returns contents of file_path_edit_text as a double


% --- Executes during object creation, after setting all properties.
function file_path_edit_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_path_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in open_audio_btn.
function open_audio_btn_Callback(hObject, eventdata, handles)
% hObject    handle to open_audio_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    openFile(handles)

% --- Executes on selection change in audio_feature_popup.
function audio_feature_popup_Callback(hObject, eventdata, handles)
% hObject    handle to audio_feature_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns audio_feature_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from audio_feature_popup


% --- Executes during object creation, after setting all properties.
function audio_feature_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to audio_feature_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function openFile(handles)
    fileSpec = {'*.mp3;*.au'}
    [baseName, folder] = uigetfile(fileSpec,'Select audio file to open.');
    filename = fullfile(folder, baseName)
    if filename ~= 0
        set(handles.file_path_edit_text,'string', filename);
    end
    
function classify(handles)
    filePath = get(handles.file_path_edit_text,'string');
    features = getFeatures(filePath, handles)
    histogram = getHistogram(features)
    
function [histogram] = getHistogram(features)
    histogram


function [features] = getFeatures(filePath, handles)
    audio_feature = getCurrentPopupString(handles.audio_feature_popup)
    features = [];
    if strcmp(audio_feature, 'Spectrogram') == 1;
        features = get_spec_from_audio(filePath,'norm');
    elseif strcmp(audio_feature, 'CQT') == 1;
        features = get_cqt_from_audio(filePath);
    else
        error('Audio feature not supported.')
    end
    features
    
function str = getCurrentPopupString(hh)
    %# getCurrentPopupString returns the currently selected string in the popupmenu with handle hh

    %# could test input here
    if ~ishandle(hh) || strcmp(get(hh,'Type'),'popupmenu')
    error('getCurrentPopupString needs a handle to a popupmenu as input')
    end

    %# get the string - do it the readable way
    list = get(hh,'String');
    val = get(hh,'Value');
    if iscell(list)
       str = list{val};
    else
       str = list(val,:);
    end
    
