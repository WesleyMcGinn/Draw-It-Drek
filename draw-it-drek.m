% DRAW-IT DREK (v2)
% Draw with a robotic arm controlled by a joystick
% Written by Carter, Omri, and Wesley
% ENG1101 L34-4
% 29 October 2024

clc
clear

% Define components:
a = arduino('COM11','Uno','Libraries','Servo');
s1 = servo(a, 'D12');
s2 = servo(a, 'D11');
s3 = servo(a, 'D13');
X_JOYSTICK = 'A1';
Y_JOYSTICK = 'A2';
JOY_BUTTON = 'A3';

% Define Constants:
BASE_DRAWING_HEIGHT = -1;
LIFT_HEIGHT = 0.5;
DRAWINGSPEED = 0.05;

% Declare variables:
u = 5;
v = 5;
x = 5;
y = 0;
h = 5;

% Prepare Plot:
xData = [];
yData = [];
p = plot(y,x,'o');
xlabel('xJoystick');
ylabel('yJoystick');
title('Drawing');
xlim([(-u-v),(u+v)]);
ylim([0,(u+v)]);
p.XDataSource = 'yData';
p.YDataSource = 'xData';
i = 0;

while 1 % Repeat the following forever:
    % Get Joystick Inputs:
    if (abs(a.readVoltage(X_JOYSTICK) - 2.5) > 0.3) % Horizontal Movement
        x = x + (a.readVoltage(X_JOYSTICK) - 2.5)*DRAWINGSPEED;
    end
    if (abs(a.readVoltage(Y_JOYSTICK) - 2.5) > 0.3) % Vertical Movement
        y = y + (a.readVoltage(Y_JOYSTICK) - 2.5)*DRAWINGSPEED;
    end
    if (a.readVoltage(JOY_BUTTON) == 0)
        if (h > BASE_DRAWING_HEIGHT)
            h = BASE_DRAWING_HEIGHT;
        else
            h = LIFT_HEIGHT;
        end
        while (a.readVoltage(JOY_BUTTON) == 0)
        end % Wait until button is released
    end
    % Draw:
    if (inRange(x, h, y, u, v))
        if (h == BASE_DRAWING_HEIGHT)
            % Plot Drawing Points:
            xData = [xData x];
            yData = [yData y];
            refreshdata
            drawnow
        end
        % Move robotic arm to proper position:
        [alpha, beta, omega] = roboArm(x, h, y, u, v);
        servoWrite(s1, 98 - alpha);
        servoWrite(s2, beta);
        servoWrite(s3, 180 - omega);
    end
    i = i+1;
end

% Writes an angle, from 0 to 180, to a servo:
function servoWrite(Servo, Angle)
    if Angle < 0
        Angle = 0;
    end
    while Angle > 180
        Angle = 180;
    end
    writePosition(Servo, Angle / 180);
end

% Returns true if arm can reach position:
function possible = inRange(a, b, c, u, v)
    possible = (a^2 + b^2 + c^2 <= (u+v)^2) && (a^2 + b^2 + c^2 > (u-v)^2);
end

% The Fido Formulas, Version 3D, in MATLAB function format:
% See https://www.desmos.com/3d/vgpartrk5s for explanation
function [alpha, beta, omega] = roboArm(a, b, c, u, v)
    alpha = (pi * floor(sqrt(a^2 + c^2) / (u + v + 1)) + atan(b / sqrt(a^2 + c^2)) + acos((a^2 + b^2 + c^2 + u^2 - v^2)*sqrt(a^2 + b^2 + c^2) / (2*u*a*a + 2*u*b*b + 2*u*c*c))) * 180/pi;
    beta = (acos((u^2 + v^2 - a^2 - b^2 - c^2) / (2*u*v))) * 180/pi;
    omega = (pi * floor(a / (u + v + 1)) + atan(c / a) + pi/2) * 180/pi;
end
