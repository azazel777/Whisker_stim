function varargout = stimulator(varargin)
% STIMULATOR MATLAB code for stimulator.fig
%      STIMULATOR, by itself, creates a new STIMULATOR or raises the existing
%      singleton*.
%
%      H = STIMULATOR returns the handle to a new STIMULATOR or the handle to
%      the existing singleton*.
%
%      STIMULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STIMULATOR.M with the given input arguments.
%
%      STIMULATOR('Property','Value',...) creates a new STIMULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stimulator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stimulator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stimulator

% Last Modified by GUIDE v2.5 14-Nov-2017 20:19:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stimulator_OpeningFcn, ...
                   'gui_OutputFcn',  @stimulator_OutputFcn, ...
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


% --- Executes just before stimulator is made visible.
function stimulator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stimulator (see VARARGIN)

% Choose default command line output for stimulator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stimulator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stimulator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in stim_stop.
function stim_stop_Callback(hObject, eventdata, handles)
% hObject    handle to stim_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stim_start.
function stim_start_Callback(hObject, eventdata, handles)
% hObject    handle to stim_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Creat working session
s = daq.createSession('ni');
addAnalogOutputChannel(s,'Dev1',0,'Voltage');
addAnalogInputChannel(s,'Dev1',[0 1],'Voltage');
s.Rate = 1000;

% Setting the data log settings
filename1=handles.mousename.String;
filename2=handles.mousenumber.String;
pathname=handles.mousepath.String;
savename=strcat(pathname,'\',filename1,'_',filename2,'.bin');
fid1 = fopen(savename,'w');
lh = addlistener(s,'DataAvailable',@(src, event)logData(src, event, fid1));


% Creat stimulation queue
stim_cyc=str2double(get(handles.cyc_num,'String'));
stim_epi=str2double(get(handles.epi_num,'String'));
stim_dur=str2double(get(handles.dura_num,'String'));
stim_intv=str2double(get(handles.int_num,'String'));
stim1=repmat(3,1,stim_dur);
stim2=zeros(1,stim_intv);
stim3=repmat([stim1 stim2],1,stim_epi);
stim4=repmat(stim3,1,stim_cyc);
stim4=stim4';

% Prepare to stimulation
queueOutputData(s,stim4);
set(handles.stim_stat,'String','Running')
s.startForeground();
set(handles.stim_stat,'String','Idle')
delete(lh);
fclose(fid1);







function cyc_num_Callback(hObject, eventdata, handles)
% hObject    handle to cyc_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cyc_num as text
%        str2double(get(hObject,'String')) returns contents of cyc_num as a double
input=str2double(get(hObject,'String'));
if isempty(input)
    set(hObject,'String','1');
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function cyc_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cyc_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epi_num_Callback(hObject, eventdata, handles)
% hObject    handle to epi_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epi_num as text
%        str2double(get(hObject,'String')) returns contents of epi_num as a double
input=str2double(get(hObject,'String'));
if isempty(input)
    set(hObject,'String','1');
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function epi_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epi_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dura_num_Callback(hObject, eventdata, handles)
% hObject    handle to dura_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dura_num as text
%        str2double(get(hObject,'String')) returns contents of dura_num as a double
input=str2double(get(hObject,'String'));
if isempty(input)
    set(hObject,'String','200');
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function dura_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dura_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function int_num_Callback(hObject, eventdata, handles)
% hObject    handle to int_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of int_num as text
%        str2double(get(hObject,'String')) returns contents of int_num as a double
input=str2double(get(hObject,'String'));
if isempty(input)
    set(hObject,'String','50');
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function int_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to int_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function stim_stat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function mousename_Callback(hObject, eventdata, handles)
% hObject    handle to mousename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mousename as text
%        str2double(get(hObject,'String')) returns contents of mousename as a double


% --- Executes during object creation, after setting all properties.
function mousename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mousename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mousenumber_Callback(hObject, eventdata, handles)
% hObject    handle to mousenumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mousenumber as text
%        str2double(get(hObject,'String')) returns contents of mousenumber as a double


% --- Executes during object creation, after setting all properties.
function mousenumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mousenumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mousepath_Callback(hObject, eventdata, handles)
% hObject    handle to mousepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mousepath as text
%        str2double(get(hObject,'String')) returns contents of mousepath as a double


% --- Executes during object creation, after setting all properties.
function mousepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mousepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in getpath.
function getpath_Callback(hObject, eventdata, handles)
% hObject    handle to getpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fp=uigetdir('C:\','Choose a directory to save data.');
set(handles.mousepath,'string',fp);
guidata(hObject, handles);

