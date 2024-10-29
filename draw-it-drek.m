% DRAW (v2)
% Draw with a robotic arm controlled by a joystick
% Written by Carter, Omri, and Wes
% ENG1101 L34-4
% 24 October 2024

clc
clear

% 
a = arduino('COM11','Uno','Libraries','Servo');
s1 = servo(a, 'D11');
s2 = servo(a, 'D12');
s3 = servo(a, 'D13');
X_JOYSTICK = 'A1';
Y_JOYSTICK = 'A2';
JOY_BUTTON = 'A3';

BASE_DRAWING_HEIGHT = -1;
LIFT_HEIGHT = 2;

u = 5;
v = 5;
x = 5;
y = 0;
h = -1;

while 1
    if (abs(a.readVoltage(X_JOYSTICK) - 2.5) > 0.3)
        x = x + readVoltage(X_JOYSTICK) - 2.5;
    end
    if (abs(a.readVoltage(Y_JOYSTICK) - 2.5) > 0.3)
        y = y + readVoltage(Y_JOYSTICK) - 2.5;
    end
    if (a.readVoltage(JOY_BUTTON) == 0)
        if (h > BASE_DRAWING_HEIGHT)
            h = BASE_DRAWING_HEIGHT;
        else
            h = LIFT_HEIGHT;
        end
        while (a.readVoltage(JOY_BUTTON) == 0)
        end % Wait until button is released
    %if (inRange(x, y, u, v))
        [alpha, beta, omega] = roboArm(x, h, y, u, v);
        disp("Alpha:   " + aloha);
        disp("Beta:    " + beta);
        servoWrite(s1, alpha);
        servoWrite(s2, beta);
        servoWrite(s3, omega);
    %end
end

function servoWrite(Servo, Angle)
    if Angle < 0
        Angle = 0;
    end
    while Angle > 180
        Angle = 180;
    end
    writePosition(Servo, Angle / 180);
end

% Following function is under construction
%function possible = inRange(c, d, u, v)
%    possible = ((c * c + d * d) <= (u * u + 2 * u * v + v * v)) && ((c * c + d * d) >= (u * u - 2 * u * v + v * v));
%end

% See https://www.desmos.com/3d/vgpartrk5s for explanation
function [alpha, beta, omega] = roboArm(a, b, c, u, v)
    alpha = (pi * floor(sqrt(a^2 + c^2) / (u + v + 1)) + atan(b / sqrt(a^2 + c^2)) + acos((a^2 + b^2 + c^2 + u^2 - v^2)*sqrt(a^2 + b^2 + c^2) / (2*u*a*a + 2*u*b*b + 2*u*c*c))) * 180/pi;
    beta = (acos((u^2 + v^2 - a^2 - b^2 - c^2) / (2*u*v))) * 180/pi;
    omega = (pi * floor(a / (u + v + 1)) + atan(c / a)) * 180/pi;
end
