% DRAW-IT DREK (v3)
% Draw a predefined drawing with a robotic arm
% Written by Carter, Omri, and Wesley
% ENG1101 L34-4
% 30 October 2024

clc
clear

% Define components:
a = arduino('COM11','Uno','Libraries','Servo');
s1 = servo(a, 'D12');
s2 = servo(a, 'D11');
s3 = servo(a, 'D13');

% Define Constants:
BASE_DRAWING_HEIGHT = -3;
LIFT_HEIGHT = 1;
DRAWINGSPEED = 10;

% Declare variables:
u = 14.5;
v = 15;
x = v;
y = 0;
h = u;

% Prepare Plot:
xData = [];
yData = [];
p = plot(y,x,'o');
xlabel('x');
ylabel('y');
title('Drawing');
xlim([(-u-v),(u+v)]);
ylim([0,(u+v)]);
p.XDataSource = 'yData';
p.YDataSource = 'xData';

% Drawing Data:
X = [];
Y = [];
LIFT = [];
for i = 0:120
    X = [X 2.5*sin(i*2*pi/120)+4];
    Y = [Y 2.5*cos(i*2*pi/120)];
    LIFT = [LIFT 0];
end
for i = 121:200
    X = [X -1.7*cos(i*2*pi/160)+4];
    Y = [Y 1.7*sin(i*2*pi/160)];
    LIFT = [LIFT 0];
end
for i = 200:201
    X = [X 5];
    Y = [Y -1];
    LIFT = [LIFT 201-i];
end
for i = 202:203
    X = [X 5];
    Y = [Y 1];
    LIFT = [LIFT 203-i];
end
i = 204;
X = [X 1];
Y = [Y 0];
LIFT = [LIFT 1];
LIFT(120) = 1;
LIFT(121) = 1;
LIFT(200) = 1;
X = X*3;
Y = Y*3;

[alpha, beta, omega] = roboArm(x, h, y, u, v);
servoWrite(s1, 98 - alpha);
servoWrite(s2, beta);
servoWrite(s3, 180 - omega);
input("Press enter when ready.");
for i=1:length(X) % Repeat the following until drawing done:
    pause(1/DRAWINGSPEED);
    x = X(i);
    y = Y(i);
    if (LIFT(i) == 1)
        h = LIFT_HEIGHT;
    else
        h = BASE_DRAWING_HEIGHT;
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
