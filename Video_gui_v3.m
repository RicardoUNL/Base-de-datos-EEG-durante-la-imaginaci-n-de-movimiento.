function varargout = Video_gui_v3(varargin)

% Last Modified by GUIDE v2.5 12-Jul-2023 11:33:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Video_gui_v3_OpeningFcn, ...
                   'gui_OutputFcn',  @Video_gui_v3_OutputFcn, ...
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


% --- Executes just before Video_gui_v3 is made visible.
function Video_gui_v3_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;


%% AZUL
global azul
azul=zeros(800,700,3);

%% Cargar Base_der, Base_Izq
global base_der
global base_izq

v1=VideoReader('C:\Users\jimyd\Desktop\RICARDO\TITULACION\INTERFAZ\Interfaz_V3\hombro_izq.avi');
v2=VideoReader('C:\Users\jimyd\Desktop\RICARDO\TITULACION\INTERFAZ\Interfaz_V3\hombro_der.avi');
Izq_ancho = v1.Width;
Izq_alto = v1.Height;
base_der = struct('cdata',zeros(Izq_alto,Izq_ancho,3,'uint8'),'colormap',[]);
base_izq = struct('cdata',zeros(Izq_alto,Izq_ancho,3,'uint8'),'colormap',[]);
k = 1;
while hasFrame(v1)
    aux=readFrame(v1);
    aux=aux(:,210:609,:);
    aux=imresize(aux,[915 802]);
    base_izq(k).cdata = aux;
    k = k+1;
end

k = 1;
while hasFrame(v2)
    aux2=readFrame(v2);
    aux2=flip(aux2,2);
    aux2=aux2(:,210:609,:);
    aux2=imresize(aux2,[915 802]);
    base_der(k).cdata = aux2;
     k = k+1;
end

clear v1 v2 Izq_ancho Izq_alto k aux aux2


%% Cargar Pulgar_der y Pulgar_izq
global pulgar_der
global pulgar_izq
v1=VideoReader('C:\Users\jimyd\Desktop\RICARDO\TITULACION\INTERFAZ\Interfaz_V3\mano_der.avi');
v2=VideoReader('C:\Users\jimyd\Desktop\RICARDO\TITULACION\INTERFAZ\Interfaz_V3\mano_izq.avi');
Izq_ancho = v1.Width;
Izq_alto = v1.Height;
pulgar_der = struct('cdata',zeros(Izq_alto,Izq_ancho,3,'uint8'),'colormap',[]);
pulgar_izq = struct('cdata',zeros(Izq_alto,Izq_ancho,3,'uint8'),'colormap',[]);
k = 1;
while hasFrame(v1)
    aux=readFrame(v1);
    aux=imresize(aux,[915 802]);
    pulgar_der(k).cdata = aux;
     k = k+1;
end

k = 1;
while hasFrame(v2)
    aux2=readFrame(v2);
    aux2=flip(aux2,2);
    aux2=imresize(aux2,[915 802]);
    pulgar_izq(k).cdata = aux2;
     k = k+1;
end


clear v1 v2 Izq_ancho Izq_alto k aux


%% Cargar Kick_der y Kick_izq
global kick_der
global kick_izq
v1=VideoReader('C:\Users\jimyd\Desktop\RICARDO\TITULACION\INTERFAZ\Interfaz_V3\patada_izq.avi');
v2=VideoReader('C:\Users\jimyd\Desktop\RICARDO\TITULACION\INTERFAZ\Interfaz_V3\patada_der.avi');
Izq_ancho = v1.Width;
Izq_alto = v1.Height;
kick_der = struct('cdata',zeros(Izq_alto,Izq_ancho,3,'uint8'),'colormap',[]);
kick_izq = struct('cdata',zeros(Izq_alto,Izq_ancho,3,'uint8'),'colormap',[]);
k = 1;
while hasFrame(v1)
    aux=readFrame(v1);
    kick_izq(k).cdata = imresize(aux(1:end-80,150:550,:),[915 802]);
    k = k+1;
end

k = 1;
while hasFrame(v2)
    aux=readFrame(v2);
    aux=flip(aux,2);
    kick_der(k).cdata = imresize(aux(1:end-80,240:640,:),[915 802]);
    k = k+1;
end

clear v1 v2 Izq_ancho Izq_alto k aux

guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Video_gui_v3_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--- Executes on button press in inicio.
function inicio_Callback(hObject, eventdata, handles)
global azul
global base_der
global base_izq
global pulgar_izq
global pulgar_der
global kick_izq
global kick_der

% Configuración de la comunicación serial con Arduino
% Crear objeto para la comunicación serial con Arduino
arduinoPort = 'COM3'; % Puerto serie al que está conectado Arduino
outputPin1 = 'D7'; % Pin digital de salida conectado al osciloscopio
a = arduino(arduinoPort, 'Uno');
configurePin(a, outputPin1, 'DigitalOutput');
cont=0;
tic;
tiempo_grabacion=300;
    while toc< tiempo_grabacion
        aux=randi([1 6]);
        cont=cont+1;
        time_left= round((tiempo_grabacion-toc/60),2);
        timep=num2str(time_left,'%20.2f');
        set(handles.text4, 'String', timep);        
        set(handles.text4, 'Visible', 'off');
        set(handles.text6, 'Visible', 'off');
        pause(0.1)
        switch aux
            case 1
              
                writeDigitalPin(a, outputPin1, 1); % Encender el pin 7 de salida 
                movie(handles.axes1,base_izq,1,25);
                axes(handles.axes1)
                imshow(azul);
                writeDigitalPin(a, outputPin1, 0); % Apagar el pin 7 de salida
                pause(2);
                
            case 2
              
                writeDigitalPin(a, outputPin1, 1); % Encender el pin 6 de salida
                writeDigitalPin(a, outputPin1, 0); % Apagar el pin 6 de salida
                pause(0.4);
                writeDigitalPin(a, outputPin1, 1); % Encender el pin 6 de salida
                movie(handles.axes2,base_der,1,25);
                axes(handles.axes2)
                imshow(azul);
                writeDigitalPin(a, outputPin1, 0); % Apagar el pin de salida
                pause(2);
                
            case 3
                
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida 
                writeDigitalPin(a, outputPin1, 0); % Encender el pin de salida 
                pause(0.4);
                writeDigitalPin(a, outputPin1, 1); % Encender el pin de salida 
                writeDigitalPin(a, outputPin1, 0); % Encender el pin de salida 
                pause(0.4);   
                writeDigitalPin(a, outputPin1, 1); % Encender el pin de salida
                movie(handles.axes1,pulgar_izq,1,25);
                axes(handles.axes1)
                imshow(azul);
                writeDigitalPin(a, outputPin1, 0); % Encender el pin  de salida 
                pause(2);
                
            case 4
               
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida 
                writeDigitalPin(a, outputPin1, 0); % Encender el pin  de salida 
                pause(0.2);
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida 
                writeDigitalPin(a, outputPin1, 0); % Encender el pin  de salida 
                pause(0.2);
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida 
                writeDigitalPin(a, outputPin1, 0); % Encender el pin  de salida 
                pause(0.2);
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida 
                movie(handles.axes2,pulgar_der,1,25);
                axes(handles.axes2)
                imshow(azul); 
                writeDigitalPin(a, outputPin1, 0); % Encender el pin  de salida  
                pause(2);
                
            case 5
                
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida 
                writeDigitalPin(a, outputPin1, 0); % Encender el pin  de salida 
                pause(0.2);
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida 
                writeDigitalPin(a, outputPin1, 0); % Encender el pin  de salida 
                pause(0.2);
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida 
                writeDigitalPin(a, outputPin1, 0); % Encender el pin  de salida 
                pause(0.2);
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida 
                writeDigitalPin(a, outputPin1, 0); % Encender el pin  de salida 
                pause(0.2);
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida
                movie(handles.axes1,kick_izq,1,25);
                axes(handles.axes1)
                imshow(azul);
                writeDigitalPin(a, outputPin1, 0); % Apagar el pin  de salida 
                pause(2);
                
            case 6
               
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida 
                writeDigitalPin(a, outputPin1, 0); % Encender el pin  de salida 
                pause(0.2);
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida 
                writeDigitalPin(a, outputPin1, 0); % Encender el pin  de salida 
                pause(0.2);
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida 
                writeDigitalPin(a, outputPin1, 0); % Encender el pin  de salida 
                pause(0.2);
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida 
                writeDigitalPin(a, outputPin1, 0); % Encender el pin  de salida 
                pause(0.2);
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida 
                writeDigitalPin(a, outputPin1, 0); % Encender el pin de salida 
                pause(0.2);
                writeDigitalPin(a, outputPin1, 1); % Encender el pin  de salida 
                movie(handles.axes2,kick_der,1,20);
                axes(handles.axes2)
                imshow(azul);
                writeDigitalPin(a, outputPin1, 0); % Encender el pin  de salida 
                pause(2);
               
        end
    end

clear vars sux cont dist indice k k1 Mrks SF ts vec

% Cerrar la conexión con Arduino
clear a;
