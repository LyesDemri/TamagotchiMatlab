function varargout = TamagotchiGUI(varargin)
% TAMAGOTCHIGUI M-file for TamagotchiGUI.fig
%      TAMAGOTCHIGUI, by itself, creates a new TAMAGOTCHIGUI or raises the existing
%      singleton*.
%
%      H = TAMAGOTCHIGUI returns the handle to a new TAMAGOTCHIGUI or the handle to
%      the existing singleton*.
%
%      TAMAGOTCHIGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TAMAGOTCHIGUI.M with the given input arguments.
%
%      TAMAGOTCHIGUI('Property','Value',...) creates a new TAMAGOTCHIGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TamagotchiGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TamagotchiGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TamagotchiGUI

% Last Modified by GUIDE v2.5 14-Dec-2020 15:20:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TamagotchiGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TamagotchiGUI_OutputFcn, ...
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


% --- Executes just before TamagotchiGUI is made visible.
function TamagotchiGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TamagotchiGUI (see VARARGIN)

% Choose default command line output for TamagotchiGUI
handles.output = hObject;
clc
if exist('tmgc_save.mat','file')
    load('tmgc_save.mat');
    UserData.care_misses;
    UserData.state = 'idle';
    UserData.icon_number = 0;
    open_time = clock;
    seconds_passed = round(etime(open_time,UserData.last_closed_date));
    UserData.current_time = UserData.last_closed_date;
    if UserData.is_alive
        catch_up_quicker;
    end
    if UserData.egg
        UserData.state = 'egg';
    end
    if ~UserData.is_alive
        UserData.state='dead';
    end
else
    disp('Creating a new tamagotchi');
    UserData.t=0;

    %Tamagotchi status:
    UserData.character = 'Babytchi';
    UserData.egg = true;
    UserData.stomach=0;
    UserData.happy=0;
    UserData.weight=5;
    UserData.discipline=0;
    UserData.age=0;

    %Tamagotchi's hidden variables:
    UserData.time_to_evolve =70*60;
    UserData.time_to_poop = Inf;
    UserData.sleeping_hour = 30;
    UserData.waking_hour = 40;
    UserData.time_since_last_pooped=0;
    UserData.time_since_hungry_changed=0;
    UserData.time_since_happy_changed=0;
    UserData.time_to_lose_stomach_heart = 3*60;
    UserData.time_to_lose_happy_heart = 4*60;
    UserData.sick = false;
    UserData.sleeping = false;
    UserData.lights_on = true;
    UserData.needs_discipline = false;
    UserData.time_since_hungry=0;
    UserData.time_since_unhappy=0;
    UserData.time_since_dirty = 0;
    UserData.time_since_needs_discipline = 0;
    UserData.time_since_needs_lights_off = 0;
    UserData.time_since_sick = 0;
    UserData.care_misses = 0;
    UserData.time_since_last_discipline_call = 0;
    UserData.base_weight = 5;
    UserData.walks = true;
    UserData.happy_step=0;
    UserData.old_state = 'idle';
    UserData.is_alive = true;

    %Load graphics and sounds
    load_graphics;
    load_sounds;

    %System variables:
    UserData.even=0;
    UserData.position=[9,12];
    UserData.icon_number=0;
    UserData.counting_icon_time = true;
    UserData.icons={'Food';'Lights';'Game';'Medicine';'Toilet';'Status';'Discipline'};
    UserData.time_since_icon_lit=0;
    UserData.counting_icon_time = true;
    UserData.poop_number = 0;
    UserData.zmar = 0;
    UserData.current_hour = 12;
    UserData.current_minutes = 00;
    UserData.dirty = false;
    UserData.time_to_get_sick_due_to_age = 1036800;
    UserData.time_since_called = 0;
    UserData.time_since_last_aged = -Inf;

    UserData.state = 'egg';
    wavplay(UserData.reset_sound,Fs,'async');
    
end


%Matlab Timer code
time_step=0.5;
UserData.time_step = time_step;
UserData.hObject = hObject;
UserData.handles = handles;


mytimer = timer('TimerFcn', @MyTimerFcn);
set(mytimer,'UserData',UserData);
mytimer.ExecutionMode = 'fixedRate';
mytimer.Period=time_step;
start(mytimer);

UserData.resetting = false;

%Save data within window data:
UserData.mytimer = mytimer;
handles.Data = UserData;
% Update handles structure
guidata(hObject, handles);


% UIWAIT makes TamagotchiGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TamagotchiGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handle_button_A;

function pushbutton1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
Data = handles.Data;
UserData = Data.mytimer.UserData;

if strcmp(eventdata.Key,'a') ||strcmp(eventdata.Key,'leftarrow')
    handle_button_A;
elseif strcmp(eventdata.Key,'z') || strcmp(eventdata.Key,'downarrow')
    handle_button_B;
elseif strcmp(eventdata.Key,'e') || strcmp(eventdata.Key,'rightarrow')
    handle_button_C;
end

Data.mytimer.UserData = UserData;
handles.Data = Data;
guidata(hObject,handles)

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handle_button_B;

function pushbutton2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
Data = handles.Data;
UserData = Data.mytimer.UserData;

if strcmp(eventdata.Key,'a') ||strcmp(eventdata.Key,'leftarrow')
    handle_button_A;
elseif strcmp(eventdata.Key,'z') || strcmp(eventdata.Key,'downarrow')
    handle_button_B;
elseif strcmp(eventdata.Key,'e') || strcmp(eventdata.Key,'rightarrow')
    handle_button_C;
end

Data.mytimer.UserData = UserData;
handles.Data = Data;
guidata(hObject,handles)

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handle_button_C;

function pushbutton3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
Data = handles.Data;
UserData = Data.mytimer.UserData;

if strcmp(eventdata.Key,'a') ||strcmp(eventdata.Key,'leftarrow')
    handle_button_A;
elseif strcmp(eventdata.Key,'z') || strcmp(eventdata.Key,'downarrow')
    handle_button_B;
elseif strcmp(eventdata.Key,'e') || strcmp(eventdata.Key,'rightarrow')
    handle_button_C;
end

Data.mytimer.UserData = UserData;
handles.Data = Data;
guidata(hObject,handles)

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mytimer = handles.Data.mytimer;
Data = handles.Data;
UserData = Data.mytimer.UserData;
UserData.last_closed_date = clock;
if UserData.is_alive
    predict_future;
    save('tmgc_save.mat','UserData');
    disp('Saved successfully.')
else
    delete tmgc_save.mat;
end
disp('Leaving the game... Don''t forget to come back!')
stop(mytimer);
delete(mytimer);

% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
Data = handles.Data;
UserData = Data.mytimer.UserData;

if strcmp(eventdata.Key,'a') ||strcmp(eventdata.Key,'leftarrow')
    handle_button_A;
elseif strcmp(eventdata.Key,'z') || strcmp(eventdata.Key,'downarrow')
    handle_button_B;
elseif strcmp(eventdata.Key,'e') || strcmp(eventdata.Key,'rightarrow')
    handle_button_C;
end

Data.mytimer.UserData = UserData;
handles.Data = Data;
guidata(hObject,handles)

% --------------------------------------------------------------------
function save_uipushtool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to save_uipushtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mytimer = handles.Data.mytimer;
Data = handles.Data;
UserData = Data.mytimer.UserData;
UserData.last_closed_date = clock;
if UserData.is_alive
    predict_future;
    save('tmgc_save.mat','UserData');
    disp('Saved successfully.')
else
    delete tmgc_save.mat;
end

% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% --------------------------------------------------------------------
function Instructions_Callback(hObject, eventdata, handles)
% hObject    handle to Instructions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myHelp=msgbox({'Instructions:',...
                'Plays (almost) like a regular P2 Tamagotchi',...
                'You will find a basic explanation of how to play in the scans joined with this program',...
                '(Thanks to user Binary from Tamatalk for the scans)',...
                'www.tamatalk.com',...
                '',...
                'You can use the left, down and right arrows for buttons A, B and C respectively',...
                '',...
                'Tamagotchi resets automatically after your tamagotchi dies',...
                'If you''re seeing the death screen, your tamagotchi will be reset next time you re-open the game',...
                '',...
                'The game auto-saves everytime you leave, but you can save the game by clicking the save icon. This feature is mostly here in case you are afraid to lose your progress to some unexpected event.'},...
                'Help',...
                'modal');

% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myMsgBox=msgbox({'Made by L.Demri',...
                 'No copyright infringement intended',...
                 'Every character except one belongs to Bandai',...
                 'Purchase a real tamagotchi here:',...
                 'https://www.bandai.com/brands/tamagotchi/original-tamagotchi/',...
                 'E-mail:ldemri1987@hotmail.fr'},...
                 'About...',...
                 'modal');


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Data = handles.Data;
UserData = Data.mytimer.UserData;

UserData.is_alive=false;

Data.mytimer.UserData = UserData;
handles.Data = Data;
guidata(hObject,handles)

closereq();
